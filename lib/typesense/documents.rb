# frozen_string_literal: true

require 'oj'

module Typesense
  class Documents
    RESOURCE_PATH = '/documents'

    def initialize(collection_name, api_call)
      @collection_name = collection_name
      @api_call        = api_call
      @documents       = {}
    end

    def create(document, options = {})
      @api_call.post(endpoint_path, document, options)
    end

    def upsert(document, options = {})
      @api_call.post(endpoint_path, document, options.merge(action: :upsert))
    end

    def update(document, options = {})
      if options['filter_by'] || options[:filter_by]
        @api_call.patch(endpoint_path, document, options)
      else
        @api_call.post(endpoint_path, document, options.merge(action: :update))
      end
    end

    def create_many(documents, options = {})
      @api_call.logger.warn('#create_many is deprecated and will be removed in a future version. Use #import instead, which now takes both an array of documents or a JSONL string of documents')
      import(documents, options)
    end

    # @param [Array,String] documents An array of document hashes or a JSONL string of documents.
    def import(documents, options = {})
      documents_in_jsonl_format = if documents.is_a?(Array)
                                    documents.map { |document| Oj.dump(document, mode: :compat) }.join("\n")
                                  else
                                    documents
                                  end

      results_in_jsonl_format = @api_call.perform_request(
        'post',
        endpoint_path('import'),
        query_parameters: options,
        body_parameters: documents_in_jsonl_format,
        additional_headers: { 'Content-Type' => 'text/plain' }
      )

      if documents.is_a?(Array)
        results_in_jsonl_format.split("\n").map { |r| Oj.load(r) }
      else
        results_in_jsonl_format
      end
    end

    def export(options = {})
      @api_call.get(endpoint_path('export'), options)
    end

    def search(search_parameters)
      @api_call.get(endpoint_path('search'), search_parameters)
    end

    def [](document_id)
      @documents[document_id] ||= Document.new(@collection_name, document_id, @api_call)
    end

    def delete(query_parameters = {})
      @api_call.delete(endpoint_path, query_parameters)
    end

    private

    def endpoint_path(operation = nil)
      "#{Collections::RESOURCE_PATH}/#{ERB::Util.url_encode(@collection_name)}#{Documents::RESOURCE_PATH}#{operation.nil? ? '' : "/#{operation}"}"
    end
  end
end
