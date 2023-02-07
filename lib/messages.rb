# frozen_string_literal: true

module Messages
  COLORS = %w[red green blue yellow cyan magenta].freeze

  def self.game_setup_msg
    player_one_name = get_player_name("1")
    player_one_color = get_player_color("1")
    player_two_name = get_player_name("2")
    player_two_color = get_player_color("2")
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
end