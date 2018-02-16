require 'socket'
require 'time'
require 'pry'
require './lib/game'

# creates server object
class Server
  attr_reader :client,
              :hello_counter,
              :counter,
              :diagnostics,
              :value_1

  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0
    @hello_counter = 0
    @game = nil
  end

  def request_parser
    loop do
      @client = @tcp_server.accept
      @request_lines = []
      while line = @client.gets and !line.chomp.empty?
        @request_lines << line.chomp
      end
      puts @request_lines.inspect
      diagnostics
      pathfinder
      @counter += 1
      @client.close
    end
    @counter
  end

  def postreader
    content_length = @request_lines.grep(/^Content-Length:/)[0].split(" ")[1].to_i
    post_body = (@client.read(content_length)).to_s
    @value_1 = post_body.split("=")[1]

  end

  def diagnostics
    @verb = @request_lines[0].split(" ")[0]
    @path = @request_lines[0].split(" ")[1]
    protocol = @request_lines[0].split(" ")[2]
    host = @request_lines.grep(/^Host/)[0].split(' ')[1].split(':')[0]
    port = @request_lines.grep(/^Host/)[0].split(' ')[1].split(':')[1]
    origin = @request_lines[1].split(" ")[1].split(":")[0]
    # will need to fix that to not be host somehow
    accept = @request_lines.grep(/^Accept:/)[0].split(' ')[1]
    "<pre>
    Verb: #{@verb}
    Path: #{@path}
    Protocol: #{protocol}
    Host: #{host}
    Port: #{port}
    Origin: #{origin}
    Accept: #{accept}
    </pre>"
  end

  def headers(output)
    ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def game_respond
    if @verb == "POST"
      postreader
      @game.guesses << value_1
      output = "This value is not displayed."
      client.puts redirect_headers(output, "/game", 302)
      puts redirect_headers(output, "/game", 302)
    else
      game_guess_count = @game.guesses.compact.count
      last_guess = @game.guesses.last
      feedback = @game.feedback(last_guess)
      output = "Guess count: #{game_guess_count}\n
                #{feedback}"
      client.puts headers(output)
      client.puts output
    end
  end

  ## set headers status code to default, set location default to nil)
  def redirect_headers(output, location, status_code)
    ["http/1.1 #{status_code}",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "Location: #{location}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def root_respond
    output = "<html><head></head><body>#{diagnostics}</body></html>"
    client.puts headers(output)
    client.puts output
  end

  def hello_world_respond
    @hello_counter += 1
    output = "Hello World! (#{@hello_counter})"
    client.puts headers(output)
    client.puts output
  end

  def date_time_respond
    output = Time.now.strftime("%I\:%M%p on %A, %B %e, %Y")
    client.puts headers(output)
    client.puts output
  end

  def shut_down_respond
    output = "Total Requests: #{@counter}"
    client.puts headers(output)
    client.puts output
    client.close
    @tcp_server.close
  end

  def word_search_respond
    if dictionary.include?(provided_word)
      output = "#{provided_word} is a known word"
    else
      output = "#{provided_word} is not a known word"
    end
    client.puts headers(output)
    client.puts output
  end

  def dictionary
    File.read('/usr/share/dict/words').split("\n")
  end

  def provided_word
    @path.split("=")[1].downcase
  end

  def start_game_respond
    if @verb == "POST" && @game.nil?
      output = "Good luck!"
      @game = Game.new
      client.puts redirect_headers(output, "", "200 OK")
      client.puts output
    elsif @verb == "POST"
      output = "403 Forbidden: Game in progress"
      client.puts redirect_headers(output, "", "403 Forbidden")
      client.puts output
    else
      output = "Post to start game"
      client.puts headers(output)
      client.puts output
    end
  end

  def system_error_respond
    output = "It's broke"
    client.puts redirect_headers(output, "", 500)
    client.puts output
    raise StandardError
  end

  def error_respond
    output = "404: Oops, something went wrong. There's nothing here"
    client.puts redirect_headers(output, "", 404)
    client.puts output
  end

  def pathfinder
    if @path == "/"
      root_respond
    elsif @path == "/hello"
      hello_world_respond
    elsif @path == "/datetime"
      date_time_respond
    elsif @path == "/shutdown"
      shut_down_respond
    elsif @path[0, 12] == "/word_search"
      word_search_respond
    elsif @path == "/game"
      game_respond
    elsif @path == "/start_game"
      start_game_respond
    elsif @path == "/force_error"
      system_error_respond
    else
      error_respond
    end
  end

  def run
    request_parser
  end

end
