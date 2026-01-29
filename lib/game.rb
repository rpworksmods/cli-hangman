# Class for managing the game state
class Game
  attr_accessor :strikes, :word, :answer

  def initialize
    @strikes = 6
    @dictionary = []
    read_dictionary
    @word = select_word
    @answer = Array.new(@word.length, '_')
    initialize_game
  end

  def initialize_game
    puts "You have #{@strikes} strikes to guess the word."
    puts "The word has #{@word.length} letters: #{@answer.join(' ')}"
    puts 'Start guessing letters!'
    puts '-----------------------------------'
    puts @answer.join(' ')
    puts '-----------------------------------'
    puts 'Please enter your guess:'
  end

  def read_dictionary
    dict = File.open('./lib/dictionary.txt', 'r')

    dict.readlines.each_with_index do |line, _|
      line = line.strip
      @dictionary << line if line.length >= 5 && line.length <= 12
    end
  end

  def select_word
    @dictionary.sample
  end

  def lose_life
    @strikes -= 1
  end
end
