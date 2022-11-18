class CheckTarget
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :target, :string
  attribute :result, :check_target_result
end