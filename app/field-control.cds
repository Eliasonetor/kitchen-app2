using {ProductService} from '../srv/services';

annotate ProductService.Products {
    product_ID     @Common.FieldControl : #Mandatory;
    toProductGroup @Common.FieldControl : #Mandatory;
    price          @Common.FieldControl : #Mandatory;
    taxRate        @Common.FieldControl : #Mandatory;
    // productNetAmount @Common.FieldControl : #Mandatory;
    // productTaxAmount @Common.FieldControl : #Mandatory;
    // productGrossAmount @Common.FieldControl : #Mandatory;
    // productTotalQuantity @Common.FieldControl : #Mandatory;
    depth          @Common.FieldControl : #Mandatory;
    width          @Common.FieldControl : #Mandatory;
    height         @Common.FieldControl : #Mandatory;
    phase          @Common.FieldControl : #ReadOnly;
};

annotate ProductService.Markets {
    toMarketInfos @Common.FieldControl : #Mandatory;
    startDate     @Common.FieldControl : #Mandatory;
    endDate       @Common.FieldControl : #Mandatory;
    // status        @Common.FieldControl : #ReadOnly;
};
annotate ProductService.Orders {
    // order_ID @Common.FieldControl : #ReadOnly;
    deliveryDate @Common.FieldControl : #Mandatory;
    quantity @Common.FieldControl : #Mandatory;
    // calendarYear @Common.FieldControl : #Mandatory;
}


