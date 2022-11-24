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
        Tag.create(regex_params[:tags])

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
        if @regex.save(regex_params.to_h)
          render json: { status: 'SUCCESS', message: 'Updated the regex', data: @regex }
        else
          render json: { status: 'SUCCESS', message: 'Not updated', data: @regex.errors.full_messages  }, status: :bad_request
        end
      end

      private

      def verify_token
        Firebase::Auth::verify_token(regex_params[:token])
      end

      def set_regex
        @regex = Regex.find_row(params[:id])
      end

      def regex_params
        params.permit(:id, :token, :user_id, :text, :option_text, :title, tags: [], check_targets: [:target, result: [:index, :message, :error_message, :is_match, :is_error]]).to_h
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
