# frozen_string_literal: true

class Board
  attr_reader :row_cell, :column_cell
  attr_accessor :dimensions

  def initialize(rows = 6, columns = 7)
    @dimensions = Array.new(rows) { Array.new(columns) }
  end

  def valid_placement?(column)
    column >= 0 && column < dimensions[0].size && !column_full?(column)
  end

  def column_full?(column)
    dimensions.each do |row|
      return false if row[column].nil?
    end
    true
  end

  def place_chip(player, column)
    return raise 'Column is full' if column_full?(column)
    return raise 'Placement outside of board boundaries' unless valid_placement?(column)

    row = dimensions.size - 1
    while row >= 0
      if dimensions[row][column].nil?
        dimensions[row][column] = player.color
        return row
      end
      row -= 1
    end
  end
end
