INPUT_PATH = File.join(File.dirname(__FILE__), 'input.txt').freeze
INPUT = File.readlines(INPUT_PATH).map(&:rstrip)

class Race

    attr_accessor :records
    
    def initialize(time, distance)
        @time = time.to_i
        @distance = distance.to_i
        @options = []
        get_distances
    end

    def records
        @options.select{|v| v > @distance}.size
    end

    private

    def get_distances
        0.upto(@time).each {|t| @options << (@time - t) * t}
    end
    
end

def parser(line)
    #For Part 1: line.split(' ')[1..-1]
    line.split(':')[1].gsub!(' ', '')
end

lines = []
INPUT.each {|l| lines << parser(l)}

# -- For Part 2 -- #
race = Race.new(lines.first, lines.last)
puts race.records

# -- For Part 1 -- #

#races = lines.transpose.map{|time, distance| Race.new(time, distance) }
#p races.map(&:records).reduce(&:*)