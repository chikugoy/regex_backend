Rails.logger = Logger.new(STDOUT)
Rails.logger.debug 'test1111'

require 'active_record/type'

Rails.application.config.to_prepare do
  ActiveModel::Type.register(:check_target_array, TypeCheckTargetArray)
  ActiveModel::Type.register(:check_target_result, TypeCheckTargetResult)
end

Rails.logger.debug 'test2222'
