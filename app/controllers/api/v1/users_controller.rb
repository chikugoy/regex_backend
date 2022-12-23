module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.find_row(user_params[:uid])
        user = if user
                 User.update(user_params)
               else
                 User.create(user_params)
               end

        render json: { status: 'SUCCESS', data: user }
      end

      private

      def user_params
        params.permit(:uid, :displayName, :email, :accessToken, :refreshToken).to_h
      end

      def remote_ip
        request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip
      end
    end
  end
end
