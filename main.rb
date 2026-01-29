require './lib/game'
require 'json'

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

game = nil
answer = []
guessed_letters = []

puts 'Welcome to Hangman!'
puts '-----------------------------------'
puts 'At any point during the game, you can type "save" to save your current progress.'
puts "Type 'new' to start a new game or 'load' to load the saved game:"

def open_save_file
  file = File.open('./lib/saves.json', 'r')
  data = JSON.parse(file.read)
  file.close
  data
end

def load_game
  data = open_save_file
  game = Game.new
  game.word = data['word']
  game.strikes = data['strikes']
  answer = data['answer']
  guessed_letters = data['guessed_letters']

  puts "Game loaded! You have #{game.strikes} strikes left."
  puts "Current word state: #{answer.join(' ')}"
  puts "Guessed letters so far: #{guessed_letters.join(', ')}"

  [game, answer, guessed_letters]
end

input = gets&.chomp&.downcase

if input == 'load'
  game, answer, guessed_letters = load_game
elsif input == 'new'
  # Start a new game
  puts 'Starting a new game...'
  game = Game.new
  answer = Array.new(game.word.length, '_')
  guessed_letters = []
else
  puts 'Invalid input. Starting a new game by default.'
end

def restart_game
  game = Game.new
  answer = Array.new(game.word.length, '_')
  puts '-----------------------------------'
  puts 'New game started!'
  puts "The word has #{game.word.length} letters: #{answer.join(' ')}"
  puts 'Start guessing letters!'
  puts '-----------------------------------'
  [game, answer]
end

def show_guessed_letters(guessed_letters)
  return if guessed_letters.empty?

  puts "Guessed letters so far: #{guessed_letters.join(', ')}"
end

def save_game(game, answer, guessed_letters)
  file = File.open('./lib/saves.json', 'w')
  file.write({
    word: game.word,
    answer: answer,
    guessed_letters: guessed_letters,
    strikes: game.strikes
  }.to_json)
  file.close

  puts 'Game saved! You can load it next time you start the game.'
  puts 'Please enter your next guess:'
end

def process_correct_guess(game, guess, answer, guessed_letters)
  puts 'Correct!'
  game.word.chars.each_with_index { |char, idx| answer[idx] = guess if char == guess }
  show_guessed_letters(guessed_letters)
  display_word_state(answer)
end

def process_incorrect_guess(game, answer, guessed_letters)
  game.lose_life
  puts "Incorrect! You have #{game.strikes} strikes left."
  show_guessed_letters(guessed_letters)
  display_word_state(answer)
end

def display_word_state(answer)
  puts '-----------------------------------'
  puts "Current word state:\n#{answer.join(' ')}"
  puts '-----------------------------------'
end

def play_again?
  puts 'Want to play again? (y/n)'
  gets.chomp.downcase
end

def check_game_end(game, answer)
  if answer.join == game.word
    puts "Congratulations! You've guessed the word: #{game.word}"
    return play_again?
  elsif game.strikes <= 0
    puts "Game Over! The word was: #{game.word}"
    return play_again?
  end
  nil
end

loop do
  guess = gets&.chomp&.downcase
  puts '-----------------------------------'
  puts 'Processing your guess...'
  sleep(1.5)

  if guess == 'save'
    save_game(game, answer, guessed_letters)
    next
  end

  if guess == game.word&.chomp&.downcase
    answer = game.word.chars
    result = check_game_end(game, answer)
    break unless result == 'y'

    game, answer = restart_game
    guessed_letters.clear
    next
  end

  next if guess.nil? || guess.empty? || guess !~ /^[a-z]$/ || puts('Please enter a valid letter:')
  next if guessed_letters.include?(guess) && puts("Already guessed '#{guess}'")

  guessed_letters << guess
  if game.word.include?(guess)
    process_correct_guess(game, guess, answer, guessed_letters)
  else
    process_incorrect_guess(game, answer, guessed_letters)
  end

  result = check_game_end(game, answer)
  next unless result
  break unless result == 'y'

  game, answer = restart_game
  guessed_letters.clear
end
