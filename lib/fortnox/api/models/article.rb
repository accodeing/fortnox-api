# frozen_string_literal: true

require 'fortnox/api/types'
require 'fortnox/api/models/base'

module Fortnox
  module API
    module Model
      class Article < Fortnox::API::Model::Base
        UNIQUE_ID = :article_number
        STUB = { description: '' }.freeze

        # Url Direct URL to the record
        attribute :url, Types::Nullable::String.is(:read_only)

        # Active If the article is active
        attribute :active, Types::Nullable::Boolean

        # ArticleNumber Article number. 50 characters
        attribute :article_number, Types::Sized::String[50]

        # Bulky If the article is bulky.
        attribute :bulky, Types::Nullable::Boolean

        # ConstructionAccount Account number for construction work (special VAT rules in Sweden).
        # The number must be of an existing account.
        attribute :construction_account, Types::Sized::Integer[0, 9_999]

        # Depth The depth of the article in millimeters
        attribute :depth, Types::Sized::Integer[0, 99_999_999]

        # Description The description of the article
        attribute :description, Types::Sized::String[200].is(:required)

        # DisposableQuantity Disposable quantity of the article.
        attribute :disposable_quantity, Types::Nullable::Float.is(:read_only)

        # EAN EAN bar code
        attribute :ean, Types::Sized::String[30]

        # EUAccount Account number for the sales account to EU.
        # The number must be of an existing account.
        attribute :eu_account, Types::Sized::Integer[0, 9_999]

        # EUVATAccount Account number for the sales account to EU with VAT.
        # The number must be of an existing account.
        attribute :eu_vat_account, Types::Sized::Integer[0, 9_999]

        # ExportAccount Account number for the sales account outside EU
        # The number must be of an existing account.
        attribute :export_account, Types::Sized::Integer[0, 9_999]

        # Height The height of the article in millimeters
        attribute :height, Types::Sized::Integer[0, 99_999_999]

        # Housework If the article is housework
        attribute :housework, Types::Nullable::Boolean

        # HouseWorkType The type of house work.
        attribute :housework_type, Types::HouseWorkType

        # Manufacturer The manufacturer of the article
        attribute :manufacturer, Types::Sized::String[50]

        # ManufacturerArticleNumber The manufacturer's article number
        attribute :manufacturer_article_number, Types::Sized::String[50]

        # Note Text note
        attribute :note, Types::Sized::String[10_000]

        # PurchaseAccount Account number for purchase.
        # The number must be of an existing account.
        attribute :purchase_account, Types::Sized::Integer[0, 9_999]

        # PurchasePrice Purchase price of the article
        attribute :purchase_price, Types::Sized::Float[0.0, 99_999_999_999_999.9]

        # QuantityInStock Quantity in stock of the article
        attribute :quantity_in_stock, Types::Sized::Float[0.0, 99_999_999_999_999.9]

        # ReservedQuantity Reserved quantity of the article
        attribute :reserved_quantity, Types::Nullable::Float.is(:read_only)

        # SalesAccount Account number for the sales account in Sweden.
        # The number must be of an existing account.
        attribute :sales_account, Types::Sized::Integer[0, 9_999]

        # SalesPrice Price of article for its default price list
        attribute :sales_price, Types::Nullable::Float.is(:read_only)

        # StockGoods If the article is stock goods
        attribute :stock_goods, Types::Nullable::Boolean

        # StockPlace Storage place for the article
        attribute :stock_place, Types::Sized::String[100]

        # StockValue Value in stock of the article
        attribute :stock_value, Types::Nullable::Float.is(:read_only)

        # StockWarning When to start warning for low quantity in stock
        attribute :stock_warning, Types::Sized::Float[0.0, 99_999_999_999_999.9]

        # SupplierName Name of the supplier
        attribute :supplier_name, Types::Nullable::String.is(:read_only)

        # SupplierNumber Supplier number for the article.
        # The number must be of an existing supplier.
        attribute :supplier_number, Types::Nullable::String

        # Type The type of the article
        attribute :type, Types::ArticleType

        # Unit Unit code for the article.
        # The code must be of an existing unit.
        attribute :unit, Types::Nullable::String

        # VAT VAT percent, this is predefined by the VAT for the sales account
        attribute :vat, Types::Nullable::Float

        # WebshopArticle If the article is a webshop article
        attribute :webshop_article, Types::Nullable::Boolean

        # Weight Weight of the article in grams
        attribute :weight, Types::Sized::Integer[0, 99_999_999]

        # Width Width of the article in millimeters.
        attribute :width, Types::Sized::Integer[0, 99_999_999]

        # Expired If the article has expired
        attribute :expired, Types::Nullable::Boolean
      end
    end
  end
end
