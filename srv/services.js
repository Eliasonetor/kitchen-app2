const cds = require('@sap/cds')
const {Products} = cds.entities
module.exports = cds.service.impl(srv =>{
    srv.before (['CREATE','UPDATE'],'Products', _checkPriceAndTaxRateNotNegative)
//     srv.before (['CREATE','UPDATE'],'Products', async (req) => {
//     const product = req.data
//     const tx = cds.transaction(req)
//     const Rows = await tx.run (
//       SELECT (Products)
//         .where ({ toProductGroup_ID: {'=': product.toProductGroup_ID}})
//     )
//     if (Rows === 0) return req.error (409, 'Sold out, sorry', 'amount')
//   })
    // srv.after ('CREATE','Products',_defaultPhase)
})

function _checkPriceAndTaxRateNotNegative (req)
{
       const { price,taxRate }  = req.data;
       if (!price || price <= 0) req.error (400, 'Understated price. Should be higher than 0 as we suppose.');
       if (taxRate < 0) req.error (400, 'Wrong tax rate input. Please clarify.');  
}

// function _defaultPhase (req)
// {
//     const { phase_ID } = req.data;
    
// }

