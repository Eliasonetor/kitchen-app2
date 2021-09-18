namespace epam.sap.dev.schema;

using {epam.sap.dev.masterdata} from './master-data';
using {epam.sap.dev.common} from './common';


using {
    cuid,
    managed
} from '@sap/cds/common';

entity Products : cuid, managed,common.Accounting {
    product_ID           : String(20);
    toProductGroup       : Association to one masterdata.ProductGroups;
    phase : Association to one masterdata.Phases;
    height               : Decimal(13, 3);
    depth                : Decimal(13, 3);
    width                : Decimal(13, 3);
    measure              : Association to one masterdata.UnitOfMeasure;
    // price                : Decimal(15, 2);
    // taxRate              : Integer;
    // productNetAmount     : Decimal(15, 2);
    // productTaxAmount     : Decimal(15, 2);
    // productGrossAmount   : Decimal(15, 2);
    // productTotalQuantity : Decimal(15, 2);
}

entity Markets : managed, cuid {
    toMarketInfo : Association to masterdata.MarketInfos;
    toProduct    : Association to Products;
    startDate    : Date;
    endDate      : Date;
    @cascade : {all}
    order        : Composition of many Orders on order.toMarket = $self;
}
 
entity Orders : managed, cuid {
    toMarket     : Association to Markets;
    order_ID     : String;
    quantity     : Integer;
    calendarYear : String;
    deliveryDate : Date;
}