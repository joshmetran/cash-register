class ApplicationController < ActionController::Base
  include ExceptionHandler
  include ApplicationHelper
  include Pagy::Backend

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  skip_forgery_protection
end
