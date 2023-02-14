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
      puts "#{player.name}, please enter a column number (1-7), 's' to save game, 'l' to load game or 'q' to quit:"
      input = gets.chomp.downcase
      return input.to_i - 1 if input.to_i.between?(1, 7)
      return 's' if input == 's'
      return 'l' if input == 'l'
      return 'q' if input == 'q'

      puts 'Invalid input. Please enter a number between 1-7, or "s" to save game, or "l" to load game.'
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

  def self.welcome_msg
    clear_screen
    puts '                                                                        '.black.on_red
    puts '                   WELCOME TO THE CONNECT FOUR PROJECT!                 '.bold.black.on_red
    puts '                                                                        '.black.on_red
  end

  def self.quit_game
    clear_screen
    puts "#{"Thank you for playing!".bold}"
    puts ''
    puts "Done by #{'Jampa Matos'.italic}."
    exit
  end

  def self.main_menu
    puts 'Please choose an option:'
    puts "#{"(N)".colorize(:bold)}ew Game"
    puts "#{"(L)".colorize(:bold)}oad Game"
    puts "#{"(Q)".colorize(:bold)}uit"

    option = gets.chomp.upcase

    until %w[N L Q].include?(option)
      puts 'Invalid option, please choose again:'
      option = gets.chomp.upcase
    end

    option
  end
end
