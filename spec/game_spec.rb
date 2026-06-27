# frozen_string_literal: true

require 'game'

describe Game do
  before do
    allow($stdout).to(receive(:write))
  end

  describe '#play' do
    context 'when a player selects an invalid column, then a valid column' do
      subject(:corrected_game) { described_class.new(empty_cage, [confused_player, confused_player]) }

      let(:empty_cage) { instance_double(Cage) }
      let(:confused_player) { instance_double(Player, number: 1, symbol: '#') }

      before do
        allow(empty_cage).to receive_messages(column_exists?: true, filled_in_column?: false, full?: false,
                                              has_four_in_a_line_with_top_of_latest_column?: true)
        allow(empty_cage).to receive(:add_piece_to_column)
        allow(confused_player).to receive(:select_column).and_return('fish', '0')
      end

      it 'sends select_column to confused_player twice' do
        corrected_game.play
        expect(confused_player).to have_received(:select_column).twice
      end

      it 'sends column_exists? to empty_cage twice' do
        corrected_game.play
        expect(empty_cage).to have_received(:column_exists?).once
      end

      it 'sends filled_in_column? to empty_cage twice' do
        corrected_game.play
        expect(empty_cage).to have_received(:filled_in_column?).once
      end

      it 'sends full? to empty_cage twice' do
        corrected_game.play
        expect(empty_cage).to have_received(:full?).once
      end

      it 'sends has_four_in_a_line_with_top_of_latest_column? to empty_cage once' do
        corrected_game.play
        expect(empty_cage).to have_received(:has_four_in_a_line_with_top_of_latest_column?).once
      end

      it 'sends add_piece_to_column to empty_cage once' do
        corrected_game.play
        expect(empty_cage).to have_received(:add_piece_to_column).at_least(:once)
      end
    end

    context "when a player's move doesn't end the game" do
      subject(:ongoing_game) { described_class.new(empty_cage, [confused_player, other_player]) }

      let(:empty_cage) { instance_double(Cage) }
      let(:confused_player) { instance_double(Player, number: 1, symbol: '#') }
      let(:other_player) { instance_double(Player, number: 2, symbol: '@') }

      before do
        allow(empty_cage).to receive_messages(column_exists?: true, filled_in_column?: false,
                                              has_four_in_a_line_with_top_of_latest_column?: false)
        allow(empty_cage).to receive(:add_piece_to_column)
        allow(empty_cage).to receive(:full?).and_return(false, true)
        allow(confused_player).to receive(:select_column).and_return('0')
        allow(other_player).to receive(:select_column).and_return('1')
      end

      it 'swaps the current player' do
        expect { ongoing_game.play }.to change {
          ongoing_game.instance_variable_get(:@current_player)
        }.to eq(other_player)
      end
    end

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
