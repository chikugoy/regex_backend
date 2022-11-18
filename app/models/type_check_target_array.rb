require 'active_model'

class TypeCheckTargetArray < ActiveModel::Type::Value
  def cast_value(value)
    arr = []
    value.each do |v|
      arr.push CheckTarget.new(v)
    end
    arr
  end
end

ActiveModel::Type.register(:check_target_array, TypeCheckTargetArray)
