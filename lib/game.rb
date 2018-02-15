class Game
  attr_accessor :guesses,
                :guess_count,
                :correct_number
  def initialize
    @correct_number = rand(0..100)
    @counter = 0
    @guesses = []
    @guess_count = @guesses.count
  end

  def guess
    @guess = ""
  end

  def run
    while @guess.to_i != random_number
      if @guess.to_i > random_number
        "Too high"
        @counter += 1
      else
        "Too low"
        @counter += 1
      end
      @counter
    end
    "Correct!"
  end
end
