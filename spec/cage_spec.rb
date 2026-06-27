# frozen_string_literal: true

require 'cage'

describe Cage do
  describe '#full?' do
    context 'when cage contains no pieces' do
      subject(:empty_cage) { described_class.new }

      it 'is not full' do
        expect(empty_cage).not_to be_full
      end
    end

    context 'when cage contains only some pieces' do
      subject(:partially_filled_cage) { described_class.new }

      before do
        3.times do |column_index|
          3.times do
            partially_filled_cage.add_piece_to_column('@', column_index)
          end
        end
      end

      it 'is not full' do
        expect(partially_filled_cage).not_to be_full
      end
    end

    context 'when cage has the maximum amount of pieces' do
      subject(:totally_filled_cage) { described_class.new }

      before do
        7.times do |column_index|
          6.times do
            totally_filled_cage.add_piece_to_column('@', column_index)
          end
        end
      end

      it 'is not full' do
        expect(totally_filled_cage).to be_full
      end
    end
  end

  describe '#column_exists?' do
    context 'when cage column does not exist' do
      subject(:empty_cage) { described_class.new }

      it 'does not have any such column' do
        expect(empty_cage.column_exists?(12)).to be false
      end
    end

    context 'when cage column does exist' do
      subject(:empty_cage) { described_class.new }

      it 'does have such a column' do
        expect(empty_cage.column_exists?(3)).to be true
      end
    end
  end

  describe '#filled_in_column?' do
    context 'when cage column contains no pieces' do
      subject(:empty_cage) { described_class.new }

      it 'is not full' do
        expect(empty_cage).not_to be_filled_in_column(0)
      end
    end

    context 'when cage column contains only some pieces' do
      subject(:partially_filled_cage) { described_class.new }

      before do
        3.times do
          partially_filled_cage.add_piece_to_column('@', 0)
        end
      end

      it 'is not full' do
        expect(partially_filled_cage).not_to be_filled_in_column(0)
      end
    end

    context 'when cage column contains the maximum allowed pieces' do
      subject(:totally_filled_cage) { described_class.new }

      before do
        6.times do
          totally_filled_cage.add_piece_to_column('@', 0)
        end
      end

      it 'is not full' do
        expect(totally_filled_cage).to be_filled_in_column(0)
      end
    end
  end

  describe '#has_four_in_a_line_with_top_of_latest_column?' do
    context 'when cage contains no pieces' do
      subject(:empty_cage) { described_class.new }

      it 'does not have four in a line' do
        expect(empty_cage).not_to have_four_in_a_line_with_top_of_latest_column
      end
    end

    context 'when no cage column or row contains more than three pieces' do
      subject(:partially_filled_cage) { described_class.new }

      before do
        3.times do |column_index|
          3.times do
            partially_filled_cage.add_piece_to_column('@', column_index)
          end
        end
      end

      it 'does not have four in a line' do
        expect(partially_filled_cage).not_to have_four_in_a_line_with_top_of_latest_column
      end
    end

    context 'when a column contains four of the same symbol in sequence' do
      subject(:column_line_cage) { described_class.new }

      before do
        4.times do
          column_line_cage.add_piece_to_column('@', 0)
        end
      end

      it 'has four in a line' do
        expect(column_line_cage).to have_four_in_a_line_with_top_of_latest_column
      end
    end

    context 'when a row contains four of the same symbol in sequence' do
      subject(:row_line_cage) { described_class.new }

      before do
        4.times do |column_index|
          row_line_cage.add_piece_to_column('@', column_index)
        end
      end

      it 'has four in a line' do
        expect(row_line_cage).to have_four_in_a_line_with_top_of_latest_column
      end
    end

    context 'when an upward diagonal contains four of the same symbol in sequence' do
      subject(:row_line_cage) { described_class.new }

      before do
        4.times do |column_index|
          column_index.times do
            row_line_cage.add_piece_to_column('#', column_index)
          end
          row_line_cage.add_piece_to_column('@', column_index)
        end
      end

      it 'has four in a line' do
        expect(row_line_cage).to have_four_in_a_line_with_top_of_latest_column
      end
    end

    context 'when a downward diagonal contains four of the same symbol in sequence' do
      subject(:row_line_cage) { described_class.new }

      before do
        4.times do |column_index|
          (3 - column_index).times do
            row_line_cage.add_piece_to_column('#', column_index)
          end
          row_line_cage.add_piece_to_column('@', column_index)
        end
      end

      it 'has four in a line' do
        expect(row_line_cage).to have_four_in_a_line_with_top_of_latest_column
      end
    end
  end
end
