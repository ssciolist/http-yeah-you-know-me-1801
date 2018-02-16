require 'time'
require './lib/server'

# root respond need diag
#provided_word needs diag too
#game needs game class
class Response
  # def initialize
  #   server = Server.new
  # end

  def headers(output)
    ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def root_respond(diagnostics)
    output = "<html><head></head><body>#{diagnostics}</body></html>"
    client.puts headers(output)
    client.puts output
  end

  # def hello_world_respond
  #   @hello_counter += 1
  #   output = "Hello World! (#{@hello_counter})"
  #   client.puts headers(output)
  #   client.puts output
  # end
  #
  # def date_time_respond
  #   output = Time.now.strftime("%I\:%M%p on %A, %B %e, %Y")
  #   client.puts headers(output)
  #   client.puts output
  # end
  #
  # def shut_down_respond
  #   output = "Total Requests: #{@counter}"
  #   client.puts headers(output)
  #   client.puts output
  #   client.close
  #   @tcp_server.close
  # end
  #
  # def word_search_respond
  #   if dictionary.include?(provided_word)
  #     output = "#{provided_word} is a known word"
  #   else
  #     output = "#{provided_word} is not a known word"
  #   end
  #   client.puts headers(output)
  #   client.puts output
  # end
  #
  # def dictionary
  #   File.read('/usr/share/dict/words').split("\n")
  # end
  #
  # def provided_word
  #   @path.split("=")[1].downcase
  # end
  #
  # def game_respond
  #   # if post request store guess in @guesses
  #   # otherwise same response as GET request
  #   # output = "Guess count: {@guess_count}"
  #   if @verb == "POST"
  #     #
  #   else
  #     game_guess_count = @game.guess_count
  #     output = "Guess count: #{game_guess_count}"
  #     client.puts headers(output)
  #     client.puts output
  #   end
  # end
  #
  # def start_game_respond
  #   output = "Good luck!"
  #   @game = Game.new
  #   client.puts headers(output)
  #   client.puts output
  # end
  #
  # def error_respond
  #   output = "Oops, something went wrong. There's nothing here"
  #   client.puts headers(output)
  #   client.puts output
  # end

end
