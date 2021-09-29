const cds = require('@sap/cds')

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

        this.before ('NEW','Products', async (req) => {
            const Planning = 1
            req.data.phase_ID = Planning
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
                if (startDate < today) req.error (400, `Begin Date ${startDate} must not be before today ${today}.`, 'in/BeginDate')
                if (startDate > endDate) req.error (400, `Begin Date ${startDate} must be befroe End Date ${endDate}.`, 'in/BeginDate')
            })
        })

        return super.init()
    }
}
module.exports = {ProductService}









