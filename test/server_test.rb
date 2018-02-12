require "./test/test_helper"
# require "./lib/server"

class TestServer < Minitest::Test
  def test_server_responds_to_request
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("Hello World!")
  end

  def test_server_can_count_requests
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("(2)")
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("(3)")
  end

  def test_server_gets_diagnosics
    response = Faraday.get "http://127.0.0.1:9292/"
    assert response.body.include?("Verb: GET")
    assert response.body.include?("Path: /")
    assert response.body.include?("Protocol: HTTP/1.1")
  end

end
