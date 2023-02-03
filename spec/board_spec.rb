# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    it 'creates a 6x7 game board' do
      board = Board.new
      expect(board.rows).to eq(6)
      expect(board.columns).to eq(7)
    end

    it 'creates a 7x6 game board' do
      board = Board.new(7, 6)
      expect(board.rows).to eq(7)
      expect(board.columns).to eq(6)
    end

    it 'creates an empty game board' do
      board = Board.new
      expect(board.dimensions).to eq(Array.new(6) { Array.new(7, 0) })
    end

    it 'creates a game board with a minimum of 4 rows' do
      board = described_class.new(4, 6)
      expect(board.rows).to eq(4)
      expect(board.columns).to eq(6)
    end

    it 'creates a game board with a minimum of 4 columns' do
      board = described_class.new(6, 4)
      expect(board.rows).to eq(6)
      expect(board.columns).to eq(4)
    end
  end

  describe '#place_chip' do
    xit 'place chip at the lowest unoccupied cell in a column' do
    end

    xit 'raise an error if the column is full and cannot place chip' do
    end

    xit 'correctly update the board after chip placement' do
    end

    xit 'prevent placement outside the boundaries of the game board.' do
    end
  end
end
