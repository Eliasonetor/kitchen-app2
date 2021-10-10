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
    {
        $Type  : 'UI.ReferenceFacet',
        Label  : '{i18n>marketsInfo}',
        Target : 'market/@UI.LineItem'
    }
    ]
  
);

annotate ProductService.Markets with @ (
 UI: {
 Identification: [{Value: toMarketInfos_ID }],
 SelectionFields: [toMarketInfos_ID],
 LineItem: [
     { $Type  : 'UI.DataFieldForAction', Action : 'ProductService.confirmMarket',   Label  : '{i18n>confirmMarket}'   },
     { $Type : 'UI.DataField', Value: toMarketInfos.imageURL, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: toMarketInfos_ID, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: startDate, ![@UI.Importance]: #High }, 
     { $Type : 'UI.DataField', Value: endDate, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: status, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: marketNetAmount, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: marketTaxAmount, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: marketGrossAmount, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: marketTotalQuantity, ![@UI.Importance]: #High }  
 ],
 HeaderInfo : { TypeName: 'Market', TypeNamePlural : 'Markets', Title : {Value : toMarketInfos_ID} },
 HeaderFacets : [{ $Type: 'UI.ReferenceFacet', Target: '@UI.FieldGroup#Description', ![@UI.Importance] : #Medium }],
        FieldGroup #Description        : {Data : [
        {   $Type : 'UI.DataField', Value : toMarketInfos_ID },
        {   $Type : 'UI.DataField', Value : toMarketInfos.imageURL },
        ]},
        FieldGroup #Details : {Data : [
        {   $Type : 'UI.DataField', Value : startDate },
        {   $Type : 'UI.DataField', Value : endDate, ![@UI.Importance] : #Medium },
        {   $Type : 'UI.DataField', Value : status, ![@UI.Importance] : #Medium },
        {   $Type : 'UI.DataField', Value : marketNetAmount, ![@UI.Importance] : #Medium },
        {   $Type : 'UI.DataField', Value : marketTaxAmount, ![@UI.Importance] : #Medium },
        {   $Type : 'UI.DataField', Value : marketGrossAmount, ![@UI.Importance] : #Medium },
        {   $Type : 'UI.DataField', Value : marketTotalQuantity, ![@UI.Importance] : #Medium }
        ]}
    },
     UI.Facets : [
    {
        $Type  : 'UI.CollectionFacet',
        ID     : 'PODetails2',
        Label  : '{i18n>marketInfo}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>marketInfo}',
            Target : '@UI.FieldGroup#Description'
        }
        ]
    },
      {
        $Type  : 'UI.CollectionFacet',
        ID     : 'POAdmininfo2',
        Label  : '{i18n>marketDetails}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>marketDetails}',
            Target : '@UI.FieldGroup#Details'
        }        ]
    },
    {
        $Type  : 'UI.ReferenceFacet',
        Label  : '{i18n>ordersInfo}',
        Target : 'order/@UI.LineItem'
    }
    ]
);

annotate ProductService.Orders with @ (
 UI: {
 Identification: [{Value: deliveryDate}],
 SelectionFields: [deliveryDate],
 LineItem: [
     { $Type : 'UI.DataField', Value: order_ID, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: deliveryDate, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: quantity,![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: calendarYear, ![@UI.Importance]: #High }, 
     { $Type : 'UI.DataField', Value: orderNetAmount, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: orderTaxAmount, ![@UI.Importance]: #High },
     { $Type : 'UI.DataField', Value: orderGrossAmount, ![@UI.Importance]: #High },
 ],
 HeaderInfo : { TypeName: 'Order', TypeNamePlural: 'Orders', Title: {Value : deliveryDate},},
 HeaderFacets : [
        {
            $Type             : 'UI.ReferenceFacet',
            Target            : '@UI.FieldGroup#Description',
            ![@UI.Importance] : #Medium
        }
        ],
        FieldGroup #Description: {Data : [
        { $Type : 'UI.DataField', Value : order_ID },
        { $Type : 'UI.DataField', Value : deliveryDate },
        { $Type : 'UI.DataField', Value : quantity },
        { $Type : 'UI.DataField', Value : calendarYear }       
        ]},
        FieldGroup #Details : {Data : [
        {   $Type : 'UI.DataField', Value : orderNetAmount, ![@UI.Importance] : #Medium },
        {   $Type : 'UI.DataField', Value : orderTaxAmount, ![@UI.Importance] : #Medium },
        {   $Type : 'UI.DataField', Value : orderGrossAmount, ![@UI.Importance] : #Medium },
        ]},
        FieldGroup #AdministrativeData : {Data : [
        {  $Type : 'UI.DataField', Value : createdBy },
        {  $Type : 'UI.DataField', Value : createdAt },
        {  $Type : 'UI.DataField', Value : modifiedBy },
        {  $Type : 'UI.DataField', Value : modifiedAt }]}},
UI.Facets : [
    {   $Type  : 'UI.CollectionFacet',
        ID     : 'PODetails3',
        Label  : '{i18n>orderInfo}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>orderInfo}',
            Target : '@UI.FieldGroup#Description'
        },
        {
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>orderInfo}',
            Target : '@UI.FieldGroup#Details'
        }
        ]
    },
      { $Type  : 'UI.CollectionFacet',
        ID     : 'POAdmininfo3',
        Label  : '{i18n>adminInfo}',
        Facets : [{
            $Type  : 'UI.ReferenceFacet',
            Label  : '{i18n>adminInfo}',
            Target : '@UI.FieldGroup#AdministrativeData'
        }]
    }
    ]
);
