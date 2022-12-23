class Regex < Firestore::FirestoreRecord
  COLLECTION_PATH = 'regex'
  @collection_path = COLLECTION_PATH

  class << self
    def find_by_own(user_id)
      return nil if user_id.blank?

      ref = firestore.col self::COLLECTION_PATH
      query = ref.where('user_id', '=', user_id).order('updated_at', 'desc')

      query.get.map do |record|
        record.fields.merge({ id: record.document_id })
      end
    end

    def find_by_recommend
      ref = firestore.col self::COLLECTION_PATH
      query = ref.order('good_user_count', 'desc').order('updated_at', 'desc')

      query.get.map do |record|
        record.fields.merge({ id: record.document_id })
      end
    end

    def create(data)
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

    def update(id, data, is_updated_at = true)
      raise Exception, "#{self.class.name} create args not hash" unless data.is_a?(Hash)
      raise Exception, "#{self.class.name} save args id not found" unless Regex.find_row(id)

      if is_updated_at
        data[:updated_at] ||= Time.current
      end

      ref = firestore.doc "#{self::COLLECTION_PATH}/#{id}"
      ref.set(data, merge: true)

      data[:id] = id
      data
    end

    def match(text, target, option_text, i)
      result = {
        index: i,
        message: '',
        error_message: '',
        is_match: false,
        is_error: false
      }
      begin
        reg = get_regexp(text, option_text)
        if reg.match?(target)
          result[:message] = get_regex_text(target, text)
          result[:is_match] = true
          return result
        end
        result[:message] = target
      rescue StandardError => e
        result[:is_error] = true
        result[:error_message] = e.message
      end

      result
    end

    private

    def get_regex_text(target, text)
      target.gsub(/#{text}/, '{{{match_start}}}\&{{{match_end}}}')
    end

    def get_regexp(text, option_text)
      return Regexp.new(text) if option_text.blank?

      is_ignore_case = false
      is_extended = false
      is_multiline = false
      option_text.chars.each do |char|
        is_ignore_case = true if char == 'i'
        is_extended = true if char == 'e'
        is_multiline = true if char == 'm'
      end

      if is_ignore_case && is_extended && is_multiline
        Regexp.new(text, Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED)
      elsif is_multiline && is_extended
        Regexp.new(text, Regexp::MULTILINE | Regexp::EXTENDED)
      elsif is_ignore_case && is_multiline
        Regexp.new(text, Regexp::IGNORECASE | Regexp::MULTILINE)
      elsif is_multiline
        Regexp.new(text, Regexp::MULTILINE)
      elsif is_ignore_case && is_extended
        Regexp.new(text, Regexp::IGNORECASE | Regexp::EXTENDED)
      elsif is_extended
        Regexp.new(text, Regexp::EXTENDED)
      else
        Regexp.new(text, Regexp::IGNORECASE)
      end
    end

  end

end
