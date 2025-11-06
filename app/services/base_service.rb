# Base service class that all services inherit from
# Provides a consistent interface for service objects
class BaseService
  # Class method to call the service
  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  # Instance method to be implemented by subclasses
  def call
    raise NotImplementedError, "#{self.class} must implement #call"
  end

  private

  # Return a successful result
  def success(data = nil)
    Result.new(success: true, data: data, error: nil)
  end

  # Return a failed result
  def failure(error)
    Result.new(success: false, data: nil, error: error)
  end
end

# Result object for service responses
Result = Struct.new(:success, :data, :error, keyword_init: true) do
  def success?
    success
  end

  def failure?
    !success
  end
end
