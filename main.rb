# frozen_string_literal: true

require_relative 'mastermind'

puts 'Mastermind - Game Rules:'
puts ''
puts 'In this game against the computer, you can either be the code maker or breaker.'
puts 'The code maker picks a secret code composed of 4 numbers from 1 to 6, ' \
'eg: 4521.'
puts 'To win, the code breaker must guess the code in 12 turns or less.'
puts ''
puts 'After each turn, the breaker will be presented with clues to help them ' \
     'find the code:'
print "\e[91m\u25CF\e[0m "
puts 'A red peg means you one correct number in its correct location'
print "\e[37m\u25CF\e[0m "
puts 'A white peg means you have one correct number, in an incorrect location'
puts ''
puts 'Time to play! Would you like to be the breaker or the maker?' \
' (Input B to be the breaker and M to be the maker):'
choice = gets.chomp
until %w[b m M B].include? choice
  puts "Please pick either 'B' or 'M':"
  choice = gets.chomp
end
puts ''

case choice.upcase
when 'B'
  breaker = HumanCodeBreaker.new
  maker = ComputerCodeMaker.new
when 'M'
  breaker = ComputerCodeBreaker.new
  maker = HumanCodeMaker.new
end

game = Game.new(maker, breaker)
game.play(choice.upcase)
