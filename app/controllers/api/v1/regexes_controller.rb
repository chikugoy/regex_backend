module Api
  module V1
    class RegexesController < ApplicationController
      before_action :set_regex, only: [:show, :update, :destroy]
      before_action :verify_token, only: [:create]

      def index
        if query_params[:is_recommend]
          regexes = Regex.find_by_recommend
        else
          regexes = Regex.find_by_own(query_params[:user_id])
        end

        render json: {
          status: 'SUCCESS',
          message: 'Loaded regexes',
          data: regexes.map { |regex| regex }
        }
      rescue => e
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
      rescue => e
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
      rescue => e
        logger.error e
        raise e
      end

      private

      def verify_token
        Firebase::Auth::verify_token(regex_params[:token])
      end

      def set_regex
        @regex = Regex.find_row(params[:id])
      end

      def regex_params
        params.permit(:token, :user_id, :text, :option_text, :title, :supplement, tags: [], check_targets: [:target, result: [:index, :message, :error_message, :is_match, :is_error]]).to_h
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
        request.env["HTTP_X_FORWARDED_FOR"] || request.remote_ip
      end
    end
  end
end
