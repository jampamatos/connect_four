# frozen_string_literal: true

require 'pry-byebug'

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

  def check_horizontal
    @dimensions.each do |row|
      next if row.compact.empty?

      (0..(row.length - 4)).each do |i|
        win = row[i..i + 3].all? { |chip| chip == row[i] }
        return row[i] if win
      end
    end
    nil
  end

  def check_vertical
    dimensions.transpose.each do |column|
      next if column.compact.empty?

      (0..(column.length - 4)).each do |i|
        win = column[i..i + 3].all? { |chip| chip == column[i] }
        return column[i] if win
      end
    end
    nil
  end

  # def game_over?
  #   pass
  # end
end
