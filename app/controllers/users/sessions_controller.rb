# frozen_string_literal: true
require 'devise/jwt/test_helpers'

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    puts "oi"
    puts params
    user = User.find_by(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      session[:user_id] = user.id
      render json: { success: true, user: user, token:Devise::JWT::TestHelpers.auth_headers({}, current_user)['Authorization'] }, status: :ok
    else
      render json: { success: false }, status: :unauthorized
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  respond_to :json
  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: { 
        code: 200, message: 'Logged in successfully.',
        data: current_user 
      }
    }, status: :ok
  end
  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, '15805a4c501d01bbe580c753a379ada40f76215d316bbfb760119bc43d3ff85f7af4616b0fccef3bb75389d22b00b76c1770e07e8c723194d1f4a88efed66062').first

      current_user = User.find(jwt_payload['sub'])
    end
    
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
