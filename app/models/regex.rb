class Regex < Firestore::FirestoreRecord
  COLLECTION_PATH = 'regex'.freeze
  @collection_path = COLLECTION_PATH

  def self.find_by_own(userId)
    return nil if userId.blank?

    ref = firestore.col @collection_path
    query = ref.where('user_id', '=', userId).order('updated_at', 'desc')

    query.get.map do |record|
      record.fields.merge({ id: record.document_id })
    end
  end

  def self.find_by_recommend
    ref = firestore.col @collection_path
    query = ref.order('good_user_count', 'desc').order('updated_at', 'desc')

    query.get.map do |record|
      record.fields.merge({ id: record.document_id })
    end
  end

  def self.create(data)
    raise Exception, "#{self.class.name} create args not hash" unless data.is_a?(Hash)

    data[:good_user_count] ||= 0
    data[:good_user_ids] ||= []
    data[:language] ||= ENV['REGX_LANGUAGE']
    data[:language_version] ||= ENV['REGX_LANGUAGE_VERSION']
    data[:created_at] ||= Time.current
    data[:updated_at] ||= Time.current

    ref = firestore.col self::COLLECTION_PATH
    ref = ref.add data

    data[:id] = ref.document_id

    data
  end

  def self.update(id, data)
    raise Exception, "#{self.class.name} create args not hash" unless data.is_a?(Hash)
    raise Exception, "#{self.class.name} save args id not found" unless Regex.find_row(id)

    data[:updated_at] ||= Time.current

    ref = firestore.doc "#{self::COLLECTION_PATH}/#{id}"
    ref.set(data, merge: true)

    data[:id] = id
    data
  end
end
