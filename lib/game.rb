# frozen_string_literal: true

require_relative 'cage'
require_relative 'player'

# Represents a single game of Connect Four.
class Game
  def initialize(cage = ::Cage.new, players = [::Player.new(1, '#'), ::Player.new(2, '@')])
    @players = players
    @cage = cage
    @current_player_index = 0
    @current_player = players[0]

    @players.each do |player|
      puts("Player #{player.number}, your pieces will show this symbol: #{player.symbol}")
    end
    puts("\n")
  end

  def play
    loop do
      selected_column_index = elicit_column_selection
    rescue ArgumentError, IndexError
      puts('That is not a valid column - please try again.')
      redo
    else
      finalize_move(selected_column_index)
      return true if game_over?

      swap_current_player
    end
  end

  private

  def elicit_column_selection
    print "Player #{@current_player.number} [#{@current_player.symbol}], please select a column, from 1-7: "
    selected_column = @players[@current_player_index].select_column
    selected_column_index = Integer(selected_column) - 1
    if @cage.column_exists?(selected_column_index) && !@cage.filled_in_column?(selected_column_index)
      return selected_column_index
    end

    raise IndexError, 'Invalid Column Index'
  end

  def finalize_move(selected_column_index)
    @cage.add_piece_to_column(@current_player.symbol, selected_column_index)
    puts(@cage)
  end

  def game_over?
    if @cage.full?
      puts('The board is now full, resulting in a tie game.')
      true
    elsif @cage.has_four_in_a_line_with_top_of_latest_column?
      puts("\nWinner! Player #{@current_player.number} [#{@current_player.symbol}] connected four in a row!")
      true
    else
      false
    end
  end

  def swap_current_player
    @current_player_index = (@current_player_index + 1) % 2
    @current_player = @players[@current_player_index]
  end
end
