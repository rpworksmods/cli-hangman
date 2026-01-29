class Game
  Dictionary = []
  attr_accessor :strikes, :word, :answer

  def initialize
    @strikes = 6
    read_dictionary
    @word = select_word
    @answer = Array.new(@word.length, '_')

    puts "You have #{@strikes} strikes to guess the word."
    puts "The word has #{@word.length} letters: #{@answer.join(' ')}"
    puts "Start guessing letters!"
    puts "-----------------------------------"
    puts @answer.join(' ')
    puts "-----------------------------------"
    puts "Please enter your guess:"
  end

  def read_dictionary
    dict = File.open('./lib/dictionary.txt', 'r')

    dict.readlines.each_with_index do |line, index|
      line = line.strip
      if line.length >= 5 && line.length <= 12
        Dictionary << line
      end
    end
  end

  def select_word
    Dictionary.sample
  end

  def lose_life
    @strikes -= 1
  end
end