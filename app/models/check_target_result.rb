class CheckTargetResult
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :index, :integer
  attribute :message, :string
  attribute :error_message, :string
  attribute :is_match, :boolean
  attribute :is_error, :boolean
end