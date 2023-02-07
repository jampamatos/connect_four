# frozen_string_literal: true

class Board
  attr_accessor :grid

  def initialize(rows = 6, columns = 7)
    @grid = Array.new(rows) { Array.new(columns) }
  end

  def place_chip(player, column)
    return raise 'Column is full' if column_full?(column)
    return raise 'Placement outside of board boundaries' unless valid_placement?(column)

    row = grid.size - 1
    while row >= 0
      if grid[row][column].nil?
        grid[row][column] = player.color
        return row
      end
      row -= 1
    end
  end

  def check_horizontal
    grid.each do |row|
      next if row.compact.empty?

      row.each_cons(4) do |subarray|
        winner = four_consecutive_chips?(subarray, 4)
        return subarray.first if winner
      end
    end
    nil
  end

  def check_vertical
    grid.transpose.each do |column|
      next if column.compact.empty?

      column.each_cons(4) do |subarray|
        winner = four_consecutive_chips?(subarray, 4)
        return subarray.first if winner
      end
    end
    nil
  end

  def check_diagonal
    diagonal_l_to_r = diagonal_l_to_r?
    return diagonal_l_to_r if diagonal_l_to_r

    diagonal_r_to_l = diagonal_r_to_l?
    return diagonal_r_to_l if diagonal_r_to_l

    nil
  end

  def game_over?
    check = check_horizontal
    return check if check

    check = check_vertical
    return check if check

    check = check_diagonal
    return check if check

    return 'tie' if grid_full?

    nil
  end

  private

  def four_consecutive_chips?(array, consecutive_chips)
    array.each_cons(consecutive_chips).any? do |sub_array|
      sub_array.uniq.size == 1 && sub_array[0] != nil
    end
  end

  def valid_placement?(column)
    column >= 0 && column < grid[0].size && !column_full?(column)
  end

  def column_full?(column)
    grid.each do |row|
      return false if row[column].nil?
    end
    true
  end

  def diagonal_l_to_r?
    0.upto(grid.size - 4).each do |i|
      0.upto(grid[0].size - 4).each do |j|
        diagonal = [grid[i][j], grid[i + 1][j + 1], grid[i + 2][j + 2], grid[i + 3][j + 3]]
        next if diagonal.compact.empty?

        winner = four_consecutive_chips?(diagonal, 4)
        return diagonal[0] if winner
      end
    end
    nil
  end

  def diagonal_r_to_l?
    3.upto(grid.size - 1).each do |i|
      0.upto(grid[0].size - 4).each do |j|
        diagonal = [grid[i][j], grid[i - 1][j + 1], grid[i - 2][j + 2], grid[i - 3][j + 3]]
        next if diagonal.compact.empty?

        winner = four_consecutive_chips?(diagonal, 4)
        return diagonal[0] if winner
      end
    end
    nil
  end

  def grid_full?
    grid.flatten.none?(&:nil?)
  end
end
