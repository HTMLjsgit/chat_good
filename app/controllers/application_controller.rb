class ApplicationController < ActionController::Base
	protect_from_forgery
	# ApplicationController.render 'messages/message'
	before_action :search

	before_action :configure_permitted_parameters, if: :devise_controller?
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
	end
	def self.render_with_signed_in_user(user, *args)
	   ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
	   proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap{|i| i.set_user(user, scope: :user) }
	   renderer = self.renderer.new('warden' => proxy)
	   renderer.render(*args)
	end

	def search
		@q = Room.ransack(params[:q])
		@rooms = @q.result(distinct: true).where(public: true).order(created_at: :desc)
	end
end
