require './lib/game'

Dictionary = []
strikes = 6

# Welcome message

# Pick a random word from the dictionary between 5 and 12 characters long
# 
# Start the game loop
#  - Display the current state of the word
#  - Get a letter guess from the player
#  - Update the game state based on the guess
#  - Check for win/loss conditions
# End the game loop
# Display win/loss message
# 

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

read_dictionary
word = select_word
answer = Array.new(word.length, '_')

loop do
  guess = gets&.chomp
  puts word.include?(guess)
  if word.include?(guess)
    puts "Correct!"
    # Update the answer array with the correct letter
    word.chars.each_with_index do |char, index|
      if char == guess
        answer[index] = guess
      end
    end
    puts answer.join(' ')
    if answer.join == word
      puts "Congratulations! You've guessed the word: #{word}"
      break
    end
  else
    strikes -= 1
    puts "Incorrect! You have #{strikes} strikes left."
  end

  if strikes <= 0
    puts "Game Over! The word was: #{word}"
    break
  end
end