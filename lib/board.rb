# frozen_string_literal: true

class Board
  attr_reader :rows, :columns, :dimensions

  def initialize(rows = 6, columns = 7)
    @rows = rows
    @columns = columns
    @dimensions = Array.new(rows) { Array.new(columns, 0) }
  end
end
