require 'nest_thermostat'

class SiriProxy::Plugin::Nest < SiriProxy::Plugin

  attr_accessor :email
  attr_accessor :password

  def initalize(config = {})
    self.email = config["email"]
    self.password = config["password"]

    self.nest = NestThermostat::Nest.new({
      email: self.email,
      password: self.password
    })
  end

  listen_for(/current temperature/i) do
    temp = self.nest.current_temperature
    say "The temperature is currently #{temp} degrees."
  end

  listen_for(/humidity/i) do
    humidity = self.nest.humidity
    say "The humidity is #{humidity} percent."
  end

end
