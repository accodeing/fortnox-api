# frozen_string_literal: true

module Fortnox
  class Article < Fortnox::Resource
    using RestEasy::Refinements

    configure do
      path "articles"
      instance_wrapper "Article"
      collection_wrapper "Articles"
    end

    # @url Direct URL to the record.
    attr :url <=> '@url', Nullable::String, :read_only

    # Active If the article is active
    attr :active, Nullable::Boolean

    # ArticleNumber Article number. 50 characters
    key :article_number, Sized::String[50]

    # Bulky If the article is bulky.
    attr :bulky, Nullable::Boolean

    # ConstructionAccount Account number for construction work (special VAT rules in Sweden).
    # The number must be of an existing account.
    attr :construction_account, Sized::Integer[0, 9_999]

    # Depth The depth of the article in millimeters
    attr :depth, Sized::Integer[0, 99_999_999]

    # Description The description of the article
    attr :description, Sized::String[200], :required

    # DisposableQuantity Disposable quantity of the article.
    attr :disposable_quantity, Nullable::Float, :read_only

    # EAN EAN bar code
    attr :ean <=> 'EAN', Sized::String[30]

    # EUAccount Account number for the sales account to EU.
    # The number must be of an existing account.
    attr :eu_account <=> 'EUAccount', Sized::Integer[0, 9_999]

    # EUVATAccount Account number for the sales account to EU with VAT.
    # The number must be of an existing account.
    attr :eu_vat_account <=> 'EUVATAccount', Sized::Integer[0, 9_999]

    # ExportAccount Account number for the sales account outside EU.
    # The number must be of an existing account.
    attr :export_account, Sized::Integer[0, 9_999]

    # Height The height of the article in millimeters
    attr :height, Sized::Integer[0, 99_999_999]

    # Housework If the article is housework
    attr :housework, Nullable::Boolean

    # HouseworkType The type of housework.
    attr :housework_type, HouseworkTypes

    # Manufacturer The manufacturer of the article
    attr :manufacturer, Sized::String[50]

    # ManufacturerArticleNumber The manufacturer's article number
    attr :manufacturer_article_number, Sized::String[50]

    # Note Text note
    attr :note, Sized::String[10_000]

    # PurchaseAccount Account number for purchase.
    # The number must be of an existing account.
    attr :purchase_account, Sized::Integer[0, 9_999]

    # PurchasePrice Purchase price of the article
    attr :purchase_price, Sized::Float[0.0, 99_999_999_999_999.9]

    # QuantityInStock Quantity in stock of the article
    attr :quantity_in_stock, Sized::Float[-100_000_000_000_000.0, 99_999_999_999_999.9]

    # ReservedQuantity Reserved quantity of the article
    attr :reserved_quantity, Nullable::Float, :read_only

    # SalesAccount Account number for the sales account in Sweden.
    # The number must be of an existing account.
    attr :sales_account, Sized::Integer[0, 9_999]

    # SalesPrice Price of article for its default price list
    attr :sales_price, Nullable::Float, :read_only

    # StockGoods If the article is stock goods
    attr :stock_goods, Nullable::Boolean

    # StockPlace Storage place for the article
    attr :stock_place, Sized::String[100]

    # StockValue Value in stock of the article
    attr :stock_value, Nullable::Float, :read_only

    # StockWarning When to start warning for low quantity in stock
    attr :stock_warning, Sized::Float[0.0, 99_999_999_999_999.9]

    # SupplierName Name of the supplier
    attr :supplier_name, Nullable::String, :read_only

    # SupplierNumber Supplier number for the article.
    # The number must be of an existing supplier.
    attr :supplier_number, Nullable::String

    # Type The type of the article
    attr :type, ArticleTypes

    # Unit Unit code for the article.
    # The code must be of an existing unit.
    attr :unit, Nullable::String

    # VAT VAT percent, this is predefined by the VAT for the sales account
    attr :vat <=> 'VAT', Nullable::Float

    # WebshopArticle If the article is a webshop article
    attr :webshop_article, Nullable::Boolean

    # Weight Weight of the article in grams
    attr :weight, Sized::Integer[0, 99_999_999]

    # Width Width of the article in millimeters.
    attr :width, Sized::Integer[0, 99_999_999]

    # Expired If the article has expired
    attr :expired, Nullable::Boolean

    # TODO: new attribute
    attr :cost_calculation_method, Nullable::String

    # TODO: new attribute
    attr :stock_account, Nullable::Integer

    # TODO: new attribute
    attr :stock_change_account, Nullable::Integer

    # TODO: new attribute
    attr :direct_cost, Nullable::Float

    # TODO: new attribute
    attr :freight_cost, Nullable::Float

    # TODO: new attribute
    attr :other_cost, Nullable::Float

    # TODO: new attribute
    attr :default_stock_point, Nullable::String

    # TODO: new attribute
    attr :default_stock_location, Nullable::String

    # TODO: new attribute
    attr :commodity_code, Nullable::String
  end
end
