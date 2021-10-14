namespace epam.sap.dev.common;

using {
    cuid,
    managed,
    Currency
} from '@sap/cds/common';
using {epam.sap.dev.masterdata} from './master-data';

extend sap.common.Currencies with {
    numcode  : Integer;
    exponent : Integer;
    minor    : String;
}

type Measure : Association to UnitOfMeasure;
entity UnitOfMeasure {
    key msehi   : String(3);
        dimid   : String(6);
        isocode : String(3);
        name    : String(30);
}

type TechnicalFieldControlFlag : Integer @(
    UI.Hidden,
    Core.Computed
);