class Response
  def initialize(env)
    @env = env
  end

  def headers
    { 'Content-Type'   => 'text/plain',
      'Content-Length' => self.message.bytesize.to_s}
  end

  def to_response
    [self.status, self.headers, [self.message]]
  end
end

class UnauthorisedResponse < Response
  def initialize(env, username, auth_key)
    super(env)
    @username, @auth_key = username, auth_key
  end

  def status
    401
  end

  def message
    "Unauthorised: #{@username.inspect} with #{@auth_key.inspect}.\n"
  end
end

class InvalidRequestResponse < Response
  def initialize(env, service, supported_services)
    super(env)
    @service, @supported_services = service, supported_services
  end

  def status
    400
  end

  def message
    "Invalid request: service #{@service.inspect} isn't supported. Supported services are #{@supported_services.join(', ')}\n"
  end
end

class SuccessfulGetResponse < Response
  def status
    200
  end

  def message
    "PPT is running. Yaks!\n"
  end
end

class NotFoundResponse < Response
  def status
    404
  end

  def message
    "Invalid request: #{@env['REQUEST_METHOD']} #{@env['PATH_INFO'].inspect}.\n"
  end
end
