# Copyright (c) 2026 Aaron Mattson
# frozen_string_literal: true

require_relative 'lib/game'

loop do
  current_game = Game.new
  current_game.play
  puts('Press Enter to play a new game or press Ctrl+C to quit.')
  gets
rescue Interrupt
  exit
end
