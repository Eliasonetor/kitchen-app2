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
}
