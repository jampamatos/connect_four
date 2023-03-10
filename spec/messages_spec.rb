# frozen_string_literal: true

require_relative '../lib/messages'

describe Messages do
  describe '#input_column' do
    it 'returns a valid column number' do
      player = double(:player, name: 'John')
      allow(Messages).to receive(:gets).and_return('3')
      column = Messages.input_column(player)

      expect(column).to eq(2)
    end

    it 'repeats prompt for invalid input' do
      player = double(:player, name: 'John')
      allow(Messages).to receive(:gets).and_return('8', '-1', '0', '7')
      column = Messages.input_column(player)

      expect(column).to eq(6)
    end
  end

  describe '#game_setup_msg' do
    it 'returns an array with [player_one_name, player_one_color, player_two_name, player_two_color]' do
      allow(Messages).to receive(:gets).and_return("player 1\n", "red\n", "player 2\n", "green\n")
      result = Messages.game_setup_msg
      expect(result).to eq(['player 1', 'red', 'player 2', 'green'])
    end
  end
end
