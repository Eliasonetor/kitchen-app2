using epam.sap.dev.schema from '../db/schema';
 
annotate schema.Products {

    toProductGroup @Common.ValueList: {
    CollectionPath : 'ProductGroups',
    Label : 'Product',
    Parameters : [
      {$Type: 'Common.ValueListParameterInOut', LocalDataProperty: toProductGroup_ID, ValueListProperty: 'ID'},
      {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name'}
    ],
    SearchSupported : true
  };

    currencyCode @Common.ValueList: {
    CollectionPath : 'Currencies',
    Label : 'CurrencyCode',
    Parameters : [
      {$Type: 'Common.ValueListParameterInOut', LocalDataProperty: currencyCode_code, ValueListProperty: 'code'},
      {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name'},
      {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'descr'},
      {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'symbol'},
      {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'minor'}
    ],
    SearchSupported : true
  };

    measure @Common.ValueList: {
    CollectionPath : 'UnitOfMeasure',
    Label : 'Measure',
    Parameters : [
      {$Type: 'Common.ValueListParameterInOut', LocalDataProperty: measure_msehi, ValueListProperty: 'msehi'},
      {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name'}
    ],
    SearchSupported : true
  };

//     phase @Common.ValueList: {
//     CollectionPath : 'Phases',
//     Label : 'Phases',
//     Parameters : [
//       {$Type: 'Common.ValueListParameterInOut', LocalDataProperty: phase_ID, ValueListProperty: 'ID'},
//       {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name'}
//     ],
//     SearchSupported : true
//   };

}

annotate schema.Markets {
    toMarketInfos @Common.ValueList: {
    CollectionPath : 'MarketInfos',
    Label : 'MarketInfos',
    Parameters : [
      {$Type: 'Common.ValueListParameterInOut', LocalDataProperty: toMarketInfos_ID, ValueListProperty: 'ID'},
      {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'name'},
      {$Type: 'Common.ValueListParameterDisplayOnly', ValueListProperty: 'code'}
    ],
    SearchSupported : true
  };
}

