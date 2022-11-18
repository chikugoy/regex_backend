module Firestore
  class FirestoreRecord < Firestore
    require 'singleton'
    class_attribute :collection_path

    class << self
      def find(*ids)
        results = []
        ids.each do |id|
          result = firestore.col(@collection_path).doc(id).get.fields
          next if !result
          results << self_new(result.merge({id: id}))
        end
        results
      end

      def find_row(id)
        results = self.find(id)
        nil if !results || results.length == 0
        results[0]
      end

      def find_by(args = {})
        return nil unless args && args.is_a?(Hash)

        ref = firestore.col @collection_path
        args.each do |key, value|
          ref = ref.where(key, "=", value)
        end

        ref.get.map do |record|
          self_new(record.fields.merge({:id => record.document_id}))
        end
      end

      def create(data)
        raise Exception.new("#{self.class.name} create args not hash") unless data.is_a?(Hash)

        instance = self_new(data)
        instance.created_at ||= Time.current
        instance.updated_at ||= Time.current

        return instance unless instance.valid?

        ref = firestore.col @collection_path
        instance.attributes.delete('id')
        ref = ref.add instance.attributes
        instance.id = ref.document_id

        instance
      end

      def create_by_id(data)
        raise Exception.new("#{self.class.name} create args not hash") unless data.is_a?(Hash)
        raise Exception.new("#{self.class.name} create_by_id id unset") if !data[:id] || data[:id].empty?

        instance = self_new(data)
        instance.created_at ||= Time.current
        instance.updated_at ||= Time.current

        return instance unless instance.valid?

        ref = firestore.doc "#{@collection_path}/#{instance.id}"
        ref.set(instance.attributes)

        instance
      end
    end

    def save(data)
      raise Exception.new("#{self.class.name} save id unset") if !self.id || self.id.empty?

      self.text = data[:text] if data[:text] || !data[:text].empty?
      self.created_at ||= Time.current
      self.updated_at = Time.current

      return false unless self.valid?

      ref = firestore.doc "#{self.class::COLLECTION_PATH}/#{self.id}"
      ref.set(self.attributes, merge: true)

      true
    end

    def delete
      raise Exception.new("#{self.class.name} delete id unset") if !self.id || self.id.empty?

      ref = firestore.doc "#{self.class::COLLECTION_PATH}/#{self.id}"
      ref.delete
      true
    end

    freeze
  end
end
