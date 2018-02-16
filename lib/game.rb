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
    if guess > @correct_number
      "Your last guess was #{guess}. Too high"
    elsif guess < @correct_number
      "Your last guess was #{guess}. Too low"
    else
      "Correct!"
    end
  end
end
