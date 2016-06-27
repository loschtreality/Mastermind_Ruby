class Code
  attr_reader :pegs, :guess

  PEGS = {
    R: "Red",
    B: "Blue",
    O: "Orange",
    G: "Green",
    Y: "Yellow",
    P: "Purple"
  }

  def initialize(array)
    @pegs = array
  end


  def Code.parse(string)
    sym_arr = string.upcase.split('').map(&:to_sym)
    pegs_arr = []
    sym_arr.each do |sym|
      if PEGS.has_key?(sym)
      pegs_arr << PEGS[sym]
      else
      raise "Invalid colors"
      end
    end
    Code.new(pegs_arr)
  end

  def Code.random
    colors = PEGS.keys
    random = []
    4.times do
      random << colors.sample
    end
    Code.parse(random.join(''))
  end


  def [](index)
    @pegs[index]
  end

  def exact_matches(code)
    count = 0
    self.pegs.each_with_index do |el,i|
      count += 1 if el == code[i]
    end
    count
  end


  def near_matches(code)
    stack_self = []
    stack_other = []
    count = 0

    @pegs.each_with_index do |el,i|
      stack_self << el
      stack_other << code.pegs[i]
    end

    stack_self.uniq!
    stack_other.uniq!

    stack_self.each do |el|
      count += 1 if stack_other.include?(el)
    end

    return 0 if count - self.exact_matches(code) < 0
    count - self.exact_matches(code)

  end


  def == (obj)
    return false unless obj.is_a?(Code)
    @pegs == obj.pegs
  end

end


class Game
  attr_reader :secret_code

  TOTAL_TURNS = 10

  def initialize(game = Code.random)
    @secret_code = game
  end

  def get_guess
    ARGV.clear
    puts "What's your guess?"
    u_input = gets.chomp
    @guess = Code.parse(u_input)
  end

  def display_matches(guess)
   e_m = @secret_code.exact_matches(guess)
   n_m = @secret_code.near_matches(guess)
   puts "You have #{e_m} exact matches"
   puts "And #{n_m} near matches"
  end

  def play
    game_won = false
    guesses = TOTAL_TURNS
    puts "\n\nWelcome to Mastermind! To play, type your color codes. The colors in play are red, blue, orange, green, yellow, purple (rbogyp). Type a sequence of four letters representing colors Ex: yrbo. You have ten guesses to guess the secret sequence. Remember, colors have the chance of repeating. Order and colors must be in the correct sequence to win.\n\n"
    TOTAL_TURNS.times do
      u_input = get_guess
      if @secret_code == u_input
        game_won = true
      else
        guesses -= 1
        display_matches(u_input)
        puts "Try again! #{guesses} guesses remaining\n-----------mastermind-----------\n"
      end
      break if game_won
    end
    if game_won
      puts "You win!"
    else
      puts "Defeat. Unbroken code: #{@secret_code.pegs}"
    end
  end

end


if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
