# ActiveModelSerializers currently specifies how to serialize errors in:
# https://github.com/rails-api/active_model_serializers/blob/master/docs/jsonapi/errors.md
# However, this only supports validation errors and doesn0't serialize them fully in accordance
# with the JSON API spec (some fields are missing), so we use our own approach
module ErrorResponses
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_error
  end

  def render_validation_errors(model)
    render json: ValidationErrorsSerializer.new(model).serialize, status: 422
  end

  def render_error(error)
    error_hash = ErrorSerializer.new(error).serialize
    status = error_hash[:errors][0][:status]
    render json: error_hash, status: status
  end
end
