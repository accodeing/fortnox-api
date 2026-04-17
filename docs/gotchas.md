# Gotchas
Fortnox API is not perfect. There are a couple of things to take into consideration when using it.

## Article
If you create a new Article, the `SalesAccount` will default to the default sales account set in the Fortnox settings. An interesting thing though is that this account might not exist in the chart of accounts. Therefore, this strange thing can happen (requests and responses below are the raw HTTP requests/responses):

1. You create an new Article via the API: `'{"Article":{"Description":"A value","SalesAccount":1250}}'` and you get an Article back that has `SalesAccount` set: `'{"Article":{"Description":"A Value",  "SalesAccount":1250, "PurchaseAccount":4000, ...}}'`.
2. You try to update the newly created Article with `'{"Article":{"Description":"Updated description"}}'` and you get this back:
`'{"ErrorInformation":{"error":1,"message":"Inköpskonto inte uppdaterat. Kontot \"4000\" existerar inte. (PurchaseAccount)", ...}}'`

We haven't even touched the `SalesAccount` but you still get an error. So the account that the API says that the Article has does not necessarily need to exist in "reality"...

## HouseWorkType
### Legacy types
Not all HouseWorkTypes available are possible to use when creating a new `Order` or `Invoice`. For instance, creating an `OrderRow` with `HouseWorkType` set to `COOKING` returns:
> Skattereduktion för en av de valda husarbetestyperna har upphört.

Unfortunately, their documentation does not tell you which types are deprecated... In fact, the deprecated types are simply removed from their documentation, so if you fetch an old `Order`/`Invoice`, you have no clue what HouseWorkType can be set to! There are two constants available in the gem: `CURRENT_HOUSEWORK_TYPES` and `LEGACY_HOUSEWORK_TYPES`, but we cannot guarantee that they are up to date and that they include all possible values.

### OTHERCOSTS
Another weird thing is that the option `OTHERCOSTS` is not allowed to be combined with `HouseWork` attribute. Yes, that is true...

## VAT on Invoices and Orders rows

If you create an Invoice with the following data:

```
$ curl -X "POST" "https://api.fortnox.se/3/invoices" \
>      (credentials...)
>      -d $'{
>        "Invoice": {
>          "CustomerNumber": "188",
>            "InvoiceRows": [
>            {
>              "ArticleNumber": "1",
>              "DeliveredQuantity": "10.00",
>              "VAT": "25"
>            }
>            ]
>        }
>      }'
```

You get the following when you query the created Invoice:

```
{"Invoice":
  {...,
  "InvoiceRows":[
    {
      ...
      DeliveredQuantity":"10.00",
      ...,
      "Price":100,
      "PriceExcludingVAT":100,
      ...,
      "Total":1000,
      "TotalExcludingVAT":1000,
      "Unit":"",
      "VAT":25}
  ]
```

Notice that the `Price` and `PriceExcludingVAT` have the exact same amount. The same goes for `Total` and `TotalExcludingVAT`. Strange, right? The `VAT` is set to `25`%.

It works like this: `Invoice` (and `Order`) has a `VATIncluded` attribute. If it is set to `true`, `Price` and `Total` will be VAT included and `PriceExcludingVAT` and `TotalExcludingVAT` will obviously be VAT excluded. BUT if you set `VATIncluded` to false, all those attributes will be VAT exclusive and none inclusive. If you want to know the VAT for each row, then you have to calculate it yourself! I have suggested to Fortnox to fix this weird logic by adding a `TotalVAT` and `PriceWithVAT` that always holds the `VAT` amount. Then `Price` and `Total` can be VAT included/excluded depending on the value of `VATIncluded`. Fortnox said they will add this to their to do list...

## Dependent attributes
Some attributes depends on other attributes.

### `Invoice.InvoiceRows.Discount`
`Discount` have two different limits depending on `DiscountType`. Calling Fortnox with
```
{
  "Invoice":{
    "CustomerNumber":"1",
    "InvoiceRows":[
      {"ArticleNumber":"0000","Discount":12.0001,"DiscountType":"PERCENT","Price":20.0}
    ]
  }
}
```
gives an `InvoiceRow` with `"Discount":12,"DiscountType":"PERCENT"`

Calling Fortnox with
```
{
  "Invoice":{
    "CustomerNumber":"1",
    "InvoiceRows":[
      {"ArticleNumber":"0000","Discount":123456.0,"DiscountType":"PERCENT","Price":20.0}
    ]
  }
}
```
gives
```
     Fortnox::RequestError:
       Ogiltig rabatt. Får inte överstiga 100 %
```

## Types
### Type of attribute DocumentNumber
`Customer` attribute `DocumentNumber` can be both an `Integer` and a `String` according to Fortnox... See [#78](https://github.com/accodeing/fortnox-api/issues/78).

### Default values for Date attributes
The default values for date attributes from Fortnox API can be either an empty string or null. Fortnox is working on the issue. See [#79](https://github.com/accodeing/fortnox-api/issues/79).

## Strange error messages
### InternalError when creating Order without OrderRows
Creating an `Order` without `OrderRows` returns `InternalError`. Fortnox is working on this issue. See [#84](https://github.com/accodeing/fortnox-api/issues/84).

### Kunde inte hitta konto.
If you create an `Order` or `Invoice` with an `OrderRow`/`InvoiceRow` without both `ArticleNumber` and `AccountNumber` Fortnox gives you this splendid message:
> Kunde inte hitta konto.

I think you can set a default account number for rows.

## Fortnox rewrites attributes
### TermsOfPayments
This model has a `code` attribute. `30days` is a valid attribute value, but the API rewrites this as `30DAYS` and a `GET` request with `30days` will return `Not Found`. This is not documented anywhere...

## Not documented limitations
### TermsOfPayments
The `code` attribute has no limits according to the documentations, but when sending `30 days` to the API, you get an error saying that the value must be alphanumeric.

### Row description
The row description for `Invoice` (and I guess for `Offer` and `Order` as well) has a limit of 255 characters.

## Consistency
### Customer's SalesAccount attribute
If you create a `Customer` with the following JSON payload, with `SalesAccount` as a **string** just like the documentation says it should be
```
{"Customer":{"Name":"Customer with Sales Account","SalesAccount":"3001"}}
```
Fortnox returns `SalesAccount` as an **integer**...
```
{"Customer":{"@url":"https:\/\/api.fortnox.se\/3\/customers\/242",..., "SalesAccount":3001}}
```
When you then fetch **the same Customer you just created**, you get the `SalesAccount` as a **string**
```
{"Customer": "@url":"https:\/\/api.fortnox.se\/3\/customers\/242", ..., "SalesAccount":"3001"}}
```
