class Game
  attr_accessor :guesses,
                :guess_count,
                :correct_number

  def initialize
    @correct_number = rand(0..100)
    @guesses = []
  end

  def feedback(guess)
    return "You haven't made any guesses" if guess.nil?
    if guess.to_i > @correct_number
      "Your last guess was #{guess}. Too high"
    elsif guess.to_i < @correct_number
      "Your last guess was #{guess}. Too low"
    else
      "Correct! The answer was #{guess}."
    end
  end
end
