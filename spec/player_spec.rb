# frozen_string_literal: true

require_relative '../lib/player'

require 'json'

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

  describe '#increment_wins' do
    subject(:player_increment_one) { described_class.new('Jampa', 'red') }
    subject(:player_increment_two) { described_class.new('Matos', 'yellow') }

    it 'increments @wins by 1 if called only once' do
      player_increment_one.increment_wins
      expect(player_increment_one.wins).to eq(1)
    end

    it 'does not increment @wins of another player' do
      player_increment_one.increment_wins
      expect(player_increment_two.wins).to eq(0)
    end

    it 'increments @wins by 3 if method called 3 times' do
      3.times { player_increment_one.increment_wins }
      expect(player_increment_one.wins).to eq(3)
    end

    it 'does not increment @wins if method not called' do
      expect(player_increment_one.wins).to eq(0)
      expect(player_increment_two.wins).to eq(0)
    end
  end

  describe '#serialize' do
    it 'serializes a two parameters player data to a Hash' do
      player = Player.new('John', 'red')
      json = player.serialize
      data = json
      expect(data[:name]).to eq('John')
      expect(data[:color]).to eq('red')
      expect(data[:wins]).to eq(0)
    end

    it 'serializes a three parameters player data to a Hash' do
      player = Player.new('Matthew', 'blue', 3)
      json = player.serialize
      data = json
      expect(data[:name]).to eq('Matthew')
      expect(data[:color]).to eq('blue')
      expect(data[:wins]).to eq(3)
    end
  end

  describe '.deserialize' do
    it 'deserializes player data from a Hash' do
      json = {'name' => "Alice", 'color' => "blue", 'wins' => 3}
      player = Player.deserialize(json)
      expect(player.name).to eq('Alice')
      expect(player.color).to eq('blue')
      expect(player.wins).to eq(3)
    end
  end

end
