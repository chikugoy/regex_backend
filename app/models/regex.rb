class Regex < Firestore::FirestoreRecord
  COLLECTION_PATH = 'regex'.freeze
  @collection_path = COLLECTION_PATH

  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :string
  attribute :text, :string
  attribute :option_text, :string
  attribute :check_target, :check_target_array

  attribute :created_at, :time
  attribute :updated_at, :time

  validates :text, presence: true
  validates :created_at, presence: true
  validates :updated_at, presence: true

  def self.self_new(data)
    Regex.new(data)
  end

  def create(data)
    Rails.logger.debug data
    raise Exception.new("#{self.class.name} create args not hash") unless data.is_a?(Hash)


    Rails.logger.debug 'create(data) step2'
    instance = self_new(data)
    Rails.logger.debug 'create(data) step3'
    instance.created_at ||= Time.current
    instance.updated_at ||= Time.current

    return instance unless instance.valid?
    Rails.logger.debug 'create(data) step4'

    ref = firestore.col @collection_path
    Rails.logger.debug 'create(data) step5'
    instance.attributes.delete('id')
    Rails.logger.debug instance.attributes
    Rails.logger.debug instance.attributes['check_target'].to_a
    Rails.logger.debug 'attributes'
    Rails.logger.debug 'attributes check_target'
    attributes[:check_target] = attributes[:check_target].map do |target|
      return target.to_h
    end
    Rails.logger.debug attributes
    Rails.logger.debug 'create(data) step6'
    ref = ref.add instance.attributes
    Rails.logger.debug 'create(data) step7'
    instance.id = ref.document_id
    Rails.logger.debug 'create(data) step8'

    instance
  end
end