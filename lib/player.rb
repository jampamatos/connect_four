# frozen_string_literal: true

class Player
  attr_accessor :name, :color, :wins

  def initialize(name, color)
    @name = name
    @color = color
    @wins = 0
  end

  def increment_wins
    @wins += 1
  end
end
