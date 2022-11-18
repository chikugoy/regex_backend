require 'active_model'

class TypeCheckTargetResult < ActiveModel::Type::Value
  def cast_value(value)
    CheckTargetResult.new(value)
  end
end

ActiveModel::Type.register(:check_target_result, TypeCheckTargetResult)