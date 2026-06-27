# frozen_string_literal: true

# Represents a Connect Four cage with six rows and seven columns.
class Cage
  NUM_ROWS = 6
  NUM_COLUMNS = 7

  def initialize
    @columns = []
    NUM_COLUMNS.times do
      @columns << []
    end
  end

  def full?
    @columns.flatten.size == NUM_ROWS * NUM_COLUMNS
  end

  def column_exists?(column_index)
    column_index >= 0 && column_index < NUM_COLUMNS
  end

  def filled_in_column?(column_index)
    @columns[column_index].size == NUM_ROWS
  end

  def has_four_in_a_line_with_top_of_latest_column? # rubocop:disable Naming/PredicatePrefix
    return false if @latest_column.nil? || @latest_symbol.nil?

    column = join_latest_column

    row = join_latest_row

    upward_diagonal = join_latest_upward_diagonal

    downward_diagonal = join_latest_downward_diagonal

    [column, row, upward_diagonal, downward_diagonal].any? { |sequence| sequence.include?(@latest_symbol * 4) }
  end

  def to_s
    cage_string = ''

    NUM_ROWS.times do |row_index|
      cage_string += print_row(NUM_ROWS - 1 - row_index)
    end

    cage_string += "\n-------------\n1 2 3 4 5 6 7\n\n"
  end

  def add_piece_to_column(piece_symbol, column_index)
    @columns[column_index] << piece_symbol
    @latest_column = column_index
    @latest_row = @columns[column_index].size - 1
    @latest_symbol = piece_symbol
  end

  private

  def join_latest_column
    @columns[@latest_column].join
  end

  def join_latest_row
    @columns.reduce('') do |connected_row, column|
      cell_result = column[@latest_row].nil? ? ' ' : column[@latest_row]
      connected_row + cell_result
    end
  end

  def join_latest_upward_diagonal
    upward_diagonal = ''
    @columns.each_with_index do |column, column_index|
      offset_row = @latest_row + (column_index - @latest_column)
      next if offset_row.negative?

      cell_result = column[offset_row].nil? ? ' ' : column[offset_row]
      upward_diagonal += cell_result
    end
    upward_diagonal
  end

  def join_latest_downward_diagonal
    downward_diagonal = ''
    @columns.each_with_index do |column, column_index|
      offset_row = @latest_row - (column_index - @latest_column)
      next if offset_row.negative?

      cell_result = column[offset_row].nil? ? ' ' : column[offset_row]
      downward_diagonal += cell_result
    end
    downward_diagonal
  end

  def print_row(row_index)
    cage_string = "\n"
    NUM_COLUMNS.times do |column_index|
      cage_string += if @columns[column_index].size > row_index
                       "#{@columns[column_index][row_index]} "
                     else
                       '  '
                     end
    end
    cage_string
  end
end
