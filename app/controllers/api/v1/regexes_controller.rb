module Api
  module V1
    class RegexesController < ApplicationController
      before_action :set_regex, only: %i[show update destroy]
      before_action :verify_token, only: [:create]
      before_action :validate, only: [:check]

      def index
        regexes = if query_params[:is_recommend]
                    Regex.find_by_recommend
                  else
                    Regex.find_by_own(query_params[:user_id])
                  end

        render json: {
          status: 'SUCCESS',
          message: 'Loaded regexes',
          data: regexes.map { |regex| regex }
        }
      rescue StandardError => e
        logger.error e
        raise e
      end

      def show
        render json: { status: 'SUCCESS', message: 'Loaded the regex', data: @regex }
      end

      def create
        regex = Regex.create(regex_params)
        Tag.find_to_create(regex_params[:tags])

        render json: { status: 'SUCCESS', data: regex }
        # render json: { status: 'ERROR', message: 'Not created', data: regex.errors.full_messages }, status: :bad_request
      rescue StandardError => e
        logger.error e
        raise e
      end

      def destroy
        @regex.delete
        render json: { status: 'SUCCESS', message: 'Deleted the regex', data: {} }
      end

      def update
        regex = Regex.update(params[:id], regex_params)
        Tag.find_to_create(regex_params[:tags])

        render json: { status: 'SUCCESS', data: regex }
        # render json: { status: 'ERROR', message: 'Not created', data: regex.errors.full_messages }, status: :bad_request
      rescue StandardError => e
        logger.error e
        raise e
      end

      def check
        results = targets.map do |target|
          match(params[:text], target[:target], params[:option_text], target[:index])
        end

        render json: { status: 'SUCCESS', data: results }
      rescue StandardError => e
        logger.error e
        raise e
      end

      private

      def verify_token
        Firebase::Auth.verify_token(regex_params[:token])
      end

      def set_regex
        @regex = Regex.find_row(params[:id])
      end

      def regex_params
        params.permit(:token, :user_id, :text, :option_text, :title, :supplement, tags: [],
                                                                                  check_targets: [:target, { result: %i[index message error_message is_match is_error] }]).to_h
      end

      def query_params
        query = {}
        query[:id] = params[:id] unless params[:id].blank?
        query[:text] = params[:text] unless params[:text].blank?
        query[:user_id] = params[:user_id] unless params[:user_id].blank?
        query[:is_recommend] = params[:is_recommend] unless params[:is_recommend].blank?
        query
      end

      def remote_ip
        request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
      end

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
        if params[:text].blank? || targets.blank?
          render json: { status: 'ERROR', message: 'Validate error', data: [] }, status: :bad_request
        end
      end
    end
  end
end
