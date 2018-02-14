class Game
  def initialize
    "Good luck!"
    @correct_number = rand(0..100)
    @counter = 0
  end

  def guess
    @guess = ""
  end

  def run
    while @guess.to_i != random_number
      if @guess.to_i > random_number
        "Too high"
      else
        "Too low"
      end
    end
    "Correct! The answer was #{random_number}."
  end
end
