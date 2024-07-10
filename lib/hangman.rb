#represents the hangman game
class Hangman

  def initialize
    puts 'Welcome to Hangman!'
    @dictionary = File.read('dictionary.txt').split("\n")
    puts 'How many mistakes do you get?'
    @amount_of_mistakes = gets.chomp.to_i
  end

  def new_word
    @word = @dictionary.sample
    puts @word
    if @word.length > 2 && @word.length < 7
      @current_progress = Array.new(@word.length, "_")
      return @word
    else new_word()
    end
  end
  
  def make_guess
    puts "You have #{@amount_of_mistakes} mistakes left"
    puts 'Guess a letter in the word!'
    puts @current_progress.join(" ")
    @guess = gets.chomp.downcase
  end

  def check_guess(guess)
    number_wrong = 0
    @word.split('').each_with_index do |letter, index|
      if @guess == letter
        @current_progress[index] = @guess
      else 
        number_wrong += 1
      end
    end
    if number_wrong == @word.length
      @amount_of_mistakes -= 1
      if @amount_of_mistakes == 0
        puts "You loose!"
        exit
      end
    end
    if @current_progress.join("") == @word
      puts "You win! The word was #{@word}."
      exit
    end
  end

end

game = Hangman.new
game.new_word

loop do
  game.check_guess(game.make_guess)
end