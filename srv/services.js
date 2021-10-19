const cds = require('@sap/cds');require('./workarounds')

let arrayMarketsID = []
const FieldControl = {
    Mandatory: 7,
    Optional: 3,
    ReadOnly: 1,
    Inapplicable: 0
};

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

        this.before ('NEW', 'Markets', async (req) =>{
            const { toProduct_ID } = req.data
            const {currencyCode} = await SELECT.one `currencyCode_code as currencyCode` .from(Products.drafts) .where({ ID:toProduct_ID })
            req.data.currencyCode_code = currencyCode
        })

        this.before ('SAVE','Products', async (req) => {
            if(req.data.market.length !=0)
            {
                const productID = req.data.ID
                const {netAmount,taxAmount,grossAmount,totalQuantity} = await SELECT.one `sum(marketNetAmount) as netAmount,sum(marketTaxAmount) as taxAmount,sum(marketGrossAmount) as grossAmount,sum(marketTotalQuantity) as totalQuantity` .from(Markets.drafts) .where({ toProduct_ID:productID })
                return UPDATE (Products,productID) .with({ productNetAmount: netAmount,productTaxAmount: taxAmount,productGrossAmount: grossAmount,productTotalQuantity: totalQuantity })
            }
        })

        this.after('READ', 'Products', (each) => {
            //for new inquires only
            if (each.phase_ID != 4 ) { 
                each.MoveEnabled = true
            }
        }) 

        this.on ('Move','Products', async (req) => {
            const {ID} = req.params[0]
            const today = (new Date).toISOString().slice(0,10)
            const {countMarkets} = await SELECT.one `count(ID) as countMarkets` .from(Markets) .where({toProduct_ID:ID})
            const {countConfirmedMarkets} = await SELECT.one `count(status) as countConfirmedMarkets` .from(Markets) .where({toProduct_ID:ID,status:`YES`})
            const {countFinishedMarkets} = await SELECT.one `count(ID) as countFinishedMarkets` .from(Markets) .where `toProduct_ID = ${ID} and endDate <= ${today}`
            const {phase} = await SELECT.one `phase_ID as phase` .from(Products,ID)
            switch (phase)
            {
                case `1`:
                    if(countMarkets>0)
                    {
                        return UPDATE(Products,ID) .with({phase_ID:`2`})
                    }
                    else
                    {
                        req.error (400,`Can't move to the Development, because markets were not assigned to the product`)
                    }
                    break;
                case `2`:
                    if(countConfirmedMarkets>0)
                    {
                        return UPDATE(Products,ID) .with({phase_ID:`3`})
                    }
                    else
                    {
                        req.error (400,`Can't move to the Production, because no one market was confirmed`)
                    }
                    break;
                case `3`:
                    if(countFinishedMarkets == countMarkets)
                    {
                        return UPDATE(Products,ID) .with({phase_ID:`4`})
                    }
                    else
                    {
                        req.error (400,`Can't complete all & move to OUT phase, because markets didn't complete production`)
                    }
                    break;
            }
        })

        // this.before ('CANCEL','Orders', async (_) => {
        //     let i = 0
        //     let arrayOrdersUpdate = []
        //     let OrdersDelete
        //     const {ID} = _.data
        //     const {Market_ID,orderID} = await SELECT.one `toMarket_ID as Market_ID,order_ID as orderID` .from(Orders.drafts) .where({ID:ID})
        //     const {maxorderID,countOrders} = await SELECT.one `max(order_ID) as maxorderID,count(ID) as countOrders` .from(Orders.drafts) .where({toMarket_ID:Market_ID})
        //     if(orderID != maxorderID && countOrders !=1 )
        //     {
        //         let arrayOrders = []
        //         arrayOrders = await SELECT `ID`.from(Orders.drafts) .where `ID != ${ID} and toMarket_ID = ${Market_ID}`
        //         let i = 0
        //         let newOrder_ID =0
        //         while ( i< arrayOrders.length)
        //         {
        //             const arrayOrderUUID = arrayOrders[i].ID
        //             newOrder_ID++
        //             i++
        //             return UPDATE(Orders.drafts,arrayOrderUUID).with ({order_ID:newOrder_ID})
        //         }
        //     }
        //     // arrayOrdersUpdate = DELETE (Orders.drafts,ID)
        //     // return arrayOrdersUpdate
        // })

        // this.before ('CANCEL','Orders', async (_) => {
        //     const {ID} = _.data
        //     const {Market_ID} = await SELECT.one `toMarket_ID as Market_ID` .from(Orders.drafts) .where({ID:ID})
        //     const {countOrders} = await SELECT.one `count(ID) as countOrders` .from(Orders.drafts) .where `ID != ${ID} and toMarket_ID = ${Market_ID}`
        //     if(countOrders == 0)
        //     {
        //         return UPDATE (Markets.drafts,Market_ID) .with ({marketTotalQuantity: 0,marketNetAmount: 0,marketTaxAmount: 0,marketGrossAmount: 0 })                
        //     }
        //     else
        //     {
        //         const {netAmount,taxAmount,grossAmount,totalQuantity} = await SELECT.one `sum(orderNetAmount) as netAmount,sum(orderTaxAmount) as taxAmount,sum(orderGrossAmount) as grossAmount,sum(quantity) as totalQuantity` .from(Orders.drafts) .where `ID != ${ID} and toMarket_ID = ${Market_ID}`
        //         return UPDATE (Markets.drafts,Market_ID) .with ({marketTotalQuantity: totalQuantity,marketNetAmount: netAmount,marketTaxAmount: taxAmount,marketGrossAmount: grossAmount })                
        //     }
        // })

        this.before ('CANCEL','Orders', async (_) => {
            const {ID} = _.data
            arrayMarketsID.push(ID)
            const {Market_ID} = await SELECT.one `toMarket_ID as Market_ID` .from(Orders.drafts) .where({ID:ID})
            const {countOrders} = await SELECT.one `count(ID) as countOrders` .from(Orders.drafts) .where `toMarket_ID = ${Market_ID}`
            let countOrdersFinal = countOrders - arrayMarketsID.length
            if(countOrdersFinal == 0)
            {
                return UPDATE (Markets.drafts,Market_ID) .with ({marketTotalQuantity: 0,marketNetAmount: 0,marketTaxAmount: 0,marketGrossAmount: 0 })                
            }
            // else
            // {
            //     const {netAmount,taxAmount,grossAmount,totalQuantity} = await SELECT.one `sum(orderNetAmount) as netAmount,sum(orderTaxAmount) as taxAmount,sum(orderGrossAmount) as grossAmount,sum(quantity) as totalQuantity` .from(Orders.drafts) .where `ID != ${ID} and toMarket_ID = ${Market_ID}`
            //     return UPDATE (Markets.drafts,Market_ID) .with ({marketTotalQuantity: totalQuantity,marketNetAmount: netAmount,marketTaxAmount: taxAmount,marketGrossAmount: grossAmount })                
            // }
        })

        this.after('READ', 'Markets', (each) => {
            //for new inquires only
            if (each.status == 'NO' ) { 
                each.confirmMarketEnabled = true
            }
        }) 

        this.on ('confirmMarket','Markets', async (req) => {
            const {ID} = req.params[1]
            return UPDATE (Markets.drafts,ID) .with ({status:'YES'})
        })

        this.before ('NEW','Orders', async (req) => {
            const { toMarket_ID } = req.data
            const {orderID} = await SELECT.one `max(order_ID) as orderID` .from(Orders.drafts) .where({toMarket_ID})
            req.data.order_ID = orderID + 1;
        })

        this.after ('PATCH', 'Orders', async (_,req) => { 
            if ('deliveryDate' in req.data) {
                const {deliveryDate,ID} = req.data
                let calendarYear = (new Date (deliveryDate)).getFullYear()
                return UPDATE (Orders.drafts,ID) .with ({calendarYear: calendarYear })
            }
    })

        this.before ('NEW', 'Orders', async (req) =>{
            const { toMarket_ID } = req.data
            const {ProductID} = await SELECT.one ` toProduct_ID as ProductID ` .from(Markets.drafts) .where({ ID:toMarket_ID })
            const {currencyCode} = await SELECT.one `currencyCode_code as currencyCode` .from(Products.drafts) .where({ ID:ProductID })
            req.data.currencyCode_code = currencyCode
        })

        this.after ('PATCH', 'Orders', (_,req) => { if ('quantity' in req.data) {
            const {ID,quantity} = req.data
            return this._update_totals (ID,quantity)
        }})

        this._update_totals = async function (order,quantity) {
            const {toMarket_ID} = await SELECT.one `toMarket_ID` .from(Orders.drafts,order)
            const {toProduct_ID} = await SELECT.one `toProduct_ID` .from(Markets.drafts,toMarket_ID)
            const {price,taxRate} = await SELECT.one `price,taxRate` .from(Products.drafts,toProduct_ID)
            return UPDATE (Orders.drafts,order) .with ({
                orderNetAmount:quantity * price,
                orderTaxAmount:quantity * price * (taxRate/100),
                orderGrossAmount:(quantity * price) + (quantity * price * (taxRate/100))
            })
        }

        this.after ('PATCH', 'Orders', async (_,req) => { 
            if (`quantity` in req.data) {
                const {quantity,ID} = req.data
                const {MarketID} = await SELECT.one `toMarket_ID as MarketID` .from(Orders.drafts,ID)
                const {calendarYear} = await SELECT.one `calendarYear` .from(Orders.drafts,ID)
                const {deliveryDate} = await SELECT.one `deliveryDate` .from(Orders.drafts,ID)
                const {netAmount,taxAmount,grossAmount,totalQuantity} = await SELECT.one `sum(orderNetAmount) as netAmount,sum(orderTaxAmount) as taxAmount,sum(orderGrossAmount) as grossAmount,sum(quantity) as totalQuantity` .from(Orders.drafts) .where({ toMarket_ID:MarketID })
                let i = 0
                return UPDATE (Markets.drafts,MarketID) .with ({marketTotalQuantity: totalQuantity,marketNetAmount: netAmount,marketTaxAmount: taxAmount,marketGrossAmount: grossAmount })
            }
    })

        this.after (['READ','EDIT'], 'Orders', setTechnicalFlagsOrder);

        function setTechnicalFlagsOrder (Orders) {

            function _setFlagsReadOrder (Orders) {
                Orders.identifierFieldControlOrder = FieldControl.ReadOnly;
                Orders.identifierFieldControlCalculated = FieldControl.ReadOnly;
            }
            function _setFlagsEditOrder (Orders) {
                Orders.identifierFieldControlOrder = FieldControl.Mandatory;
                Orders.identifierFieldControlCalculated = FieldControl.ReadOnly;
            }

            if (Array.isArray(Orders)) {
                Orders.forEach(_setFlagsReadOrder);
            }
            else {
                _setFlagsEditOrder(Orders);
            }
            
        }

        this.after (['READ','EDIT'], 'Markets', setTechnicalFlagsMarket);

        function setTechnicalFlagsMarket (Markets) {

            function _setFlagsReadMarket (Markets) {
                Markets.identifierFieldControlMarket = FieldControl.ReadOnly;
                Markets.identifierFieldControlCalculated = FieldControl.ReadOnly;
            }
            function _setFlagsEditMarket (Markets) {
                Markets.identifierFieldControlMarket = FieldControl.Mandatory;
                Markets.identifierFieldControlCalculated = FieldControl.ReadOnly;
            }

            if (Array.isArray(Markets)) {
                Markets.forEach(_setFlagsReadMarket);
            }
            else {
                _setFlagsEditMarket(Markets);
            }

        }

        return super.init()
    }
}
module.exports = {ProductService}









