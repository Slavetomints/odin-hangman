# frozen_string_literal: true

require 'yaml'

# represents the hangman game
class Hangman
  def initialize
    puts 'Welcome to Hangman!'
    puts 'Would you like to load a game? (yes/no)'
    ans = gets.chomp.downcase
    if ans == 'yes'
      puts 'What is the game id?'
      id = gets.chomp
      filename = "saves/game_#{id}.yaml"
      if File.exist?(filename)
        game_data = YAML.safe_load(File.read(filename))
        @id = game_data['id']
        @word = game_data['word']
        @current_progress = game_data['current_progress']
        @amount_of_mistakes = game_data['amount_of_mistakes']
        puts "Game #{id} loaded successfully."
      else
        puts "Error: Game file #{filename} not found."
      end
    else
      @id = rand(0..1000)
      puts "The game id is #{@id}"
      @dictionary = File.read('dictionary.txt').split("\n")
      puts 'How many mistakes do you get?'
      @amount_of_mistakes = gets.chomp.to_i

      loop do
        @word = @dictionary.sample
        if @word.length > 2 && @word.length < 7
          @current_progress = Array.new(@word.length, '_')
          break
        end
      end
    end
  end

  def make_guess
    puts "You have #{@amount_of_mistakes} mistakes left"
    puts 'Guess a letter in the word!'
    puts @current_progress.join(' ')
    @guess = gets.chomp.downcase
  end

  def check_guess(_guess)
    number_wrong = 0
    @word.split('').each_with_index do |letter, index|
      if @guess == letter
        @current_progress[index] = @guess
      else
        number_wrong += 1
      end
    end
    @amount_of_mistakes -= 1 if number_wrong == @word.length
    if @amount_of_mistakes.zero?
      puts 'You loose!'
      exit
    end
    return unless @current_progress.join('') == @word

    puts "You win! The word was #{@word}."
    exit
  end

  def save_game
    puts 'Would you like to save the game? (yes/no)'
    ans = gets.chomp.downcase

    return unless %w[yes y].include?(ans)

    Dir.mkdir('saves') unless Dir.exist?('saves')
    filename = "saves/game_#{@id}.yaml"
    game_data = {
      'id' => @id,
      'word' => @word,
      'current_progress' => @current_progress,
      'amount_of_mistakes' => @amount_of_mistakes
    }
    File.open(filename, 'w') do |file|
      file.puts YAML.dump(game_data)
    end
    puts "Game saved as #{filename}."
  end
end

game = Hangman.new

loop do
  game.check_guess(game.make_guess)
  game.save_game
end
