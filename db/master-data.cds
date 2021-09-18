namespace epam.sap.dev.masterdata;

using {epam.sap.dev.schema} from './schema';

entity ProductGroups {
    key ID     : String(20);
    name       : String(20);
    imageURL   : String @UI.IsImageURL;
    imageType  : String @Core.IsMediaType;
}
entity UnitOfMeasure {
    key msehi   : String(3);
        dimid   : String(6);
        isocode : String(3);
        name    : String(30);
}
entity Phases {
    key ID     : Integer;
    name       : String(20);
    criticality: Integer;
}
entity MarketInfos {
    key ID     : Integer;
    name       : String(50);
    code       : String(2);
    imageURL   : String @UI.IsImageURL;
    imageType  : String @Core.IsMediaType;
}

