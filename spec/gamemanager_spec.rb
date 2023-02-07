# frozen_string_literal: true

require_relative '../lib/gamemanager'

describe GameManager do
  describe '#setup_game' do
    before do
      allow(Messages).to receive(:game_setup_msg).and_return(%w[John red Jane blue])
      @game_manager = GameManager.new
      @game_manager.setup_game
    end

    it 'creates two player objects with given names and colors' do
      player1 = @game_manager.instance_variable_get(:@player1)
      player2 = @game_manager.instance_variable_get(:@player2)

      expect(player1.name).to eq('John')
      expect(player1.color).to eq('red')
      expect(player2.name).to eq('Jane')
      expect(player2.color).to eq('blue')
    end

    it "assures player 1 and player 2 names are 'John' and 'Jane'" do
      player1 = @game_manager.instance_variable_get(:@player1)
      player2 = @game_manager.instance_variable_get(:@player2)

      expect(player1.name).to eq('John')
      expect(player2.name).to eq('Jane')
    end

    it "assures player 1 and player 2 colors are 'red' and 'blue'" do
      player1 = @game_manager.instance_variable_get(:@player1)
      player2 = @game_manager.instance_variable_get(:@player2)

      expect(player1.color).to eq('red')
      expect(player2.color).to eq('blue')
    end

    it 'assures player 1 and player 2 wins are 0' do
      expect(@game_manager.player1_wins).to eq(0)
      expect(@game_manager.player2_wins).to eq(0)
    end
  end
end
