#require 'fortnox/api/mappers/base'
#
# module Fortnox
#   module API
#     module Maper
#       class Array
#         def self.call( array )
#           array.each_with_object([]) do |value, value_array|
#             value_array << Fortnox::API::Registry[ mapper_name_for( value ) ]
#           end
#         end
#
#         Fortnox::API::Registry.register( :array, self )
#       end
#     end
#   end
# end
