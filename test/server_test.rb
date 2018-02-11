require "./test/test_helper"
require "./lib/server"

class TestServer < Minitest::Test
  def test_server_responds_to_request
    # server = Server.new
    # server.request_loop
    response = Faraday.get "http://127.0.0.1:9292/"
    expected = "<html><head></head><body>'Hello, World!'</body></html>"
    assert_equal expected, response.body
  end
end
