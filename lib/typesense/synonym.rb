# frozen_string_literal: true
include ERB::Util

module Typesense
  class Synonym
    def initialize(collection_name, synonym_id, api_call)
      @collection_name = collection_name
      @synonym_id = synonym_id
      @api_call = api_call
    end

    def retrieve
      @api_call.get(endpoint_path)
    end

    def delete
      @api_call.delete(endpoint_path)
    end

    private

    def endpoint_path
      "#{Collections::RESOURCE_PATH}/#{url_encode(@collection_name)}#{Synonyms::RESOURCE_PATH}/#{url_encode(@synonym_id)}"
    end
  end
end
