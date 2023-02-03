# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    it 'creates a 6x7 game board' do
      board = Board.new
      expect(board.dimensions.size).to eq(6)
      expect(board.dimensions[0].size).to eq(7)
    end

    it 'creates a 7x6 game board' do
      board = Board.new(7, 6)
      expect(board.dimensions.size).to eq(7)
      expect(board.dimensions[0].size).to eq(6)
    end

    it 'creates an empty game board' do
      board = Board.new
      expect(board.dimensions).to eq(Array.new(6) { Array.new(7) })
    end

    it 'creates a game board with a minimum of 4 rows' do
      board = described_class.new(4, 6)
      expect(board.dimensions.size).to eq(4)
      expect(board.dimensions[0].size).to eq(6)
    end

    it 'creates a game board with a minimum of 4 columns' do
      board = described_class.new(6, 4)
      expect(board.dimensions.size).to eq(6)
      expect(board.dimensions[0].size).to eq(4)
    end
  end

  describe '#valid_placement' do
    subject(:board) { described_class.new }

    it 'returns false if column is out of bounds' do
      expect(board.valid_placement?(8)).to eq(false)
    end

    it 'returns true if placement is valid' do
      expect(board.valid_placement?(0)).to eq(true)
    end
  end

  describe '#column_full?' do
    subject(:board_chip) { described_class.new }
    let(:player) { double('player', color: 'red') }

    it 'returns false if the column is not full' do
      expect(board_chip.column_full?(0)).to be(false)
    end

    it 'returns true if the column is full' do
      6.times do
        board_chip.place_chip(player, 0)
      end
      expect(board_chip.column_full?(0)).to be(true)
    end

    it 'returns false if the column is not full after some chips have been placed' do
      3.times do
        board_chip.place_chip(player, 0)
      end
      expect(board_chip.column_full?(0)).to be(false)
    end
  end

  describe '#place_chip' do
    subject(:board_chip) { described_class.new }
    let(:player) { double('player', color: 'red') }

    it 'place chip at the bottom cell in first column when entire column is unoccupied' do
      board_chip.place_chip(player, 0)
      expect(board_chip.dimensions[5][0]).to eq('red')
    end

    it 'place chip at the second cell in first column when first cell is occupied' do
      board_chip.place_chip(player, 0)
      board_chip.place_chip(player, 0)
      expect(board_chip.dimensions[4][0]).to eq('red')
    end

    it 'place chip at the third cell in third column when two first cells are occupied' do
      board_chip.place_chip(player, 2)
      board_chip.place_chip(player, 2)
      board_chip.place_chip(player, 2)
      expect(board_chip.dimensions[3][2]).to eq('red')
    end

    it 'raises an error if the column is full and cannot place chip' do
      board_chip.dimensions = Array.new(6) { Array.new(7, player.color) }
      expect { board_chip.place_chip(player, 0) }.to raise_error('Column is full')
    end
    
    it 'raises an error if the placement is outside of board boundaries' do
      expect { board_chip.place_chip(player, 7) }.to raise_error('Placement outside of board boundaries')
    end
  end
end
