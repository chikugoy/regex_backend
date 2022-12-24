module Api
  module V1
    class HealthChecksController < ApplicationController
      def index
        render json: {
          status: 'SUCCESS',
          data: {}
        }
      end
    end
  end
end
