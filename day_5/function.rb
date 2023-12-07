# --- Part 1 --- #

class ConversionRange
    
	def initialize(destination, source, range)
		@destination = destination
		@source = source
		@range = range
	end

	def cr_cover?(source)
		(@source...(@source + @range)).cover?(source)
	end

	def convert(source)
		@destination + source - @source
	end

end

class Map

	def initialize(conversion_ranges)
		@conversion_ranges = conversion_ranges
	end

	def convert(source)
		@conversion_ranges.find{ |cr| cr.cr_cover?(source) }&.convert(source) || source
	end

end

def parse_map(lines)
	conversion_ranges = lines.each_with_object([]) do |line, obj|

		destination, source, range = line.scan(/\d+/).map(&:to_i)
		obj << ConversionRange.new(destination, source, range)

	end

	Map.new(conversion_ranges)
end

def parse(input)
	seeds = input.lines[0].scan(/\d+/).map(&:to_i)
	maps = []

	input.lines[1..-1].each do |line|
		line.chomp.end_with?("map:") ? maps << [] : line.start_with?(/\d/) ? maps.last << line.chomp : nil
	end

	maps.map!{ |lines| parse_map(lines) }

	return seeds, maps
end

def locations(seeds, maps)
	seeds.map{ |s| maps.reduce(s){|acc, val| val.convert(acc) } }
end

# ---- Part 2 ---- #

class MapEntry

	def initialize(destination, source, length)
			@destination = destination
			@source = source
			@length = length
	end

	def affects?(other)
			(range.cover?(other) || other.cover?(range) || overlaps?(other))
	end

	def destination_ranges(other)
		if range.cover?(other)
			[(other.min + change)...(other.max + 1 + change)]
		elsif other.cover?(range)
			[ other.min...(range.min), (range.min + change)...(range.max + 1 + change), (range.max + 1)...(other.max + 1)]
		elsif overlaps?(other)
			overhangs_right?(other) ? [other.min...(range.min), (range.min + change)...(other.max + 1 + change)] :
			[(other.min + change)...(range.max + 1 + change), (range.max + 1)...(other.max + 1)]
		else
			fail	
		end

	end

	private

	def range
		@range ||= (@source...(@source + @length))
	end

	def change
		@destination - @source
	end

	def overlaps?(other)
		range.cover?(other.min) || other.cover?(range.min)
	end

	def overhangs_right?(other)
		range.min >= other.min && range.max > other.max
	end

	def overhangs_left?(other)
		range.min <= other.min && range.max < other.max
	end
end

class Map_2

	def initialize(entries)
			@entries = entries
	end

	def destination_ranges(source_ranges)
		source_ranges.flat_map do |sr|
			@entries.reduce([sr]) do |acc, entry|
				acc.flat_map { |map_entry| sr.cover?(map_entry) && entry.affects?(map_entry) ? entry.destination_ranges(map_entry) : map_entry }
			end
		end.uniq.filter { |r| !r.size.zero? }
	end

end

class SeedRanges

	def self.combine_ranges(ranges)
		intervals = ranges.map{ |r| [r.min, r.max] }

		intervals.sort.each_with_object([]) do |(min, max), obj|
			obj.empty? || min > obj.last[1] + 1 ? obj << [min, max] : max > obj.last[1] + 1 ? obj.last[1] = max : nil
		end.map{ |(min, max)| min...(max + 1) }
	end

	attr_reader :ranges

	def initialize(ranges)
		@ranges = ranges
	end

	def location_ranges(maps)
		maps.reduce(ranges.dup){ |acc, map| SeedRanges.combine_ranges(map.destination_ranges(acc)) }
	end

	def minimum_location(maps)
		location_ranges(maps).collect(&:min).min
	end

end

# -------- parsing --------

def parse_2(input)
	seed_ranges = parse_seed_ranges(input.lines.first)
	maps = []

	input.lines[1..-1].each do |line|
		line.chomp.end_with?("map:") ? maps << [] : line.start_with?(/\d/) ? maps.last << line.chomp : nil
	end

	maps.map! { |lines| parse_map_2(lines) }

	return seed_ranges, maps

end

def parse_seed_ranges(line)

	ranges = line.scan(/\d+/).map(&:to_i).each_slice(2).map{ |(start, length)| start...(start + length) }
	SeedRanges.new(ranges)

end

def parse_map_2(lines)

	entries = lines.each_with_object([]) do |line, obj|
		destination, source, length = line.scan(/\d+/).map(&:to_i)
		obj << MapEntry.new(destination, source, length)
	end

	Map_2.new(entries)

end

# -------- main --------

seeds, maps = parse(File.read("./input.txt"))
puts "Part 1: #{locations(seeds, maps).min}"

seed_ranges, maps_2 = parse_2(File.read("./input.txt"))
puts "Part 2: #{seed_ranges.minimum_location(maps_2).tap { |answer| puts(answer) }}"