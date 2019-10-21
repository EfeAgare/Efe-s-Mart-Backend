class AuthenticateUser

  #this is where parameters are taken when the command is called
  def initialize(name, email, password)
    @name = name
    @email = email
    @password = password
  end

  #this is where the result gets returned
  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_reader :email, :password

  def user
    user = Customer.find_by(email: email)
    
    return user if user && user.authenticate(password)
    raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
  end
end