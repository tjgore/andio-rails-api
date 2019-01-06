class UsersController < ApplicationController

	before_action :authenticate_request!, only: [:all, :verify_token]

	
	def create
		user = User.new(user_params)
		if user.save
			#user.image.attach(params[:image])
			auth_token = do_login(params[:email], params[:password])	
			if auth_token[:state]
				render json: { message: 'User created and logged in successfully', id: auth_token[:id], email: auth_token[:email], first_name: auth_token[:first_name], last_name: auth_token[:last_name], auth_token: auth_token[:auth] }, status: :created
			end
		else
			render json: { errors: user.errors.full_messages, params: params[:email] }, status: :unprocessable_entity
		end
	end

	def login
		auth_token = do_login(params[:user][:email], params[:user][:password])
		if auth_token[:state]
			render json: { id: auth_token[:id], email: auth_token[:email], first_name: auth_token[:first_name], last_name: auth_token[:last_name], auth_token: auth_token[:auth] }, status: :ok
		else
			render json: { error: 'Invalid email or password' }, status: :unauthorized
		end
	end

	def verify_token
		user = User.find_by(email: params[:user][:email])
		if user.id
			render json: { id: user.id, email: user.email, first_name: user.first_name, last_name: user.last_name, auth_token: params[:user][:token] }, status: :ok
		else
			render json: { error: 'User doesn\'t exist' }, status: :unauthorized
		end
	end

	def logout
		render json: { message: "Logged out"}, status: :ok
	end

	private

	def user_params
		params.permit(:user, :first_name, :last_name, :email, :password, :image)
	end

	def do_login (email, password)
		user = User.find_by(email: email.to_s.downcase)
		if user && user.authenticate(password)
			auth_token = JsonWebToken.encode({ user_id: user.id, refresh_token: SecureRandom.hex(25) })
			return { id: user.id, email: user.email, first_name: user.first_name, last_name: user.last_name, auth: auth_token, state: true}
		else
			return { state: false }
		end
	end

end
