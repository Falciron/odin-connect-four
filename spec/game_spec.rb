# frozen_string_literal: true

require 'game'

describe Game do
  before do
    allow($stdout).to(receive(:write))
  end

  describe '#play' do
    context 'when cage is filled without a winner' do
      subject(:full_game) { described_class.new(full_cage, [tied_player, tied_player]) }

      let(:full_cage) { instance_double(Cage) }
      let(:tied_player) { instance_double(Player, number: 1, symbol: '#') }

      before do
        allow(full_cage).to receive_messages(column_exists?: true, filled_in_column?: false, full?: true,
                                             has_four_in_a_line_with_top_of_latest_column?: false)
        allow(full_cage).to receive(:add_piece_to_column)
        allow(tied_player).to receive(:select_column).and_return('0')
      end

      it 'ends the game' do
        expect(full_game.play).to be(true)
      end
    end

    context 'when cage contains a winning line' do
      subject(:won_game) { described_class.new(winning_cage, [winning_player, winning_player]) }

      let(:winning_cage) { instance_double(Cage) }
      let(:winning_player) { instance_double(Player, number: 1, symbol: '#') }

      before do
        allow(winning_cage).to receive_messages(column_exists?: true, filled_in_column?: false, full?: false,
                                                has_four_in_a_line_with_top_of_latest_column?: true)
        allow(winning_cage).to receive(:add_piece_to_column)
        allow(winning_player).to receive(:select_column).and_return('0')
      end

      it 'ends the game' do
        expect(won_game.play).to be(true)
      end
    end
  end
end
