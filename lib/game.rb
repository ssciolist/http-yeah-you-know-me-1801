class Game
  attr_accessor :guesses,
                :guess_count,
                :correct_number
  def initialize
    @correct_number = rand(0..100)
    @guesses = []
  end

  def feedback(guess)
    if guess > @correct_number
      "Too high"
    elsif guess < @correct_number
      "Too low"
    else
      "Correct!"
    end
  end
end
