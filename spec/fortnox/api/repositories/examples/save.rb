# frozen_string_literal: true

#######################################
# SPEC IS DEPENDENT ON DEFINED ORDER!
#######################################
#
# Assumes that attribute is a string attribute without restrictions.
shared_examples_for '.save' do |attribute, additional_attrs: {}|
  describe '.save' do
    let(:new_hash) { additional_attrs.merge(attribute => 'A value') }
    let(:save_new) do
      VCR.use_cassette("#{vcr_dir}/save_new") do
        repository.save(described_class::MODEL.new(new_hash))
      end
    end

    shared_examples_for 'save' do
      specify "includes correct #{attribute.inspect}" do
        saved_entity = send_request
        expect(saved_entity.send(attribute)).to eql(value)
      end
    end

    describe 'new' do
      context 'when not saved' do
        include_examples 'save' do
          let(:model) { described_class::MODEL.new(new_hash) }
          let(:send_request) { save_new }
          let(:value) { 'A value' }
        end
      end

      context "saved #{described_class::MODEL}" do
        let(:hash) { { unsaved: false }.merge(new_hash) }
        let(:model) { described_class::MODEL.new(hash) }

        specify { expect(repository.save(model)).to be(true) }
      end
    end

    describe 'old (update existing)' do
      let(:find_new_cassette) { "#{vcr_dir}/find_new" }

      include_examples 'save' do
        let(:value) { "Updated #{attribute}" }

        let(:model) do
          existing_model = VCR.use_cassette(find_new_cassette) do
            repository.find(save_new.unique_id)
          end

          updated_model = existing_model.update(attribute => value)

          if updated_model.saved?
            raise(
              "We are trying to update the :#{attribute} attribute with " \
              "#{value} on an existing record, but that record " \
              "loaded from Fortnox " \
              "already has this attribute set to that value:\n" \
              "#{existing_model.inspect}\nHave a look at the VCR cassette " \
              "\"#{find_new_cassette}\" which should load the record with the " \
              "attribute :#{attribute} set to something else than " \
              "the value we want to set. " \
            )
          end

          updated_model
        end

        let(:send_request) do
          VCR.use_cassette("#{vcr_dir}/save_old") { repository.save(model) }
        end
      end
    end
  end
end
