INPUT_PATH = File.join(File.dirname(__FILE__), 'input.txt').freeze
INPUT = File.readlines(INPUT_PATH).map(&:rstrip)

class Card

    attr_accessor :score, :id, :cards_won

    def initialize(id, card)
        @id = id.scan(/\d+/).first.to_i
        winning, have = card.split("|")
        @winning = winning.split(' ').map(&:strip)
        @have = have.split(' ').map(&:strip)
        next_cards
    end

    private

    def matches
        @score = (@winning & @have).empty? ? 0 : 2 ** ((@winning & @have).size - 1)
    end

    def next_cards
        wins = @winning & @have
        @cards_won = []
        1.upto(wins.size){|i| @cards_won << @id + i}
        #p @cards_won
    end

end

def scorefinder
    copies = []
    total = 0
    cards = INPUT.map do |line|
        line = line.split(':')
        Card.new(line[0], line[1].strip)
    end

    cards.each do |c|
        c.cards_won.each do |cw|
            copies << cw
        end
    end

    until copies.empty?
        c = cards.find{|card| card.id == copies.first}
        p copies.first
        #p c
        copies.shift
        c.cards_won.each {|cw| copies << cw}
        total += 1
    end

    total + cards.size
end

p scorefinder



