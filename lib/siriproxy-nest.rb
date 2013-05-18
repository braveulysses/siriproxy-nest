require 'nest_thermostat'

# TODO: Report general Nest status
# TODO: Report time until target temperature

class SiriProxy::Plugin::Nest < SiriProxy::Plugin

  LOWER_LIMIT = 50
  UPPER_LIMIT = 90

  attr_reader :email
  attr_reader :password
  attr_reader :nest

  def initialize(config)
    @email = config["email"]
    @password = config["password"]

    @nest = NestThermostat::Nest.new({
      email: @email,
      password: @password
    })

  end

  read_patterns = [ "house %s", "inside %s", "%s in here", "%s inside" ]

  read_patterns.map do |pattern|
    command = pattern % [ "temperature" ]
    listen_for(/#{command}/i) { respond_with_temperature }
    command = pattern % [ "humidity" ]
    listen_for(/#{command}/i) { respond_with_humidity }
  end

  listen_for(/leaf status/i) { respond_with_leaf_status }

  set_patterns = [ "set the temperature to",
                   "set the thermostat to",
                   "set the Nest to" ]
  set_patterns.map do |pattern|
    listen_for /#{pattern} ([0-9,]*[0-9])/i do |temperature|
      set_temperature temperature
      request_completed
    end
  end

  [ "I'm leaving", "we're leaving",
    "set the thermostat to away", 
    "set nest to away", "set away", "set to away",
    "start away mode" ].map do |command|
    listen_for(/#{command}/i) { set_away_mode }
  end

  [ "I'm back", "we're back", 
    "I'm home", "we're home",
    "stop away mode", "cancel away mode" ].map do |command|
    listen_for(/#{command}/i) { end_away_mode }
  end

  def respond_with_temperature
    temp = @nest.current_temperature.round()
    say "The house temperature is #{temp} degrees."
    request_completed
  end

  def respond_with_humidity
    humidity = @nest.humidity.round()
    say "The indoor humidity is #{humidity} percent."
    request_completed
  end

  def respond_with_leaf_status
    leaf_status = @nest.leaf
    if leaf_status
      say "You have a leaf. Good for you!"
    else
      say "You don't have a leaf right now. Try to save energy!"
    end
    request_completed
  end

  def is_numeric?(object)
    true if Float(object) rescue false
  end

  def set_temperature(temperature)
    if is_numeric?(temperature)
      if temperature.to_i < LOWER_LIMIT or temperature.to_i > UPPER_LIMIT
        say "I'm sorry. I can't do that."
      else
        @nest.temperature = temperature
        say "I've set the thermostat to #{temperature} degrees."
      end
    else
      say "That's not a temperature."
    end
    request_completed
  end

  def set_away_mode
    @nest.away = true
    say "The Nest is now in away mode."
    request_completed
  end

  def end_away_mode
    @nest.away = false
    say "The Nest is now out of away mode."
    request_completed
  end

end
