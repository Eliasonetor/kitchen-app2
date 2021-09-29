namespace epam.sap.dev.masterdata;

using {epam.sap.dev.schema} from './schema';

entity ProductGroups {
    key ID     : String;
    name       : String(20);
    imageURL   : String @UI.IsImageURL;
    imageType  : String @Core.IsMediaType;
}
entity Phases {
    key ID     : String;
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

