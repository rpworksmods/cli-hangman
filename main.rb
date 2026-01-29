require './lib/game'

Dictionary = []

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
guessed_letters = []

puts "Welcome to the Word Guessing Game!"
puts "You have #{game.strikes} strikes to guess the word."
puts "The word has #{game.word.length} letters: #{answer.join(' ')}"
puts "Start guessing letters!"
puts "-----------------------------------"
puts answer.join(' ')
puts "-----------------------------------"
puts "Please enter your guess:"

def restart_game
  game = Game.new
  answer = Array.new(game.word.length, '_')
  guessed_letters = []
  puts "-----------------------------------"
  puts "New game started!"
  puts "The word has #{game.word.length} letters: #{answer.join(' ')}"
  puts "Start guessing letters!"
  puts "-----------------------------------"
end

loop do
  guess = gets&.chomp&.downcase
  puts '-----------------------------------'
  puts 'Processing your guess...'
  sleep(1.5)

  if guess == game.word&.chomp&.downcase
    puts "Congratulations! You've guessed the word: #{game.word}"
    puts "Want to play again? (y/n)"
    play_again = gets.chomp.downcase
    if play_again == 'y'
      restart_game
    else
      break
    end
  end

  unless guess =~ /^[a-z]$/
    puts "Please enter a valid letter:"
    next
  end

  if guess.nil? || guess.empty?
    puts "Please enter a valid letter:"
    next
  end

  if guessed_letters.include?(guess)
    puts "You've already guessed the letter '#{guess}'. Try a different letter"
    next
  end

  guessed_letters << guess

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
      puts "Want to play again? (y/n)"
      play_again = gets.chomp.downcase
      if play_again == 'y'
        restart_game
      else
        break
      end
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
    puts "Want to play again? (y/n)"
    play_again = gets.chomp.downcase
    if play_again == 'y'
      restart_game
    else
      break
    end
  end
end