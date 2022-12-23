module Api
  module V1
    class RegexController < ApplicationController
      def check
        unless validate
          render json: { status: 'ERROR', message: 'Validate error', data: [] }, status: :bad_request
          return
        end

        results = targets.map do |target|
          match(params[:text], target[:target], params[:option_text], target[:index])
        end

        render json: { status: 'SUCCESS', data: results }
      rescue StandardError => e
        logger.error e
        raise e
      end

      private

      def match(text, target, optionText, i)
        result = {
          index: i,
          message: '',
          error_message: '',
          is_match: false,
          is_error: false
        }
        begin
          reg = get_regexp(text, optionText)
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

      def get_regex_text(target, text)
        target.gsub(/#{text}/, '{{{match_start}}}\&{{{match_end}}}')
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
          Regexp.new(text, Regexp::IGNORECASE | Regexp::MULTILINE | Regexp::EXTENDED)
        elsif isMultiline && isExtended
          Regexp.new(text, Regexp::MULTILINE | Regexp::EXTENDED)
        elsif isIgnoreCase && isMultiline
          Regexp.new(text, Regexp::IGNORECASE | Regexp::MULTILINE)
        elsif isMultiline
          Regexp.new(text, Regexp::MULTILINE)
        elsif isIgnoreCase && isExtended
          Regexp.new(text, Regexp::IGNORECASE | Regexp::EXTENDED)
        elsif isExtended
          Regexp.new(text, Regexp::EXTENDED)
        else
          Regexp.new(text, Regexp::IGNORECASE)
        end
      end

      def targets
        params[:targets].filter do |target|
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
