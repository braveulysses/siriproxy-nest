require 'nest_thermostat'

class SiriProxy::Plugin::Nest < SiriProxy::Plugin
  attr_reader :email
  attr_reader :password
  attr_reader :nest

  patterns = [ "house %s", "inside %s", "%s in here", "%s inside" ]
  stats = [ "temperature", "humidity" ]

  def initialize(config)
    @email = config["email"]
    @password = config["password"]

    @nest = NestThermostat::Nest.new({
      email: @email,
      password: @password
    })

  end

  patterns.map do |pattern|
    command = pattern % [ "temperature" ]
    listen_for(/#{command}/i) { respond_with_temperature }
    command = pattern % [ "humidity" ]
    listen_for(/#{command}/i) { respond_with_humidity }
  end

  def respond_with_temperature
    temp = @nest.current_temperature.round()
    say "The house temperature is #{temp} degrees."
  end

  def respond_with_humidity
    humidity = @nest.humidity.round()
    say "The humidity is #{humidity} percent."
  end

end
