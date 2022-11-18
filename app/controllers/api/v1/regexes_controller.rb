module Api
  module V1
    class RegexesController < ApplicationController
      before_action :set_regex, only: [:show, :update, :destroy]

      def index
        regexes = Regex.find_by(query_params)
        render json: {
          status: 'SUCCESS',
          message: 'Loaded regexes',
          data: regexes.map { |regex| regex.attributes }
        }
      end

      def show
        render json: { status: 'SUCCESS', message: 'Loaded the regex', data: @regex.attributes }
      end

      def create
        regex = Regex.create(regex_params)

        if regex.valid?
          render json: { status: 'SUCCESS', data: regex.attributes }
        else
          render json: { status: 'ERROR', message: 'Not created', data: regex.errors.full_messages }, status: :bad_request
        end
      end

      def destroy
        @regex.delete
        render json: { status: 'SUCCESS', message: 'Deleted the regex', data: {} }
      end

      def update
        if @regex.save(regex_params.to_h)
          render json: { status: 'SUCCESS', message: 'Updated the regex', data: @regex.attributes }
        else
          render json: { status: 'SUCCESS', message: 'Not updated', data: @regex.errors.full_messages  }, status: :bad_request
        end
      end

      private

      def set_regex
        @regex = Regex.find_row(params[:id])
      end

      def regex_params
        params.permit(:id, :text, :option_text, check_target: [:target, result: [:index, :message, :error_message, :is_match, :is_error]]).to_h
      end

      def query_params
        query = {}
        query[:id] = params[:id] unless params[:id].blank?
        query[:text] = params[:text] unless params[:text].blank?
        query
      end
    end
  end
end
