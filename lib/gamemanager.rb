# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'messages'

class GameManager
  attr_accessor :player1, :player2, :player1_wins, :player2_wins, :ties, :board, :first

  @player1 = nil
  @player2 = nil

  @ties = 0

  @board = nil

  @first = @player1

  def setup_game
    player1_name, player1_color, player2_name, player2_color = Messages.game_setup_msg
    @player1 = Player.new(player1_name, player1_color)
    @player2 = Player.new(player2_name, player2_color)
    @board = Board.new

    update_wins
  end

  def play_round
    loop do
      players = @first == @player1 ? [@player1, @player2] : [@player2, @player1]
      players.each do |player|
        Messages.clear_screen
        Messages.display_turn(player)
        @board.show_board
        loop do
          begin
            column = Messages.input_column(player)
            @board.place_chip(player, column)
            break
          rescue StandardError => e
            if e.message == "Column is full"
              puts "Column is full. Please select another column."
            elsif e.message == "Placement outside of board boundaries"
              puts "Placement outside of board boundaries. Please select a valid column."
            else
              raise e
            end
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
    puts "#{player.name} ".colorize(color: player.color.to_sym, mode: :bold) + "won!"
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
end
