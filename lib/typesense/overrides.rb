# frozen_string_literal: true
include ERB::Util

module Typesense
  class Overrides
    RESOURCE_PATH = '/overrides'

    def initialize(collection_name, api_call)
      @collection_name = collection_name
      @api_call        = api_call
      @overrides       = {}
    end

    def upsert(override_id, params)
      @api_call.put(endpoint_path(override_id), params)
    end

    def retrieve
      @api_call.get(endpoint_path)
    end

    def [](override_id)
      @overrides[override_id] ||= Override.new(@collection_name, override_id, @api_call)
    end

    private

    def endpoint_path(operation = nil)
      "#{Collections::RESOURCE_PATH}/#{url_encode(@collection_name)}#{Overrides::RESOURCE_PATH}#{operation.nil? ? '' : "/#{url_encode(operation)}"}"
    end
  end
end
