# frozen_string_literal: true

require_relative '../lib/player'

describe Player do
  describe '#initialize' do
    it "creates a player with name 'John' and color 'red'" do
      player = Player.new('John', 'red')
      expect(player.name).to eq('John')
      expect(player.color).to eq('red')
    end

    it "creates a player with name 'Arthur' and color 'yellow'" do
      player = Player.new('Arthur', 'yellow')
      expect(player.name).to eq('Arthur')
      expect(player.color).to eq('yellow')
    end

    it 'assures a new player starts with 0 wins' do
      player = Player.new('Zé', 'green')
      expect(player.wins).to eq(0)
    end
  end
end
