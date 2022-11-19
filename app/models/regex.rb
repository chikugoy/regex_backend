class Regex < Firestore::FirestoreRecord
  COLLECTION_PATH = 'regex'.freeze

  def self.create(data)
    raise Exception.new("#{self.class.name} create args not hash") unless data.is_a?(Hash)

    data[:language] ||= ENV['REGX_LANGUAGE']
    data[:language_version] ||= ENV['REGX_LANGUAGE_VERSION']
    data[:created_at] ||= Time.current
    data[:updated_at] ||= Time.current

    ref = firestore.col self::COLLECTION_PATH
    ref = ref.add data

    data[:id] = ref.document_id

    data
  end
end