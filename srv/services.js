const cds = require('@sap/cds');require('./workarounds')

class ProductService extends cds.ApplicationService{
    init(){
        const { Products, Markets, Orders } = this.entities

        function _checkPriceAndTaxRateNotNegative(req)
        {
            const { price,taxRate }  = req.data
            if (price <= 0) req.error (400, 'Understated price. Should be higher than 0 as we suppose.')
            if (taxRate < 0) req.error (400, 'Wrong tax rate input. Please clarify.')  
        }

        function _checkHeightAndDepthAndWidthNotNegative (req)
        {
            const { height,depth,width }  = req.data
            if (height <= 0) req.error (400, 'Understated height. Should be higher than 0 as we suppose.')
            if (depth <= 0) req.error (400, 'Understated depth. Should be higher than 0 as we suppose.')
            if (width <= 0) req.error (400, 'Understated width. Should be higher than 0 as we suppose.')
        }

        this.before (['CREATE','UPDATE'],'Products', _checkPriceAndTaxRateNotNegative)

        this.before (['CREATE','UPDATE'],'Products', _checkHeightAndDepthAndWidthNotNegative)

        this.before ('CREATE','Products', async (req) => {
            const { product_ID,toProductGroup_ID } = req.data
            const ID  = await SELECT.one `product_ID as ID` .from(Products) .where({toProductGroup_ID,product_ID})
            if(ID != null) req.error (400, `Current Product ID ${product_ID} for ${toProductGroup_ID} already exists.`)            
        })

        this.before ('UPDATE','Products', async (req) => {
            const { product_ID,toProductGroup_ID,ID } = req.data
            const model  = await SELECT.one `product_ID as model` .from(Products) .where({toProductGroup_ID,product_ID}) .and ('ID !=', ID)
            if(model != null) req.error (400, `Current Product ID ${product_ID} for ${toProductGroup_ID} already exists.`)            
        })

        this.before (['CREATE','NEW'],'Products', async (req) => {
            req.data.phase_ID = 1
        })
        
        this.before ('SAVE','Products', async (req) => {
            if( req.data.market.length != 0 )
            {
                let currentToMarketInfosID = req.data.market[req.data.market.length-1].toMarketInfos_ID
                let i = 0
                let j = 2
                while (i < req.data.market.length -j +1 ){
                    if( req.data.market[i].toMarketInfos_ID === currentToMarketInfosID
                        && currentToMarketInfosID !=null && currentToMarketInfosID != undefined )
                    {
                        req.error (400, `Current Market ${req.data.market[i].toMarketInfos_ID} already exists.`)
                    }

                    i++

                    if(i === req.data.market.length -j +1 && req.data.market.length -j > 0)
                    {
                        i = 0
                        currentToMarketInfosID = req.data.market[req.data.market.length-j].toMarketInfos_ID
                        j++
                    }
                }
            }
            const marketItems = req.data.market
            const today = (new Date).toISOString().slice(0,10)
            if(marketItems != null) marketItems.forEach (async (marketItem) => {
                const { startDate,endDate } = marketItem
                let i =0;
                while ( i< marketItem.order.length)
                {
                    if( marketItem.order[i].deliveryDate && marketItem.order[i].deliveryDate != null
                        && marketItem.order[i].deliveryDate != undefined )
                        {
                            if (marketItem.order[i].deliveryDate < startDate) req.error (400, `Delivery Date ${marketItem.order[i].deliveryDate} must not be before Start Date- ${startDate}.`, 'in/DeliveryDate')
                            if (marketItem.order[i].deliveryDate > endDate) req.error (400, `Delivery Date ${marketItem.order[i].deliveryDate} must be before End Date- ${endDate}.`, 'in/DeliveryDate')
                            i++
                        }
                }
                if (startDate < today) req.error (400, `Begin Date ${startDate} must not be before today ${today}.`, 'in/BeginDate')
                if (startDate > endDate) req.error (400, `Begin Date ${startDate} must be befroe End Date ${endDate}.`, 'in/BeginDate')
            })
        })

        this.before ('NEW', 'Markets', async (req) => {
            req.data.status = 'NO'
        })

        this.on ('confirmMarket', req => {
            return UPDATE (req._target) .with ({status:'YES'})
            let i = 0;
        })

        this.before ('NEW','Orders', async (req) => {
            const { toMarket_ID } = req.data
            const {orderID} = await SELECT.one `max(order_ID) as orderID` .from(Orders.drafts) .where({toMarket_ID})
            req.data.order_ID = orderID + 1;
        })

        this.after ('PATCH', 'Orders', async (_,req) => { if ('deliveryDate' in req.data) {
            const {deliveryDate,ID} = req.data
            let calendarYear = (new Date (deliveryDate)).getFullYear()
            return UPDATE (Orders.drafts,ID) .with ({calendarYear: calendarYear })
        }})

        this.before ('NEW', 'Orders', async (req) =>{
            const { toMarket_ID } = req.data
            const {ProductID} = await SELECT.one ` toProduct_ID as ProductID ` .from(Markets.drafts) .where({ ID:toMarket_ID })
            const {currencyCode} = await SELECT.one `currencyCode_code as currencyCode` .from(Products.drafts) .where({ ID:ProductID })
            req.data.currencyCode_code = currencyCode
        })

        this.after ('PATCH', 'Orders', (_,req) => { if ('quantity' in req.data) {
            const {ID} = req.data
            return this._update_totals (ID)
        }})

        this._update_totals = async function (order) {
            const {quantity} = await SELECT.one `quantity` .from(Orders.drafts,order)
            const {toMarket_ID} = await SELECT.one `toMarket_ID` .from(Orders.drafts,order)
            const {toProduct_ID} = await SELECT.one `toProduct_ID` .from(Markets.drafts,toMarket_ID)
            const {price} = await SELECT.one `price` .from(Products.drafts,toProduct_ID)
            const {taxRate} = await SELECT.one `taxRate` .from(Products.drafts,toProduct_ID)
            return UPDATE (Orders.drafts,order) .with ({
                orderNetAmount:quantity * price,
                orderTaxAmount:quantity * price * (taxRate/100),
                orderGrossAmount:(quantity * price) + (quantity * price * (taxRate/100))
            })

        }

        return super.init()
    }
}
module.exports = {ProductService}









