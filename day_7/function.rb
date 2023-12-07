INPUT_PATH = File.join(File.dirname(__FILE__), 'input.txt').freeze
INPUT = File.readlines(INPUT_PATH).map(&:rstrip)

class Game

    attr_accessor :hand_parser

    def initialize(hands)
        @hands = hands.map{|hand| hand_parser(hand)}
    end

    def hand_parser(hand)
        cards, bid = hand.split(' ')
        Hand.new(cards, bid)
    end

    def sort_hands
        new_hands = @hands.sort_by{|h| [h.type, h.rank_order]}
        new_hands.map.with_index{|h, i| (i + 1) * h.bid}.sum
    end
end

class Hand

    attr_accessor :type, :rank_order, :cards, :bid

    def initialize(cards, bid)
        @cards = cards.split('')
        @bid = bid.to_i
        @type = nil
        @rank_order = ranks
        get_jokers #for part 2
        five_kind
    end

    def get_jokers
        new_tally = @cards.tally.sort_by{|k, v| v}
        return if !new_tally.map(&:first).include?('J')
        j, non_j = new_tally.partition{|pair| pair[0] == 'J'}
        if non_j.empty?
            @cards = %w(J J J J J)
        else
            non_j[-1][-1] += j[-1][-1]
            @cards = non_j.map{|c| c[0] * c[-1]}.join.split('')
        end


    end

    def five_kind
        @cards.uniq.size == 1 ? @type = 7 : four_kind
    end

    private

    def four_kind
        @cards.tally.values.sort == [1,4] ? @type = 6 : full_house
    end

    def full_house
        @cards.tally.values.sort == [2,3] ? @type = 5 : three_kind
    end

    def three_kind
        @cards.tally.values.sort == [1,1,3] ? @type = 4 : two_pair
    end

    def two_pair
        @cards.tally.values.sort == [1,2,2] ? @type = 3 : one_pair
    end

    def one_pair
        @cards.tally.values.sort == [1,1,1,2] ? @type = 2 : high_card
    end

    def high_card
        @type = 1
    end

    def ranks
        #part 1: card_key = %w(2 3 4 5 6 7 8 9 T J Q K A).map(&:to_s)
        card_key = %w(J 2 3 4 5 6 7 8 9 T J Q K A).map(&:to_s)
        @cards.map{|c| card_key.index(c)}
    end

end

game = Game.new(INPUT)
p game.sort_hands