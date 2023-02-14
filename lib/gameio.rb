# frozen_string_literal: true

# The GameIO class is responsible for saving and loading game data to and from a file.
# It provides class methods for loading and saving game data as well as a method for clearing the console screen.
#
# Example usage:
#
# To save a game, use the `GameIO.save_game` method with the current board and player information:
#
#     GameIO.save_game(board, player1, player2, current_player, first)
#
# To load a saved game, use the `GameIO.load_game` method:
#
#     game_data = GameIO.load_game
#     board = game_data[:board]
#     player1 = game_data[:player1]
#     player2 = game_data[:player2]
#     current_player = game_data[:current_player]
#     first = game_data[:first]
#
# To clear the console screen, use the `GameIO.clear_screen` method:
#
#     GameIO.clear_screen
#
# This class assumes that game data is being saved and loaded in JSON format and 
# that saved games are located in a './save' directory.
class GameIO
  SAVE_DIRECTORY = './save'.freeze

  # Public: Load a saved game from a JSON file.
  # This method attempts to load a saved game from a JSON file in the ./save directory. The file must have a '.json'
  # extension, and the contents must be valid JSON data in the format expected by the game. If successful, the method
  # returns a hash containing the loaded game data, which can be used to restore the game state.
  # If no saved games are found in the ./save directory, the method prints a message to the console and returns false.
  # If an error occurs during loading, such as an invalid file format or missing data, the method raises an exception.
  #
  # Examples
  #   GameIO.load_game
  #   => { board: <Board>, player1: <Player>, player2: <Player>, current_player: <Symbol>, first: <Boolean> }
  #
  #   return [Hash] containis the loaded game data if successful, or false if no saved games are found. 
  #   raises an exception if an error occurs during loading.
  def self.load_game
    clear_screen
    Dir.mkdir(SAVE_DIRECTORY) unless Dir.exist?(SAVE_DIRECTORY)

    save_files = Dir.glob("#{SAVE_DIRECTORY}/*.json")
    return puts 'No saved games found.' if save_files.empty?

    puts 'Select a save game to load:'
    save_files.each_with_index do |file, index|
      puts "#{index + 1}. #{File.basename(file, '.json')}"
    end

    selected_index = get_input_from_user(save_files.length) - 1
    save_file = save_files[selected_index]
    data = JSON.parse(File.read(save_file))

    {
      board: Board.deserialize(data['board']),
      player1: Player.deserialize(data['player1']),
      player2: Player.deserialize(data['player2']),
      current_player: data['current_player'],
      first: data['first']
    }
  end

  # Public: Save the current game state to a JSON file.
  # This method saves the current game state to a JSON file in the ./save directory. The file is named by the user, with
  # the .json extension automatically appended. The contents of the file are a JSON object containing the board state,
  # player information, and other relevant data needed to restore the game.
  # If the save directory does not exist, it is created automatically. If the user specifies an invalid filename, such as
  # one that is too short or too long, the method prompts the user to enter a valid name.
  # Examples
  #   GameIO.save_game(<Board>, <Player>, <Player>, <Symbol>, <Boolean>)
  #   => "Game saved successfully to ./save/game1.json."
  #
  # returns [String] success message with the filename of the saved game.
  def self.save_game(board, player1, player2, current_player, first)
    Dir.mkdir(SAVE_DIRECTORY) unless Dir.exist?(SAVE_DIRECTORY)

    save_file = ''
    until (3..8).cover?(save_file.length)
      puts 'Please enter a save game file name (3 to 8 characters long):'
      save_file = gets.chomp
      puts 'The save game file name must have between 3 to 8 characters. Please try again.' unless (3..8).cover?(save_file.length)
    end

    save_file = File.join(SAVE_DIRECTORY, "#{save_file}.json")
    data = {
      board: board.serialize,
      player1: player1.serialize,
      player2: player2.serialize,
      current_player: current_player,
      first: first
    }
    File.write(save_file, data.to_json)
    puts "Game saved successfully to #{save_file}."
  end

  def self.clear_screen
    system('clear') || system('cls')
  end

  def self.get_input_from_user(max_value)
    loop do
      selected_index = gets.to_i
      return selected_index if selected_index.between?(1, max_value)

      puts 'Invalid selection. Please try again.'
    end
  end
end
