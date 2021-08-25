# frozen_string_literal: true

# CodeMaker class
class CodeMaker
  attr_reader :secret_code

  def initialize(secret_code)
    @secret_code = secret_code
  end

  def feedback(guess)
    exact_match_count = 0
    partial_match_count = 0
    secret_code_chars = @secret_code.split('')
    guess.split('').each_with_index do |char, index|
      if char == secret_code_chars[index]
        exact_match_count += 1
        secret_code_chars[index] = nil
      elsif secret_code_chars.include?(char)
        partial_match_count += 1
      end
    end
    [exact_match_count, partial_match_count]
  end
end

# ComputerCodeMaker class, subclass of CodeMaker
class ComputerCodeMaker < CodeMaker
  def initialize
    super(('1111'..'6666').to_a
                          .reject! { |code| code.include? '0' }
                          .sample)
  end
end

# CodeBreaker class
class CodeBreaker
  def guess; end
end

# HumanCodeBreaker class, subclass of CodeBreaker
class HumanCodeBreaker
  def guess
    puts 'Please enter your code guess:'
    guess = gets.chomp
    until ('1111'..'6666').to_a
                          .reject! { |code| code.include? '0' }
                          .include? guess
      puts 'Please enter a valid guess:'
      guess = gets.chomp
    end
    guess
  end
end

# Game class
class Game
  def initialize(maker, breaker)
    @maker = maker
    @breaker = breaker
  end

  def self.print_clues(clues)
    print 'Clues: '
    clues[0].times { print "\e[91m\u25CF\e[0m " }
    clues[1].times { print "\e[37m\u25CB\e[0m " }
    puts ''
  end

  def play
    12.times do
      guess = @breaker.guess
      if guess == @maker.secret_code
        puts "Congratulations, you've found the secret code!"
        return
      else
        clues = @maker.feedback(guess)
        Game.print_clues(clues)
      end
    end
    puts "You couldn't find the secret code..."
    puts "It was #{@maker.secret_code}!"
  end
end
