# frozen_string_literal: true

module Messages
  COLORS = %w[red green blue yellow cyan magenta].freeze

  def self.clear_screen
    if Gem.win_platform?
      system('cls')
    else
      system('clear')
    end
  end

  def self.input_column(player)
    loop do
      puts "#{player.name}, please enter a column number (1-7):"
      column = gets.chomp
      return column.to_i - 1 if column.to_i.between?(1, 7)

      puts 'Invalid input. Please enter a number between 1 and 7.'
    end
  end

  def self.game_setup_msg
    player_one_name = get_player_name('1')
    player_one_color = get_player_color('1')
    player_two_name = get_player_name('2')
    player_two_color = get_player_color('2')
    [player_one_name, player_one_color, player_two_name, player_two_color]
  end

  def self.get_player_name(player_num)
    puts "Enter player #{player_num} name:"
    gets.chomp
  end

  def self.get_player_color(player_num)
    puts "Enter player #{player_num} color (red, green, blue, yellow, cyan or magenta):"
    color = gets.chomp
    until COLORS.include?(color)
      puts "Invalid color. Enter player #{player_num} color (red, green, blue, yellow, cyan or magenta):"
      color = gets.chomp
    end
    color
  end

  def self.display_turn(player)
    puts "#{player.name}'s turn.".colorize(color: player.color.to_sym, mode: :bold)
    puts ''
  end
end
