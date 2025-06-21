module ApplicationHelper
  def paginate_options
    options = {}
    options[:page] = params[:page] unless params[:page].blank?
    options[:limit] = params[:per_page].blank? ? 10 : params[:per_page]
    options
  end
end
