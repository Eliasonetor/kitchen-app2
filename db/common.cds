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

type CurrencyType : Decimal(15, 2)@(
    Semantics.amount.currencyCode : 'CURRENCY_code',
    sap.unit                      : 'CURRENCY_code'
);

aspect Accounting {
    currency             : Currency;
    price                : CurrencyType;
    taxRate              : CurrencyType;
    productNetAmount     : CurrencyType;
    productTaxAmount     : CurrencyType;
    productGrossAmount   : CurrencyType;
    productTotalQuantity : CurrencyType;
}
