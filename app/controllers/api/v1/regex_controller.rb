module Api
  module V1
    class RegexController < ApplicationController
      def check
        if !validate
          render json: { status: 'ERROR', message: 'Validate error', data: [] }, status: :bad_request
          return
        end

        results = targets.map do |target|
          match(params[:text], target[:target], params[:option_text], target[:index])
        end

        render json: { status: 'SUCCESS', data: results }
      end

      private

      def match(text, target, optionText, i)
        result = {
          :index => i,
          :message => '',
          :error_message => '',
          :is_match => false,
          :is_error => false,
        }
        begin
          reg = get_regexp(text, optionText)
          if reg.match?(target)
            result[:message] = 'マッチしました！'
            result[:is_match] = true
            return result
          end
          result[:message] = 'マッチしませんでした。'
        rescue => e
          result[:is_error] = true
          result[:error_message] = e.message
        end

        result
      end

      def get_regexp(text, optionText)
        return Regexp.new(text) if optionText.blank?

        isIgnoreCase = false
        isExtended = false
        isMultiline = false
        optionText.chars.each do |char|
          isIgnoreCase = true if char == 'i'
          isExtended = true if char == 'e'
          isMultiline = true if char == 'm'
        end

        if isIgnoreCase && isExtended && isMultiline
          return Regexp.new(text, Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED)
        elsif isMultiline && isExtended
          return Regexp.new(text, Regexp::MULTILINE | Regexp::EXTENDED)
        elsif isIgnoreCase && isMultiline
          return Regexp.new(text, Regexp::IGNORECASE | Regexp::MULTILINE )
        elsif isMultiline
          return Regexp.new(text, Regexp::MULTILINE)
        elsif isIgnoreCase && isExtended
          return Regexp.new(text, Regexp::IGNORECASE | Regexp::EXTENDED)
        elsif isExtended
          return Regexp.new(text, Regexp::EXTENDED)
        else
          return Regexp.new(text, Regexp::IGNORECASE)
        end
      end

      def targets
        params[:targets].filter do | target |
          !target[:target].blank?
        end
      end

      def validate
        return false if params[:text].blank? || targets.blank?
        true
      end
    end
  end
end
