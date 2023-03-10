# frozen_string_literal: true

require_relative '../lib/board'

require 'json'

describe Board do
  describe '#initialize' do
    it 'creates a 6x7 game board' do
      board = Board.new
      expect(board.grid.size).to eq(6)
      expect(board.grid[0].size).to eq(7)
    end

    it 'creates a 7x6 game board' do
      board = Board.new(7, 6)
      expect(board.grid.size).to eq(7)
      expect(board.grid[0].size).to eq(6)
    end

    it 'creates an empty game board' do
      board = Board.new
      expect(board.grid).to eq(Array.new(6) { Array.new(7) })
    end

    it 'creates a game board with a minimum of 4 rows' do
      board = described_class.new(4, 6)
      expect(board.grid.size).to eq(4)
      expect(board.grid[0].size).to eq(6)
    end

    it 'creates a game board with a minimum of 4 columns' do
      board = described_class.new(6, 4)
      expect(board.grid.size).to eq(6)
      expect(board.grid[0].size).to eq(4)
    end
  end

  describe '#place_chip' do
    subject(:board_chip) { described_class.new }
    let(:player) { double('player', color: 'red') }

    it 'place chip at the bottom cell in first column when entire column is unoccupied' do
      board_chip.place_chip(player, 0)
      expect(board_chip.grid[5][0]).to eq('red')
    end

    it 'place chip at the second cell in first column when first cell is occupied' do
      board_chip.place_chip(player, 0)
      board_chip.place_chip(player, 0)
      expect(board_chip.grid[4][0]).to eq('red')
    end

    it 'place chip at the third cell in third column when two first cells are occupied' do
      board_chip.place_chip(player, 2)
      board_chip.place_chip(player, 2)
      board_chip.place_chip(player, 2)
      expect(board_chip.grid[3][2]).to eq('red')
    end
  end

  describe '#check_horizontal' do
    subject(:board_horizontal) { described_class.new }
    let(:player1) { double('player1', color: 'red') }
    let(:player2) { double('player2', color: 'yellow') }

    it "return 'red' when player 1 has an horizontal win" do
      board_horizontal.place_chip(player1, 0)
      board_horizontal.place_chip(player1, 1)
      board_horizontal.place_chip(player1, 2)
      board_horizontal.place_chip(player1, 3)
      expect(board_horizontal.check_horizontal).to eq('red')
    end

    it "return 'yellow' when player 2 has an horizontal win" do
      board_horizontal.place_chip(player2, 0)
      board_horizontal.place_chip(player2, 1)
      board_horizontal.place_chip(player2, 2)
      board_horizontal.place_chip(player2, 3)
      expect(board_horizontal.check_horizontal).to eq('yellow')
    end

    it 'return nil if four horizontal chips are not the same color' do
      board_horizontal.place_chip(player1, 0)
      board_horizontal.place_chip(player2, 1)
      board_horizontal.place_chip(player1, 2)
      board_horizontal.place_chip(player2, 3)
      expect(board_horizontal.check_horizontal).to eq(nil)
    end

    it "returns nil if there's no horizontal win yet" do
      board_horizontal.place_chip(player1, 0)
      board_horizontal.place_chip(player1, 1)
      expect(board_horizontal.check_horizontal).to eq(nil)
    end

    it 'works correctly for a win that starts at the first row' do
      board_horizontal.place_chip(player1, 0)
      board_horizontal.place_chip(player1, 1)
      board_horizontal.place_chip(player1, 2)
      board_horizontal.place_chip(player1, 3)
      expect(board_horizontal.check_horizontal).to eq('red')
    end

    it 'works correctly for a win that starts at a non-zero row' do
      board_horizontal.place_chip(player1, 3)
      board_horizontal.place_chip(player1, 4)
      board_horizontal.place_chip(player1, 5)
      board_horizontal.place_chip(player1, 6)
      expect(board_horizontal.check_horizontal).to eq('red')
    end
  end

  describe '#check_vertical' do
    subject(:board_vertical) { described_class.new }
    let(:player1) { double('player1', color: 'red') }
    let(:player2) { double('player2', color: 'yellow') }

    it "return 'red' when player 1 has an vertical win" do
      4.times { board_vertical.place_chip(player1, 1) }
      expect(board_vertical.check_vertical).to eq('red')
    end

    it "return 'yellow' when player 2 has an vertical win" do
      4.times { board_vertical.place_chip(player2, 3) }
      expect(board_vertical.check_vertical).to eq('yellow')
    end

    it 'return nil if four vertical chips are not the same color' do
      board_vertical.place_chip(player1, 0)
      board_vertical.place_chip(player2, 0)
      board_vertical.place_chip(player1, 0)
      board_vertical.place_chip(player2, 0)
      expect(board_vertical.check_vertical).to eq(nil)
    end

    it "it returns nil if there's no vertical win yet" do
      3.times { board_vertical.place_chip(player1, 3) }
      expect(board_vertical.check_vertical).to eq(nil)
    end

    it 'works correctly for a win that starts at the first column' do
      4.times { board_vertical.place_chip(player1, 0) }
      expect(board_vertical.check_vertical).to eq('red')
    end

    it 'works correctly for a win that starts at a non-zero column' do
      4.times { board_vertical.place_chip(player1, 6) }
      expect(board_vertical.check_vertical).to eq('red')
    end
  end

  describe '#check_diagonal' do
    it "return 'red' when player 1 has a diagonal top left to bottom right win" do
      board = Board.new
      board.grid =
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['red', nil, nil, nil, nil, nil, nil],
          [nil, 'red', nil, nil, nil, nil, nil],
          [nil, nil, 'red', nil, nil, nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil]
        ]

      expect(board.check_diagonal).to eq('red')
    end

    it "return 'red' when player 1 has an diagonal bottom left to top right win" do
      board = Board.new
      board.grid =
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil],
          [nil, nil, 'red', nil, nil, nil, nil],
          [nil, 'red', nil, nil, nil, nil, nil],
          ['red', nil, nil, nil, nil, nil, nil]
        ]

      expect(board.check_diagonal).to eq('red')
    end

    it "return 'yellow' when player 2 has an diagonal top left to bottom right win" do
      board = Board.new
      board.grid =
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['yellow', nil, nil, nil, nil, nil, nil],
          [nil, 'yellow', nil, nil, nil, nil, nil],
          [nil, nil, 'yellow', nil, nil, nil, nil],
          [nil, nil, nil, 'yellow', nil, nil, nil]
        ]

      expect(board.check_diagonal).to eq('yellow')
    end

    it 'it works correctly for a win starting from the middle of the board' do
      board = Board.new
      board.grid =
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, 'red', nil],
          [nil, nil, nil, nil, 'red', nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil],
          [nil, nil, 'red', nil, nil, nil, nil]
        ]

      expect(board.check_diagonal).to eq('red')
    end

    it 'return nil if four diagonal chips are not the same color' do
      board = Board.new
      board.grid =
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          ['yellow', nil, nil, nil, nil, nil, nil],
          [nil, 'red', nil, nil, nil, nil, nil],
          [nil, nil, 'yellow', nil, nil, nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil]
        ]

      expect(board.check_diagonal).to eq(nil)
    end

    it "returns nil if there's no diagonal win yet" do
      board = Board.new
      board.grid =
        [
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, 'red', nil, nil],
          [nil, nil, nil, 'red', nil, nil, nil],
          [nil, nil, 'red', nil, nil, nil, nil]
        ]

      expect(board.check_diagonal).to eq(nil)
    end
  end

  describe '#game_over?' do
    subject(:board_game_over) { described_class.new }
    let(:player1) { double('player1', color: 'red') }
    let(:player2) { double('player2', color: 'yellow') }

    it 'returns nil if there is no win' do
      board_game_over.place_chip(player1, 0)
      board_game_over.place_chip(player2, 1)
      board_game_over.place_chip(player1, 2)
      board_game_over.place_chip(player2, 3)
      expect(board_game_over.game_over?).to eq(nil)
    end

    it 'player 1 has won the game' do
      board_game_over.place_chip(player1, 0)
      board_game_over.place_chip(player1, 1)
      board_game_over.place_chip(player1, 2)
      board_game_over.place_chip(player1, 3)
      expect(board_game_over.game_over?).to eq('red')
    end

    it 'player 2 has won the game' do
      board_game_over.place_chip(player2, 0)
      board_game_over.place_chip(player2, 1)
      board_game_over.place_chip(player2, 2)
      board_game_over.place_chip(player2, 3)
      expect(board_game_over.game_over?).to eq('yellow')
    end

    it 'game is tied' do
      board_game_over.grid =
      [
        ['yellow', 'blue', 'luke', 'i', 'am', 'your', 'father'],
        ['red', 'rorange', 'ja', 'bo', 'ti', 'ca', 'ba'],
        ['yellow', 'red', 'dead', 'redemption', 'two', 'rock', 'star'],
        ['red', 'red', 'man', 'i am', 'outta', 'words', 'to fill'],
        ['yellow', 'yellow', 'pink', 'mango', 'fruit', 'loops', 'avocado'],
        ['red', 'maybe red', 'not red', 'red', 'reddish', 'nil', 'pink']
      ]
      expect(board_game_over.game_over?).to eq('tie')
    end
  end

  describe '#serialize' do
    it 'serializes the board to a Hash' do
      board = Board.new
      board.place_chip(double('player', color: 'red'), 0)
      board.place_chip(double('player', color: 'yellow'), 0)
      board.place_chip(double('player', color: 'red'), 1)

      data = board.serialize

      expect(data[:grid]).to eq([
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        ['yellow', nil, nil, nil, nil, nil, nil],
        ['red', 'red', nil, nil, nil, nil, nil]
      ])
    end
  end

  describe '#deserialize' do
    it 'deserializes a Hash to a board object' do
      data = {'grid' => [["red","yellow",nil,nil,nil,nil,nil],["red",nil,nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil,nil,nil],[nil,nil,nil,nil,nil,nil,nil]]}
      board = Board.deserialize(data)

      expect(board.grid).to eq([
        ['red', 'yellow', nil, nil, nil, nil, nil],
        ['red', nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil]
      ])
    end
  end


end
