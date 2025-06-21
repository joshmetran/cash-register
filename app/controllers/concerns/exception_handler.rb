module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordNotSaved, with: :unprocessable_entity
    rescue_from ActiveRecord::InvalidForeignKey, with: :unprocessable_entity

    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  end

  private

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def bad_request
    render json: { error: 'Bad request' }, status: :bad_request
  end

  def forbidden
    render json: { error: 'Forbidden' }, status: :forbidden
  end

  def not_found
    render json: { error: 'Not found' }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: { error: exception.record ? exception.record.errors.full_messages : exception },
           status: :unprocessable_entity
  end

end
