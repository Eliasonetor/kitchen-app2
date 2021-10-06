using epam.sap.dev.schema from '../db/schema';
using {epam.sap.dev.masterdata} from '../db/master-data';
using {epam.sap.dev.common as mycommon} from '../db/common';
using sap.common as common from '@sap/cds/common';

service ProductService  {
    entity Products as projection on schema.Products;
    entity Markets as projection on schema.Markets
    actions {
        @sap.applicable.path: 'confirmMarketButtonEnabled'
        action confirmMarket();
    };
    entity Orders as projection on schema.Orders;
    @cds.autoexpose entity ProductGroups as projection on masterdata.ProductGroups;
    @cds.autoexpose entity UnitOfMeasure as projection on mycommon.UnitOfMeasure;
    @cds.autoexpose entity MarketInfos as projection on masterdata.MarketInfos;
    @cds.autoexpose entity Phases as projection on masterdata.Phases;
    entity Currencies as projection on common.Currencies;
}