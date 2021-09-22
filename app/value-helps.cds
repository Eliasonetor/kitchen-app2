using epam.sap.dev.schema from '../db/schema';
 
annotate schema.Products with @(
    title       : '{i18n>productService}',
    description : '{i18n>productService}'
) {
    ID              @(
        title       : '{i18n>productID}',
        description : '{i18n>productID}',
    );
 
    product_ID         @(
        title            : '{i18n>product_ID}',
        description      : '{i18n>product_ID}'
    );
 
     productgroup         @(
        title            : '{i18n>product}',
        description      : '{i18n>product}',
        Common.FieldControl : #Mandatory,
        Common.Text : productgroup.name,
        ValueList : { ValueListWithFixedValues:true,
            CollectionPath : 'ProductGroups',
            Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'productgroup_ID',
                ValueListProperty : 'ID'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }                
            ]}
   );
 
    phase @(
        title               : '{i18n>phase}',
        description         : '{i18n>phase}',
 
        Common.Text : phase.name,
        ValueList : { ValueListWithFixedValues:true,
            CollectionPath : 'Phases',
            Parameters     : [
            {
                $Type             : 'Common.ValueListParameterInOut',
                LocalDataProperty : 'phase_ID',
                ValueListProperty : 'ID'
            },
            {
                $Type             : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name'
            }                
            ]}
    );
 
    sizeuom_msehi @(
        title               : '{i18n>UnitOfMeasure}',
        description         : '{i18n>UnitOfMeasure}',
        Common.FieldControl : #ReadOnly
    )
 
};
 
annotate schema.UnitOfMeasure with {
        msehi    @(
        title            : '{i18n>UnitOfMeasure}',
        description      : '{i18n>UnitOfMeasure}')
};
 
annotate schema.ProductGroups with {
         
        ID @ (
        title            : '{i18n>shopID}',
        description      : '{i18n>shopID}'
    );
          
        name      @(
        title            : '{i18n>product}',
        description      : '{i18n>product}'
    );
       
};
 
 
annotate schema.Phases with {
         
        ID @ (
        title            : '{i18n>phaseID}',
        description      : '{i18n>phaseID}'
    );
          
        name      @(
        title            : '{i18n>phase}',
        description      : '{i18n>phase}'
    );
       
};