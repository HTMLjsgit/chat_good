class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	# ApplicationController.render 'messages/message'
	
	before_action :search

	before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :notifications
	rescue_from ActiveRecord::RecordNotFound, with: :render_404
	rescue_from ActionController::RoutingError, with: :render_404
	rescue_from Exception, with: :render_500
	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
	end

	def render_404(exception = nil)
		if exception
			logger.info "Rendering 404 with exception: #{exception.message}"
		end
		render template: "errors/error_400", status: 404, layout: "application"
	end



	def render_500(exception = nil)
		if exception
			logger.info "Rendering 500 with exception: #{exception.message}"
		end
		render template: "errors/error_500", status: 500, layout: "application"
	end

	def make_folder
		Dir.mkdir("public/uploads/#{message.class.to_s.underscore}")
	end

	def notifications

		if user_signed_in?
			@notifications = current_user.passive_notifications
			@notifications_count = current_user.passive_notifications.where(checked: false).count
		end
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
