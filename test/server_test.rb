require "./test/test_helper"
require "date"

class TestServer < Minitest::Test
  def test_server_responds_to_request
    skip #because it's an old it1 test
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("Hello World!")
  end

  def test_server_can_count_requests
    skip #because it's an old it1 test
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("(2)")
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("(3)")
  end

  def test_root_request_returns_diagnostic
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("Verb: GET")
    assert response.body.include?("Path: /")
    assert response.body.include?("Protocol: HTTP/1.1")
  end

  def test_hello_request_returns_hello_world_counter
    response = Faraday.get "http://127.0.0.1:9292/hello"
    assert response.body.include?("Hello World!")
    assert response.body.include?("(2)")
  end

  def test_datetime_request_returns_date_time
    # skip
    response = Faraday.get "http://127.0.0.1:9292/datetime"
    today = Time.now.strftime("%I\:%M%p on %A, %B %e, %Y")
    assert response.body.include?(today)
  end

  def test_shutdown_request_returns_total_requests
    response = Faraday.get "http://127.0.0.1:9292/shutdown"
    number = Integer
    assert response.body.include?("(#{number})")
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
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=overfactious"
    word = "overfactious"
    assert response.body.include?("#{word} is a known word")
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=subdorsal"
    word2 = "subdorsal"
    assert response.body.include?("#{word2} is a known word")
  end
end
