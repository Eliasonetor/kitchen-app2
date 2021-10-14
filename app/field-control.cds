using {ProductService} from '../srv/services';

annotate ProductService.Products {
    product_ID     @Common.FieldControl : #Mandatory;
    toProductGroup @Common.FieldControl : #Mandatory;
    price          @Common.FieldControl : #Mandatory;
    taxRate        @Common.FieldControl : #Mandatory;
    productNetAmount @Common.FieldControl : #ReadOnly;
    productTaxAmount @Common.FieldControl : #ReadOnly;
    productGrossAmount @Common.FieldControl : #ReadOnly;
    productTotalQuantity @Common.FieldControl : #ReadOnly;
    depth          @Common.FieldControl : #Mandatory;
    width          @Common.FieldControl : #Mandatory;
    height         @Common.FieldControl : #Mandatory;
    phase          @Common.FieldControl : #ReadOnly;
};

annotate ProductService.Markets {
    toMarketInfos       @(Common.FieldControl: identifierFieldControlMarket);
    startDate           @(Common.FieldControl: identifierFieldControlMarket);
    endDate             @(Common.FieldControl: identifierFieldControlMarket);
    status              @Common.FieldControl : #ReadOnly;
    marketNetAmount     @Common.FieldControl : #ReadOnly;
    marketTaxAmount     @Common.FieldControl : #ReadOnly;
    marketGrossAmount   @Common.FieldControl : #ReadOnly;
    marketTotalQuantity @Common.FieldControl : #ReadOnly;
};

annotate ProductService.Orders {
    order_ID @Common.FieldControl:#ReadOnly;
    deliveryDate @(Common.FieldControl: identifierFieldControlOrder);
    quantity @(Common.FieldControl: identifierFieldControlOrder);
    calendarYear @Common.FieldControl:#ReadOnly;
    orderNetAmount @Common.FieldControl:#ReadOnly;
    orderTaxAmount @Common.FieldControl:#ReadOnly;
    orderGrossAmount @Common.FieldControl:#ReadOnly;
    currencyCode @Common.FieldControl:#ReadOnly;
}



