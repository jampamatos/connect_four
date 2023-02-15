# frozen_string_literal: true

require_relative '../lib/gamemanager'

require 'json'

describe GameManager do
  describe '#serialize' do
    it 'serializes the game manager to a JSON string' do
      game_manager = GameManager.new
      game_manager.player1 = Player.new('John', 'red')
      game_manager.player2 = Player.new('Jane', 'blue')
      game_manager.ties = 1
      game_manager.board = Board.new(6, 7, [
                                       ['red', 'blue', nil, nil, nil, nil, nil],
                                       ['red', 'blue', nil, nil, nil, nil, nil],
                                       ['red', 'red', 'blue', nil, nil, nil, nil],
                                       ['blue', 'blue', 'red', 'red', nil, nil, nil],
                                       ['red', 'blue', 'red', 'red', 'blue', nil, nil],
                                       ['red', 'blue', 'red', 'blue', 'blue', 'red', nil]
                                     ])
      game_manager.games_played = 10
      game_manager.current_player = game_manager.player1

      json = game_manager.serialize
      data = JSON.parse(json)

      expect(data['player1']).to eq({
                                      'name' => 'John',
                                      'color' => 'red',
                                      'wins' => 0
                                    })

      expect(data['player2']).to eq({
                                      'name' => 'Jane',
                                      'color' => 'blue',
                                      'wins' => 0
                                    })

      expect(data['ties']).to eq(1)
      expect(data['games_played']).to eq(10)
      expect(data['current_player']).to eq({
                                             'name' => 'John',
                                             'color' => 'red',
                                             'wins' => 0
                                           })

      expect(data['board']).to eq({
        'grid' => [
          ['red', 'blue', nil, nil, nil, nil, nil],
          ['red', 'blue', nil, nil, nil, nil, nil],
          ['red', 'red', 'blue', nil, nil, nil, nil],
          ['blue', 'blue', 'red', 'red', nil, nil, nil],
          ['red', 'blue', 'red', 'red', 'blue', nil, nil],
          ['red', 'blue', 'red', 'blue', 'blue', 'red', nil]
        ]
      })
    end

    it 'deserializes a JSON string to a game manager object' do
      original_game_manager = GameManager.new
      original_game_manager.player1 = Player.new('John', 'red')
      original_game_manager.player2 = Player.new('Jane', 'blue')
      original_game_manager.ties = 1
      original_game_manager.board = Board.new(6, 7, [
                                       ['red', 'blue', nil, nil, nil, nil, nil],
                                       ['red', 'blue', nil, nil, nil, nil, nil],
                                       ['red', 'red', 'blue', nil, nil, nil, nil],
                                       ['blue', 'blue', 'red', 'red', nil, nil, nil],
                                       ['red', 'blue', 'red', 'red', 'blue', nil, nil],
                                       ['red', 'blue', 'red', 'blue', 'blue', 'red', nil]
                                     ])
      original_game_manager.games_played = 10
      original_game_manager.current_player = original_game_manager.player1
    
      json = original_game_manager.serialize
      deserialized_game_manager = GameManager.deserialize(json)
    
      expect(deserialized_game_manager.player1.name).to eq('John')
      expect(deserialized_game_manager.player1.color).to eq('red')
      expect(deserialized_game_manager.player1.wins).to eq(0)
    
      expect(deserialized_game_manager.player2.name).to eq('Jane')
      expect(deserialized_game_manager.player2.color).to eq('blue')
      expect(deserialized_game_manager.player2.wins).to eq(0)
    
      expect(deserialized_game_manager.ties).to eq(1)
      expect(deserialized_game_manager.games_played).to eq(10)
      expect(deserialized_game_manager.current_player.name).to eq('John')
      expect(deserialized_game_manager.current_player.color).to eq('red')
      expect(deserialized_game_manager.current_player.wins).to eq(0)
    
      expect(deserialized_game_manager.board.grid).to eq([
        ['red', 'blue', nil, nil, nil, nil, nil],
        ['red', 'blue', nil, nil, nil, nil, nil],
        ['red', 'red', 'blue', nil, nil, nil, nil],
        ['blue', 'blue', 'red', 'red', nil, nil, nil],
        ['red', 'blue', 'red', 'red', 'blue', nil, nil],
        ['red', 'blue', 'red', 'blue', 'blue', 'red', nil]
      ])
    end
  end
end
