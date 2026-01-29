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

game = Game.new
answer = Array.new(game.word.length, '_')

puts "Welcome to the Word Guessing Game!"
puts "You have #{game.strikes} strikes to guess the word."
puts "The word has #{game.word.length} letters: #{answer.join(' ')}"
puts "Start guessing letters!"
puts "-----------------------------------"
puts answer.join(' ')
puts "-----------------------------------"
puts "Please enter your guess:"

loop do
  guess = gets&.chomp&.downcase
  puts '-----------------------------------'
  puts 'Processing your guess...'
  sleep(1.5)
  next unless guess =~ /^[a-z]$/  # Ensure single letter input
  if game.word.include?(guess)
    puts "Correct!"
    # Update the answer array with the correct letter
    game.word.chars.each_with_index do |char, index|
      if char == guess
        answer[index] = guess
      end
    end

    puts '-----------------------------------'
    puts "Current word state:"
    puts answer.join(' ')
    puts "-----------------------------------"

    if answer.join == game.word
      puts "Congratulations! You've guessed the word: #{game.word}"
      break
    end
  else
    game.lose_life
    puts '-----------------------------------'
    puts "Incorrect! You have #{game.strikes} strikes left."
    puts '-----------------------------------'
    puts "Current word state:"
    puts answer.join(' ')
    puts "-----------------------------------"
    puts "Please enter your next guess:"
  end

  if game.strikes <= 0
    puts '-----------------------------------'
    puts "Game Over! The word was: #{game.word}"
    break
  end
end