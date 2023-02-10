# frozen_string_literal: true

require 'json'

class Player
  attr_accessor :name, :color, :wins

  def initialize(name, color, wins = 0)
    @name = name
    @color = color
    @wins = wins
  end

  def increment_wins
    @wins += 1
  end

  def serialize
    { name: @name, color: @color, wins: @wins }.to_json
  end

  def self.deserialize(serialized_player)
    data = JSON.parse(serialized_player)
    Player.new(data['name'], data['color'], data['wins'])
  end
end
