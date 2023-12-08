INPUT_PATH = File.join(File.dirname(__FILE__), 'input.txt').freeze
INPUT = File.readlines(INPUT_PATH).map(&:rstrip).filter{|l| !l.empty?}

class Directions

    attr_accessor :steps

    def initialize(steps)
        @steps = steps.split('')
    end

end

class Point

    attr_accessor :id, :left, :right

    def initialize(input)
        @id, branches = input.split('=')
        @id = @id.strip
        @left, @right = branches.split(",").map{|d| d.scan(/[0-9A-Z]/)}
        @left = @left.join('')
        @right = @right.join('')
    end

    def next_dir(dir)
        return dir == 'L' ? @left : @right
    end
end

dir = Directions.new(INPUT[0])
points = INPUT[1..-1].map{|g| Point.new(g)}

def get_answer(dir, points)
    ans = 0
    steps = dir.steps.cycle
    # part 1 start = points.find{|p| p.id == 'AAA'}
    currs = points.filter{|p| p.id[2] == 'A'}
    steps_arr = []
    currs.each do |curr|
        res = 0
        until curr.id.end_with?('Z')
            step = steps.next
            curr = points.find{|p| p.id == curr.next_dir(step)}
            res += 1
        end
        steps_arr << res
    end

=begin **PART 1**
    until curr.id == 'ZZZ'
        step = steps.next
        curr = points.find{|p| p.id == curr.next_dir(step)}
        ans += 1
    end
=end

    #part 2 ans
    ans = steps_arr[1..-1].reduce(steps_arr[0]){|acc, val| acc.lcm(val)}

    ans
end

p get_answer(dir, points)

