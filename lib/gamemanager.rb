# frozen_string_literal: true

require 'colorize'
require 'singleton'

require_relative 'board'
require_relative 'player'
require_relative 'messages'
require_relative 'gameio'

require 'json'

class GameManager
  include Singleton

  attr_accessor :player1, :player2, :ties, :board, :games_played
  attr_reader :current_player

  def initialize
    @player1 = nil
    @player2 = nil
    @ties = 0
    @board = nil
    @games_played = 0
    @current_player = nil
  end

  def start_game
    Messages.clear_screen
    Messages.welcome_msg
    puts ''
    puts ''
    choice = Messages.main_menu
    case choice
    when 'N'
      setup_game
    when 'L'
      # load game logic
      puts 'load game logic'
    when 'Q'
      Messages.quit_game
    end
  end

  def setup_game
    Messages.clear_screen
    player1_name, player1_color, player2_name, player2_color = Messages.game_setup_msg
    @player1 = Player.new(player1_name, player1_color)
    @player2 = Player.new(player2_name, player2_color)
    @board = Board.new
    @current_player = @player1
    play_round
  end

  def play_round
    if @games_played.even?
      @current_player = @player1
    else
      @current_player = @player2
    end
    loop do
      Messages.clear_screen
      Messages.display_turn(@current_player)
      @board.show_board
      loop do
        input = Messages.input_column(@current_player)
        case input
        when 's'
          # save game logic
          next
        when 'l'
          # save game logic
          next
        when 'q'
          Messages.quit_game
        else
          column = input.to_i
          case @board.place_chip(@current_player, column)
          when :column_full
            puts 'Column is full. Please select another column.'
          when :placement_outside_boundaries
            puts 'Placement outside of board boundaries. Please select a valid column.'
          else
            break
          end
        end
      end
      @current_player = @current_player == @player1 ? @player2 : @player1
      game_is_over(@board.game_over?) if @board.game_over?
    end
  end

  def game_is_over(game)
    if game == 'tie'
      game_tie
    else
      player = game == @player1.color ? @player1 : @player2
      game_victory(player)
    end
  end

  private

  def show_scores
    puts 'Scoreboard:'.bold
    puts ''
    puts "#{@player1.name}: ".colorize(color: @player1.color.to_sym, mode: :bold) + @player1.wins.to_s
    puts "#{@player2.name}: ".colorize(color: @player2.color.to_sym, mode: :bold) + @player2.wins.to_s
    puts 'Ties: '.bold + @ties.to_s
    puts ''
  end

  def game_tie
    @games_played += 1
    Messages.clear_screen
    @board.show_board
    puts ''
    puts "The game is a #{'tie'.bold}!"
    @ties += 1
    puts ''
    show_scores
    play_again
  end

  def game_victory(player)
    @games_played += 1
    Messages.clear_screen
    @board.show_board
    puts ''
    puts "#{player.name} ".colorize(color: player.color.to_sym, mode: :bold) + 'won!'
    player.increment_wins
    puts ''
    show_scores
    play_again
  end

  def play_again
    loop do
      puts 'Do you want to play again? (y/n)'
      play_again = gets.chomp.downcase
      if play_again == 'y'
        @board = Board.new
        @current_player = @current_player == @player1 ? @player2 : @player1
        play_round
        break
      elsif play_again == 'n'
        Messages.quit_game
        break
      else
        puts "Invalid input. Please type 'y' or 'n'."
      end
    end
  end
end
