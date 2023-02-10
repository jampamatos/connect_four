# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'messages'

require 'json'

class GameManager
  attr_accessor :player1, :player2, :player1_wins, :player2_wins, :ties, :board, :first

  @player1 = nil
  @player2 = nil

  @ties = 0

  @board = nil

  @first = @player1
  @current_player = @player1

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
      if load_game
        play_round
      else
        puts ''
        puts 'Returning to main menu...'
        puts ''
        sleep(2)
        start_game
      end
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
    play_round
  end

  def play_round
    loop do
      players = @first == @player1 ? [@player1, @player2] : [@player2, @player1]
      players.each do |player|
        @current_player = player
        Messages.clear_screen
        Messages.display_turn(player)
        @board.show_board
        loop do
          input = Messages.input_column(player)
          case input
          when 's'
            save_game
            next
          when 'l'
            unless load_game
              puts ''
              puts 'Returning to game...'
              puts ''
              sleep(1)
              Messages.clear_screen
              @board.show_board
              next
            end
          else
            column = input.to_i
            @board.place_chip(player, column)
            break
          end
        rescue StandardError => e
          if e.message == 'Column is full'
            puts 'Column is full. Please select another column.'
          elsif e.message == 'Placement outside of board boundaries'
            puts 'Placement outside of board boundaries. Please select a valid column.'
          else
            raise e
          end
        end
        game_is_over(@board.game_over?) if @board.game_over?
      end
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
    @board.show_board
    puts ''
    puts "The game is a #{'tie'.bold}!"
    @ties += 1
    puts ''
    show_scores
    play_again
  end

  def game_victory(player)
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
        @first = @first == @player1 ? @player2 : @player1
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
    save_directory = './save'
    Dir.mkdir(save_directory) unless Dir.exist?(save_directory)

    save_file = ''
    until (3..8).cover?(save_file.length)
      puts 'Please enter a save game file name (3 to 8 characters long):'
      save_file = gets.chomp
      unless (3..8).cover?(save_file.length)
        puts 'The save game file name must have between 3 to 8 characters. Please try again.'
      end
    end

    save_file = File.join(save_directory, "#{save_file}.json")

    data = {
      board: @board.serialize,
      player1: @player1.serialize,
      player2: @player2.serialize,
      current_player: @current_player,
      first: @first
    }

    File.open(save_file, 'w') { |file| file.write(data.to_json) }
    puts "Game saved successfully to #{save_file}."
  end

  def load_game
    Messages.clear_screen
    save_directory = './save'
    Dir.mkdir(save_directory) unless Dir.exist?(save_directory)

    save_files = Dir.glob("#{save_directory}/*.json")
    if save_files.empty?
      puts 'No saved games found.'
      return false
    end

    puts 'Select a save game to load:'
    save_files.each_with_index do |file, index|
      puts "#{index + 1}. #{File.basename(file, '.json')}"
    end

    selected_index = gets.to_i - 1
    until selected_index >= 0 && selected_index < save_files.length
      puts 'Invalid selection. Please try again.'
      selected_index = gets.to_i - 1
    end

    data = JSON.parse(File.read(save_files[selected_index]))
    @board = Board.deserialize(data['board'])
    @player1 = Player.deserialize(data['player1'])
    @player2 = Player.deserialize(data['player2'])
    @current_player = data['current_player']
    @first = data['first']

    puts "Game loaded successfully from #{save_files[selected_index]}."
    @board.show_board
    true
  end
end
