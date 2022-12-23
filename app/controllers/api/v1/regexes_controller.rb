module Api
  module V1
    class RegexesController < ApplicationController
      before_action :set_regex, only: %i[show update destroy]
      before_action :verify_token, only: %i[create update]
      before_action :verify_token_by_header, only: [:destroy]
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
      rescue StandardError => e
        logger.error e
        raise e
      end

      def destroy
        Regex.delete(@regex[:id])
        render json: { status: 'SUCCESS', message: 'Deleted the regex', data: {} }
      end

      def update
        regex = Regex.update(params[:id], regex_params)
        Tag.find_to_create(regex_params[:tags])

        render json: { status: 'SUCCESS', data: regex }
      rescue StandardError => e
        logger.error e
        raise e
      end

      def check
        results = targets.map do |target|
          Regex.match(params[:text], target[:target], params[:option_text], target[:index])
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

      def verify_token_by_header
        Firebase::Auth.verify_token(request.headers[:HTTP_AUTHORITY_TOKEN])
      end

      def set_regex
        @regex = Regex.find_row(params[:id])
      end

      def regex_params
        params.permit(:token, :user_id, :text, :option_text, :title, :supplement, tags: [],
                      check_targets: [:target, { result: %i[index message error_message is_match is_error] }]).to_h
      end

      def query_params
        {}.tap do |h|
          h[:id] = params[:id] unless params[:id].blank?
          h[:text] = params[:text] unless params[:text].blank?
          h[:user_id] = params[:user_id] unless params[:user_id].blank?
          h[:is_recommend] = params[:is_recommend] unless params[:is_recommend].blank?
        end
      end

      def remote_ip
        request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
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
