shared_context 'JSONHelper' do
  using_test_class do
    class JSONHelper < described_class
      include Fortnox::API::Repository::JSONConvertion

      def convert_from_json( key ) 
        convert_key_from_json( key )
      end

      def convert_to_json( key )
        convert_key_to_json( key )
      end
    end
  end
end
