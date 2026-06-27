# frozen_string_literal: true

# Represents one of two players in a game of Connect Four.
class Player
  attr_reader(:number, :symbol)

  def initialize(number, symbol)
    @number = number
    @symbol = symbol
  end

  def select_column
    gets.chomp
  end
end
