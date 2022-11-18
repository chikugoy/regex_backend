class Tag < Firestore::FirestoreRecord
  COLLECTION_PATH = 'tag'.freeze

  def self.find_row(id)
    firestore.col(self::COLLECTION_PATH).doc(id).get.fields
  end

  def self.create(tags)
    return false if tags.blank?

    tags = tags.uniq

    tags.each do |tag|
      ret = find_row(tag)
      next unless ret.blank?

      data = {}
      data[:name] = tag
      data[:created_at] ||= Time.current
      data[:updated_at] ||= Time.current

      ref = firestore.doc "#{self::COLLECTION_PATH}/#{tag}"
      ref.set(data)
    end

    return true
  end
end