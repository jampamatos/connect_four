# frozen_string_literal: true

require 'json'

require_relative 'messages'
require_relative 'gamemanager'

class GameIO
  SAVE_DIR = './save'
  MAX_FILENAME_LENGTH = 8

  def self.save_game(game_manager)
    Messages.clear_screen
    list_saved_games
    save_name = Messages.ask_save_name(MAX_FILENAME_LENGTH, SAVE_DIR)
    return unless save_name # exit if the user cancels

    save_data = game_manager.serialize

    begin
      File.open("#{SAVE_DIR}/#{save_name}.json", 'w') { |file| file.write(save_data.to_json) }
      puts "File created: #{SAVE_DIR}/#{save_name}.json"
    rescue => e
      puts "Error saving file: #{e.message}"
    end
  end

  def self.list_saved_games
    files = Dir.entries(SAVE_DIR).select { |file| file.end_with?('.json') }
    files.each_with_index { |file, index| puts "#{index + 1}. #{File.basename(file, '.*')}" }
  end
end
