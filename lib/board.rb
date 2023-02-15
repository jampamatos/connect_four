# frozen_string_literal: true

require 'colorize'

# Board Class
# A class representing the Connect Four game board
# It contains a grid that will hold the player's chips as they play them
# It has methods for showing the board, placing chips, checking placement and
# winning conditions, as well as serializing/deserializing its data to/from JSON
class Board
  attr_accessor :grid

  # Creates a new Connect Four game board.
  #   @param rows [Integer] The number of rows in the board. Default is 6.
  #   @param columns [Integer] The number of columns in the board. Default is 7.
  #   @param grid [Array<Array<String>>] A two-dimensional array representing the game board. Default is `nil`.
  #
  #   @return [ConnectFour] A new Connect Four game board.
  def initialize(rows = 6, columns = 7, grid = nil)
    @grid = grid || Array.new(rows) { Array.new(columns) }
  end

  # Display the game board to the console
  #   @return [nil] prints the game board to the console
  def show_board
    puts ' 1   2   3   4   5   6   7'
    grid.each_with_index do |row, i|
      row_display = row.map do |cell|
        cell.nil? ? '   ' : " #{'O'.colorize(color: cell.to_sym)} "
      end.join('|')
      puts row_display
      puts '--- --- --- --- --- --- ---'.light_yellow unless i == grid.size
    end
  end

  # Places a chip for a player in the specified column.
  # Raises an error if the column is full or the placement is outside the board boundaries.
  # The error handling is done by the calling method in the GameManager class.
  #   @param player [Player] The player who is making the move
  #   @param column [Integer] The index of the column where the chip is to be placed
  #
  #   @return [String] The color of the placed chip
  #   @raise [RuntimeError] If the specified column is full or outside the boundaries of the board
  def place_chip(player, column)
    return :column_full if column_full?(column)
    return :placement_outside_boundaries unless valid_placement?(column)

    row = grid.size - 1
    while row >= 0
      if grid[row][column].nil?
        grid[row][column] = player.color
        return row
      end
      row -= 1
    end
  end

  # Check for 4 consecutive chips of the same color in each row of the grid
  #   @return [String, Nil] the color of the first chip in the winning sequence of 4 chips if a win is detected,
  #   or nil if no win is detected
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

  # Checks for 4 consecutive chips of the same color in a vertical line on the game grid
  #   @return [Object, nil] returns the color of the winning player if there is a winner, otherwise returns nil.
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

  # Checks for 4 consecutive chips of the same color in a diagonal line
  # (left to right or right to left) on the game grid
  #   @return [Object, nil] returns the color of the winning player if there is a winner, otherwise returns nil.
  def check_diagonal
    diagonal_l_to_r = diagonal_l_to_r?
    diagonal_r_to_l = diagonal_r_to_l?
    return diagonal_r_to_l || diagonal_l_to_r if diagonal_l_to_r || diagonal_r_to_l

    nil
  end

  # Determines if the game is over and returns the result
  #   @return [Object, nil] returns the color of the winning player if there is a winner,
  #   'tie' if the game is a draw, otherwise returns nil if the game is not over.
  #
  # This method calls the #check_horizontal, #check_vertical and #check_diagonal methods to check
  # for 4 consecutive chips of the same color.
  # If a winner is found, the color of the winning player is returned. If the game grid is full and no winner is found,
  # 'tie' is returned to indicate a draw. If the game is not over, nil is returned.
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

  # Check if there are 4 consecutive chips of the same color in the given array
  #   @param array [Array] the array of chips to check
  #   @param consecutive_chips [Integer] the number of consecutive chips to look for
  #
  #   @return [Boolean] returns true if there are 4 consecutive chips of the same color, otherwise returns false.
  def four_consecutive_chips?(array, consecutive_chips)
    array.each_cons(consecutive_chips).any? do |sub_array|
      sub_array.uniq.size == 1 && !sub_array[0].nil?
    end
  end

  # Determines if a chip placement in a column is valid
  #   @param [Integer] column The column number to check for validity
  #   @return [Boolean] Returns true if the chip placement in the specified column is valid, otherwise returns false.
  def valid_placement?(column)
    column >= 0 && column < grid[0].size && !column_full?(column)
  end

  # Determines whether the specified column is full on the game grid
  #   @param column [Integer] the column to check
  #   @return [Boolean] returns true if the column is full, otherwise false.
  def column_full?(column)
    grid.each do |row|
      return false if row[column].nil?
    end
    true
  end

  # Check if there is a winning sequence of chips on the grid, from the left to the right diagonal.
  #   @return [String, nil] the winning player's chip symbol, or nil if no player has won yet
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

  # Check if there is a winning sequence of chips on the grid, from the left to the right diagonal.
  #   @return [String, nil] the winning player's chip symbol, or nil if no player has won yet
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

  # Returns a boolean indicating if the game grid is full or not.
  #   @return [Boolean] True if the grid is full, otherwise False.
  def grid_full?
    grid.flatten.none?(&:nil?)
  end
end
