module Firestore
  class FirestoreRecord < Firestore
    require 'singleton'
    class_attribute :collection_path

    class << self
      def find(*ids)
        results = []
        ids.each do |id|
          ret = firestore.col(@collection_path).doc(id).get.fields
          next unless ret
          result = ret.dup.merge({ id: id })

          results << result
        end
        results
      end

      def find_row(id)
        results = find(id)
        nil if !results || results.length == 0
        results[0]
      end

      def find_by(args = {})
        return nil unless args && args.is_a?(Hash)

        ref = firestore.col @collection_path
        args.each do |key, value|
          ref = ref.where(key, '=', value)
        end

        ref.get.map do |record|
          record.fields.merge({ id: record.document_id })
        end
      end

      def delete(id)
        raise Exception, "#{self.class.name} delete id unset" if id.empty?

        ref = firestore.doc "#{@collection_path}/#{id}"
        ref.delete
        true
      end
    end
    freeze
  end
end
