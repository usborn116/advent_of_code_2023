INPUT_PATH = File.join(File.dirname(__FILE__), 'input.txt').freeze
INPUT = File.readlines(INPUT_PATH).map(&:rstrip)

class Sensor

    attr_accessor :values, :parent

    def initialize(values, parent = nil)
        @values = values.split(' ').map(&:to_i)
        @parent = parent
        #p "values: #{@values}; parent: #{@parent}"
        all_zeroes? ? zero_sensor : find_differences
    end

    def all_zeroes?
        @values.all?(&:zero?)
    end

    def zero_sensor
        # PART 1: @parent.add_last(0)
        @parent.add_first(0)
    end

    def find_differences
        diff = @values.map.with_index{|v, i| i == 0 ? nil : v - @values[i-1] }.compact
        sensor = Sensor.new(diff.join(' '), self)
    end

    def last
        @values.last
    end

    def first
        @values.first
    end

    def add_last(n)
        @values << (@values.last + n)
        #p "add last: #{@values}"
        @parent.add_last(@values[-1]) unless @parent.nil?
    end

    def add_first(n)
        @values.unshift(@values.first - n)
        #p "add first: #{@values}"
        @parent.add_first(@values[0]) unless @parent.nil?
    end
end

def parser(input)
    lines = input.map{|line| Sensor.new(line)}
    #lines.each{|l| p l.values}
    #PART 1: lines.sum(&:last)
    lines.sum(&:first)
end

p parser(INPUT)