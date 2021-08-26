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
    { exact: exact_match_count, partial: partial_match_count }
  end

  def self.valid_codes
    ('1111'..'6666').to_a
                    .reject! do |code|
                      code.split('').any? { |digit| %w[0 7 8 9].include? digit }
                    end
  end
end

# ComputerCodeMaker class, subclass of CodeMaker
class ComputerCodeMaker < CodeMaker
  def initialize
    super(CodeMaker.valid_codes.sample)
  end
end

# HumanCodeMaker class, subclass of CodeMaker
class HumanCodeMaker < CodeMaker
  def initialize
    puts 'Please input your secret code:'
    secret_code = gets.chomp
    until CodeMaker.valid_codes.include? secret_code
      puts 'Please choose a valid code: ( Made of 4 digits from 1 to 6 )'
      secret_code = gets.chomp
    end
    super(secret_code)
  end
end

# HumanCodeBreaker class
class HumanCodeBreaker
  def guess
    puts 'Please enter your code guess:'
    guess = gets.chomp
    until CodeMaker.valid_codes.include? guess
      puts 'Please enter a valid guess:'
      guess = gets.chomp
    end
    guess
  end
end

# ComputerCodeBreaker class
class ComputerCodeBreaker
  attr_accessor :current_possible_codes

  def initialize
    @current_possible_codes = CodeMaker.valid_codes
  end

  def guess(previous = nil)
    return '1122' unless previous

    @current_possible_codes.select! do |code|
      hypothetical_maker = CodeMaker.new(code)
      hypothetical_clues = hypothetical_maker.feedback(previous[:guess])
      hypothetical_clues == previous[:clues]
    end

    @current_possible_codes[0]
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
    clues[:exact].times { print "\e[91m\u25CF\e[0m " }
    clues[:partial].times { print "\e[37m\u25CF\e[0m " }
    puts ''
    puts ''
  end

  def play(human_role)
    case human_role
    when 'B'
      play_with_human_breaker
    when 'M'
      play_with_computer_breaker
    end
  end

  private

  def play_with_human_breaker
    puts 'The computer has picked its code, time to start guessing!'
    puts ''
    12.times do
      guess = @breaker.guess
      if guess == @maker.secret_code
        puts "Congratulations, you've found the secret code!"
        return nil
      else
        clues = @maker.feedback(guess)
        Game.print_clues(clues)
      end
    end
    puts "You couldn't find the secret code..."
    puts "It was #{@maker.secret_code}!"
  end

  def play_with_computer_breaker
    puts ''
    puts 'The computer is coming...'
    puts ''
    sleep(0.5)
    guesses_so_far = []
    12.times do |i|
      previous = if i.zero?
                   nil
                 else
                   { guess: guesses_so_far.last,
                     clues: @maker.feedback(guesses_so_far.last) }
                 end
      guess = @breaker.guess(previous)
      guesses_so_far.push(guess)
      puts "The computer guessed #{guess}:"
      clues = @maker.feedback(guess)
      Game.print_clues(clues)
      if guess == @maker.secret_code
        puts "Game over! Code broken successfully in #{i + 1} steps."
        return nil
      end
      sleep(1)
    end
    puts "The computer couldn't find your code, you win!"
  end
end
