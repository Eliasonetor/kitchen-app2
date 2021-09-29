using { epam.sap.dev.schema } from '../db/schema';

annotate ProductService.Products with {
    product_ID           @title : '{i18n>product_ID}';
    toProductGroup       @title : '{i18n>toProductGroup}' @Common.Text: toProductGroup.name @Common.TextArrangement: #TextFirst;
    phase                @title : '{i18n>phase}' @Common.Text: phase.name @Common.TextArrangement: #TextFirst;
    height               @title : '{i18n>height}' @Measures.Unit : measure_msehi;
    depth                @title : '{i18n>depth}'@Measures.Unit : measure_msehi;
    width                @title : '{i18n>width}'@Measures.Unit : measure_msehi;
    measure              @title : '{i18n>measure}';
    price                @title : '{i18n>price}' @Measures.ISOCurrency: currencyCode_code;
    currencyCode         @title : '{i18n>currencyCode}';
    taxRate              @title : '{i18n>taxRate}';
    productNetAmount     @title : '{i18n>productNetAmount}'@Measures.ISOCurrency: currencyCode_code;
    productTaxAmount     @title : '{i18n>productTaxAmount}'@Measures.ISOCurrency: currencyCode_code;
    productGrossAmount   @title : '{i18n>productGrossAmount}'@Measures.ISOCurrency: currencyCode_code;
    productTotalQuantity @title : '{i18n>productTotalQuantity}';
};

annotate ProductService.UnitOfMeasure {
    msehi @title : '{i18n>msehi}';
};

annotate ProductService.Markets with{
    toProduct         @title : '{i18n>toProduct}';
    toMarketInfos     @title : '{i18n>toMarketInfos}' @Common.Text: toMarketInfos.name @Common.TextArrangement: #TextFirst;
    startDate         @title : '{i18n>startDate}';
    endDate           @title : '{i18n>endDate}';
    status            @title : '{i18n>status}';
    marketNetAmount   @title : '{i18n>marketNetAmount}'@Measures.ISOCurrency: currencyCode_code;
    marketTaxAmount   @title : '{i18n>marketTaxAmount}'@Measures.ISOCurrency: currencyCode_code;
    marketGrossAmount @title : '{i18n>marketGrossAmount}'@Measures.ISOCurrency: currencyCode_code;
    currencyCode      @title : '{i18n>currencyCode}';
};

annotate ProductService.Orders {
    toMarket         @title : '{i18n>toMarket}';
    order_ID         @title : '{i18n>order_ID}';
    quantity         @title : '{i18n>quantity}';
    calendarYear     @title : '{i18n>calendarYear}';
    deliveryDate     @title : '{i18n>deliveryDate}';
    orderNetAmount   @title : '{i18n>orderNetAmount}' @Measures.ISOCurrency: currencyCode_code;
    orderTaxAmount   @title : '{i18n>orderTaxAmount}' @Measures.ISOCurrency: currencyCode_code;
    orderGrossAmount @title : '{i18n>orderGrossAmount}' @Measures.ISOCurrency: currencyCode_code;
    currencyCode     @title : '{i18n>currencyCode}';
}



