class User < Firestore::FirestoreRecord
  COLLECTION_PATH = 'user'.freeze
  @collection_path = COLLECTION_PATH

  def self.find_row(id)
    firestore.col(self::COLLECTION_PATH).doc(id).get.fields
  end

  def self.create(data)
    raise Exception, "#{self.class.name} create args not hash" unless data.is_a?(Hash)

    uid = data[:uid]
    data.delete(:uid)
    data[:created_at] ||= Time.current
    data[:updated_at] ||= Time.current

    ref = firestore.doc "#{self::COLLECTION_PATH}/#{uid}"
    ref.set data

    data[:id] = uid
  end

  def self.update(data)
    raise Exception, "#{self.class.name} create args not hash" unless data.is_a?(Hash)

    uid = data[:uid]
    data.delete(:uid)
    data[:updated_at] ||= Time.current

    ref = firestore.doc "#{self::COLLECTION_PATH}/#{uid}"
    ref.set(data, merge: true)

    data[:id] = uid
  end
end
