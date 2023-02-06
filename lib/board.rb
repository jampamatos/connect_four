# frozen_string_literal: true

require 'pry-byebug'

class Board
  attr_reader :row_cell, :column_cell
  attr_accessor :dimensions

  def initialize(rows = 6, columns = 7)
    @dimensions = Array.new(rows) { Array.new(columns) }
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
    dimensions.each do |row|
      next if row.compact.empty?

      winner = four_consecutive_chips?(row, 4)
      return row[0] if winner
    end
    nil
  end

  def check_vertical
    dimensions.transpose.each do |column|
      next if column.compact.empty?

      winner = four_consecutive_chips?(column, 4)
      return column[-1] if winner
    end
    nil
  end

  # def game_over?
  #   pass
  # end

  private

  def four_consecutive_chips?(array, consecutive_chips)
    array.each_cons(consecutive_chips).any? do |sub_array|
      sub_array.uniq.size == 1
    end
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
end
