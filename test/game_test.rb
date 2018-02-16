require "./test/test_helper"
require "./lib/game"

class TestGame < Minitest::Test
  def test_it_exists
   game = Game.new
   assert_instance_of Game, game
  end

 def test_it_can_generate_a_random_number_between_0_and_100
   game = Game.new
   assert game.correct_number.between?(0, 100)
 end

 def test_it_stores_guess
   game = Game.new
   assert game.guesses.count, 0
   game.feedback(12)
   assert game.guesses.count, 1
 end

 def test_it_can_respond_to_string
   game = Game.new
   guess = "19"
   game.feedback(guess)
   assert game.feedback(guess).include?("You")
 end

end
