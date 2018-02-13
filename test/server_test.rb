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
    assert response.body.include?("(1)")
  end

  def test_datetime_request_returns_date_time
    # skip
    response = Faraday.get "http://127.0.0.1:9292/datetime"
    today = Time.now.strftime("%I\:%M%p on %A, %B %e, %Y")
    assert response.body.include?(today)
  end

  def test_shutdown_request_returns_total_requests
    response = Faraday.get "http://127.0.0.1:9292/shutdown"
    assert response.body.include?("(2)")
  end

end
