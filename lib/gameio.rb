# frozen_string_literal: true

require 'json'

require_relative 'messages'
require_relative 'gamemanager'

# GameIO Class
# This class provides input/output methods for the Connect Four gam
class GameIO
  SAVE_DIR = './save'
  MAX_FILENAME_LENGTH = 8

  # Saves the current game state to a file
  #   @param game_manager [GameManager] the current game state to be saved
  #
  #   @return [nil] prints a message indicating the success or failure of the save
  def self.save_game(game_manager)
    Messages.clear_screen
    list_saved_games
    save_name = Messages.ask_save_name(MAX_FILENAME_LENGTH, SAVE_DIR)
    return unless save_name # exit if the user cancels

    save_data = game_manager.serialize

    begin
      File.open("#{SAVE_DIR}/#{save_name}.json", 'w') { |file| file.write(save_data.to_json) }
      puts "File created: #{SAVE_DIR}/#{save_name}.json"
      sleep(1)
    rescue => e
      puts "Error saving file: #{e.message}"
      sleep(1)
    end
  end

  # Loads a saved game from a file
  #   @return [Boolean] false if no saved games are found, otherwise returns the result of the play_round method
  def self.load_game
    files = Dir.entries(SAVE_DIR).select { |file| file.end_with?('.json') }
    if files.empty?
      puts 'No saved games found.'
      sleep(1)
      return false
    end
    puts 'Saved games:'
    puts ''
    list_saved_games

    file_number = Messages.ask_file_number(files.size)

    file_path = "#{SAVE_DIR}/#{files[file_number - 1]}"
    game_manager = GameManager.deserialize(File.read(file_path))
    puts "Game loaded from #{file_path}."
    sleep(0.5)
    game_manager.loaded_player = game_manager.current_player
    game_manager.play_round
  end
  
  # Lists all saved games
  #   @return [nil] prints a list of all saved games to the console
  def self.list_saved_games
    files = Dir.entries(SAVE_DIR).select { |file| file.end_with?('.json') }
    files.each_with_index { |file, index| puts "#{index + 1}. #{File.basename(file, '.*')}" }
  end
end
