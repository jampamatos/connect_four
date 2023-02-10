# frozen_string_literal: true

require 'json'

# Player Class
# The `Player` class represents a player in a Connect Four game.
# It contains the player's name, color, and number of wins.
# The class has methods for incrementing the number of wins and serializing/deserializing player data to/from JSON.
class Player
  attr_accessor :name, :color, :wins

  # Initialize a new `Player` instance
  #   @param name [String] The player's name
  #   @param color [String] The player's color
  #   @param wins [Integer] The number of wins the player has, defaults to 0
  def initialize(name, color, wins = 0)
    @name = name
    @color = color
    @wins = wins
  end

  # Increment the number of wins for the player
  def increment_wins
    @wins += 1
  end

  # Serialize the player data to a JSON string
  #   @return [String] The JSON representation of the player data
  def serialize
    { name: @name, color: @color, wins: @wins }.to_json
  end

  # Deserialize a JSON string into a `Player` instance
  #   @param serialized_player [String] The JSON representation of the player data
  #
  #   @return [Player] The deserialized `Player` instance
  def self.deserialize(serialized_player)
    data = JSON.parse(serialized_player)
    Player.new(data['name'], data['color'], data['wins'])
  end
end
