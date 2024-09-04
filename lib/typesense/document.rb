# frozen_string_literal: true
include ERB::Util

module Typesense
  class Document
    def initialize(collection_name, document_id, api_call)
      @collection_name = collection_name
      @document_id     = document_id
      @api_call        = api_call
    end

    def retrieve
      @api_call.get(endpoint_path)
    end

    def delete
      @api_call.delete(endpoint_path)
    end

    def update(partial_document, options = {})
      @api_call.patch(endpoint_path, partial_document, options)
    end

    private

    def endpoint_path
      "#{Collections::RESOURCE_PATH}/#{url_encode(@collection_name)}#{Documents::RESOURCE_PATH}/#{url_encode(@document_id)}"
    end
  end
end
