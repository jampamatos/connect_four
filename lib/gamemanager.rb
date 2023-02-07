# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'messages'

class GameManager
  attr_accessor :player1, :player2, :player1_wins, :player2_wins, :ties

  @player1 = nil
  @player2 = nil

  @player1_wins = nil
  @player2_wins = nil

  @ties = 0

  def setup_game
    player1_name, player1_color, player2_name, player2_color = Messages.game_setup_msg
    @player1 = Player.new(player1_name, player1_color)
    @player2 = Player.new(player2_name, player2_color)

    update_wins
  end

  private

  def update_wins
    @player1_wins = @player1.wins
    @player2_wins = @player2.wins
  end
end
