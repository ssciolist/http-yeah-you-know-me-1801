require "./test/test_helper"
require "date"

class TestServer < Minitest::Test
  def test_root_request_returns_diagnostic
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("Verb: GET")
    assert response.body.include?("Path: /")
    assert response.body.include?("Protocol: HTTP/1.1")
  end

  def test_hello_request_returns_hello_world_counter
    response = Faraday.get "http://127.0.0.1:9292/hello"
    assert_equal response.body, "Hello World! (1)"
  end

  def test_datetime_request_returns_date_time
    response = Faraday.get "http://127.0.0.1:9292/datetime"
    today = Time.now.strftime("%I\:%M%p on %A, %B %e, %Y")
    assert response.body.include?(today)
  end

  def test_shutdown_request_returns_total_requests
    skip
    response = Faraday.get "http://127.0.0.1:9292/shutdown"
    assert response.body.include?("Total Requests:")
  end

  def test_word_search_request_rejects_weird_words
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=butt0n"
    word = "butt0n"
    assert response.body.include?("#{word} is not a known word")
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=czw~"
    word2 = "czw~"
    assert response.body.include?("#{word2} is not a known word")
  end

  def test_word_search_request_finds_actual_words
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=Overfactious"
    word = "Overfactious".downcase
    assert response.body.include?("#{word} is a known word")
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=subdorsal"
    word2 = "subdorsal"
    assert response.body.include?("#{word2} is a known word")
  end

  def test_post_to_start_game
    response = Faraday.post "http://127.0.0.1:9292/start_game"
    assert response.body.include?("Good luck!")
  end

  def test_get_game_returns_guess_count_if_no_guesses
    Faraday.post "http://127.0.0.1:9292/start_game"
    response = Faraday.get "http://127.0.0.1:9292/game"
    assert_equal response.body, "Guess count: 0"
  end

  def test_post_guess_to_game
    Faraday.post "http://127.0.0.1:9292/start_game"
    Faraday.post "http://127.0.0.1:9292/game", { :guess => '50' }
    Faraday.get "http://127.0.0.1:9292/game"
    assert_equal response.body, "1"
  end

  def test_pull_out_guess_from_post_request
  end

  #can someone make a guess w/o starting game? they shouldnt b able to
  #what if its not a number guess?
end
