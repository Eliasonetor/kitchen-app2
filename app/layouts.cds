using from '../srv/services';
  
annotate ProductService.Products with @(
    UI: {
 SelectionFields: [toProductGroup_ID],
 Identification  : [ {Value: ID} ],
 LineItem: [
     { $Type : 'UI.DataField', Value : toProductGroup.imageURL, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: toProductGroup_ID, ![@UI.Importance]: #High },  
     { $Type : 'UI.DataField', Value: product_ID, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: phase_ID, Criticality: phase.criticality, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: price, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: taxRate, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: height, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: width, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: depth, ![@UI.Importance]: #High }
 ],
 PresentationVariant : {SortOrder : [   
        {   $Type      : 'Common.SortOrderType', Property   : toProductGroup.name, Descending : false },
        {   $Type      : 'Common.SortOrderType', Property   : product_ID, Descending : false }
        ]},
    },
  UI        : {
        HeaderInfo : {
            TypeName       : 'Product',
            TypeNamePlural : 'Products',
            Title          : {Value : toProductGroup_ID},
        },
        HeaderFacets : [
        {
            $Type             : 'UI.ReferenceFacet',
            Target            : '@UI.FieldGroup#Description',
            ![@UI.Importance] : #Medium
        }],
        FieldGroup #Description        : {Data : [
        {   $Type : 'UI.DataField', Value : toProductGroup_ID },   
        {   $Type : 'UI.DataField', Value : toProductGroup.imageURL },
        {   $Type : 'UI.DataField', Value : product_ID },
         ]},
         FieldGroup #Details : {Data : [
        {   $Type : 'UI.DataField', Value : toProductGroup_ID},
        {   $Type : 'UI.DataField', Value : product_ID },
        {   $Type : 'UI.DataField', Value : price},
        {   $Type : 'UI.DataField', Value : taxRate },
        {   $Type : 'UI.DataField', Value : productNetAmount },
        {   $Type : 'UI.DataField', Value : productTaxAmount},
        {   $Type : 'UI.DataField', Value : productGrossAmount },
        {   $Type : 'UI.DataField', Value : productGrossAmount },
        {   $Type : 'UI.DataField', Value : productTotalQuantity }
        ]},
        FieldGroup #Details2 : {Data : [
        {   $Type : 'UI.DataField', Value : phase_ID, Criticality: phase.criticality },
        ]},
        FieldGroup #Details3 : {Data : [
        {   $Type : 'UI.DataField', Value : depth },
        {   $Type : 'UI.DataField', Value : width },
        {   $Type : 'UI.DataField', Value : height },
        ]},
        FieldGroup #AdministrativeData : {Data : [
        {  $Type : 'UI.DataField',  Value : createdBy },
        {  $Type : 'UI.DataField',  Value : createdAt },
        {  $Type : 'UI.DataField',  Value : modifiedBy },
        {  $Type : 'UI.DataField',  Value : modifiedAt }
        ]}
    },
     UI.Facets : [
    {
        $Type  : 'UI.CollectionFacet',
        ID     : 'PODetails',
        Label  : '{i18n>productInfo}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>priceInfo}',
            Target : '@UI.FieldGroup#Details'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>productionInfo}',
            Target : '@UI.FieldGroup#Details2'
        },
         {
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>dimentionsInfo}',
            Target : '@UI.FieldGroup#Details3'
        },
        ]
    },
      {
        $Type  : 'UI.CollectionFacet',
        ID     : 'POAdmininfo',
        Label  : '{i18n>adminInfo}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>adminInfo}',
            Target : '@UI.FieldGroup#AdministrativeData'
        }
        ]
    },
    ]
  
);