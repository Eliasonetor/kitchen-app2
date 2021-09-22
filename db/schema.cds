namespace epam.sap.dev.schema;

using {epam.sap.dev.masterdata} from './master-data';
using {epam.sap.dev.common.Measure} from './common';


using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';

entity Products : cuid, managed {
    product_ID           : String(20);
    toProductGroup       : Association to one masterdata.ProductGroups;
    phase : Association to one masterdata.Phases;
    height               : Decimal(13, 3);
    depth                : Decimal(13, 3);
    width                : Decimal(13, 3);
    measure              : Measure @assert.integrity : false;
    price                : Decimal(15, 2);
    currencyCode         : Currency;
    taxRate              : Integer;
    productNetAmount     : Decimal(15, 2);
    productTaxAmount     : Decimal(15, 2);
    productGrossAmount   : Decimal(15, 2);
    productTotalQuantity : Decimal(15, 2);
}

// entity Markets : managed, cuid {
//     toProduct    : Association to Products;
//     toMarketInfo : Association to masterdata.MarketInfos;
//     startDate    : Date;
//     endDate      : Date;
//     status: String;
//     marketNetAmount     : Decimal(15, 2);
//     marketTaxAmount     : Decimal(15, 2);
//     marketGrossAmount   : Decimal(15, 2);    
// }
 
// entity Orders : managed, cuid {
//     toMarket     : Association to Markets;
//     order_ID     : String;
//     quantity     : Integer;
//     calendarYear : String;
//     deliveryDate : Date;
//     orderNetAmount     : Decimal(15, 2);
//     orderTaxAmount     : Decimal(15, 2);
//     orderGrossAmount   : Decimal(15, 2);
// }