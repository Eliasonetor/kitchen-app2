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
    productTotalQuantity : Integer default 0;
    @cascade : {all}
    market   : Composition of many Markets on market.toProduct = $self; 
}

entity Markets : managed, cuid {
    toProduct           : Association to Products;
    toMarketInfos       : Association to masterdata.MarketInfos;
    startDate           : Date;
    endDate             : Date;
    status              : String default 'NO';
    marketNetAmount     : Decimal(15, 2);
    marketTaxAmount     : Decimal(15, 2);
    marketGrossAmount   : Decimal(15, 2);
    marketTotalQuantity : Integer default 0;
    currencyCode        : Currency;
    @cascade : {all}
    order   : Composition of many Orders on order.toMarket = $self;
}
 
entity Orders : managed, cuid {
    toMarket         : Association to Markets;
    order_ID         : Integer;
    quantity         : Integer;
    calendarYear     : String;
    deliveryDate     : Date;
    orderNetAmount   : Decimal(15, 2);
    orderTaxAmount   : Decimal(15, 2);
    orderGrossAmount : Decimal(15, 2);
    currencyCode     : Currency;
}