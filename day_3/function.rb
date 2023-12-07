#!/usr/bin/env ruby
# frozen_string_literal: true

INPUT_PATH = File.join(File.dirname(__FILE__), 'input.txt').freeze
INPUT = File.readlines(INPUT_PATH).map(&:rstrip)

def part1
  INPUT.map.with_index do |row, index|
    part_numbers = row.scan(/\d+/)
    previous_row = index < 1 ? '' : INPUT[index - 1]
    next_row = INPUT[index + 1].nil? ? '' : INPUT[index + 1]

		curr_index = 0

    part_numbers.sum do |pn|
      part_index = row.index(/(?<!\d)#{pn}(?!\d)/, curr_index)
      part_buffer_start = part_index.zero? ? 0 : part_index - 1
      part_range = part_buffer_start..(part_index + pn.size)

      prev_adj = previous_row[part_range] || ''
      curr_adj = row[part_range]
      next_adj = next_row[part_range] || ''

			curr_index = part_index

      !(prev_adj + curr_adj + next_adj).scan(/[^.\d]/).empty? ? pn.to_i : 0
    end
  end
end

p part1.sum

def find_numbers_in_row(gears, row, gear_index)
	
	curr_index = 0

  row.scan(/\d+/).each do |n|
		start_offset = row.index(/(?<!\d)#{n}(?!\d)/, curr_index)
		end_offset = start_offset + n.size

    gears << n.to_i if start_offset <= gear_index + 1 && end_offset >= gear_index

		curr_index = start_offset
  end
end

def part2
  INPUT.each_with_index.sum do |row, index|
		gear_indexes = (0 ... row.length).find_all { |i| row[i,1] == '*' }
    previous_row = index.zero? ? '' : INPUT[index - 1]
    next_row = INPUT[index + 1].nil? ? '' : INPUT[index + 1]

    gear_indexes.sum do |gi|
      gears = []

      find_numbers_in_row(gears, previous_row, gi)
      find_numbers_in_row(gears, row, gi)
      find_numbers_in_row(gears, next_row, gi)

      gears.length == 2 ? gears.reduce(&:*) : 0
    end
  end
end

puts "Part 2 Answer: #{part2}"
  