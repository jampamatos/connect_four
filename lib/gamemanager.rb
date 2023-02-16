# frozen_string_literal: true

require 'colorize'

require_relative 'board'
require_relative 'player'
require_relative 'messages'
require_relative 'gameio'


class GameManager
  attr_accessor :player1, :player2, :ties, :board, :games_played, :current_player, :loaded_player

  def initialize(player1 = nil, player2 = nil, board = nil, current_player = nil)
    @player1 = player1
    @player2 = player2
    @ties = 0
    @board = board
    @games_played = 0
    @current_player = current_player
    @loaded_player = false
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
      GameIO.load_game
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

    @current_player = @loaded_player if @loaded_player
    @loaded_player = false

    loop do
      Messages.clear_screen
      Messages.display_turn(@current_player)
      @board.show_board
      loop do
        input = Messages.input_column(@current_player)
        case input
        when 's'
          save_game
        when 'l'
          GameIO.load_game
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

  def serialize
    {
      'player1' => @player1.serialize,
      'player2' => @player2.serialize,
      'ties' => @ties,
      'board' => @board.serialize,
      'games_played' => @games_played,
      'current_player' => @current_player.serialize
    }.to_json
  end

  def self.deserialize(data)
    game_data = JSON.parse(JSON.parse(data))
    player1 = Player.deserialize(game_data['player1'])
    player2 = Player.deserialize(game_data['player2'])
    board = Board.deserialize(game_data['board'])
    current_player = Player.deserialize(game_data['current_player'])
    ties = game_data['ties']
    games_played = game_data['games_played']

    game_manager = GameManager.new(player1, player2, board, current_player)
    game_manager.ties = ties
    game_manager.games_played = games_played

    game_manager
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

  def save_game
    GameIO.save_game(self)
  end
end
