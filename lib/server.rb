# creates server object
require 'socket'
require 'date'
require 'pry'

class Server
  attr_reader :client,
              :tcp_server,
              :request_lines
  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_counter = 0
  end

  def request_parser
    @client = @tcp_server.accept
    @request_lines = []
    loop do
      while line = client.gets and !line.chomp.empty?
        #look into tcp server.read
        @request_lines << line.chomp
      end
      puts @request_lines.inspect
      respond
    end
  end

  def diagnostics
    verb = @request_lines[0].split(" ")[0]
    path = @request_lines[0].split(" ")[1]
    protocol = @request_lines[0].split(" ")[2]
    host = @request_lines.grep(/^Host/)[0].split(' ')[1].split(':')[0]
    port = @request_lines.grep(/^Host/)[0].split(' ')[1].split(':')[1]
    origin = @request_lines[1].split(" ")[1].split(":")[0]
    # will need to fix that to not be host somehow
    accept = @request_lines.grep(/^Accept:/)[0].split(' ')[1]

    "<pre>
    Verb: #{verb}
    Path: #{path}
    Protocol: #{protocol}
    Host: #{host}
    Port: #{port}
    Origin: #{origin}
    Accept: #{accept}
    </pre>"
  end

  def respond
    diagnostic_check = diagnostics
    response = "Hello World! (#{@hello_counter})"
    output = "<html><head></head><body>#{response}#{diagnostic_check}</body></html>"
    client.puts headers(output)
    client.puts output
    @hello_counter += 1
    request_parser
  end

  def headers(output)
    ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def hello_world_respond
    output = "Hello World! (#{@hello_counter})"
    client.puts headers(output)
    client.puts output
    @hello_counter += 1
  end

  def datetime_respond
    output = Date.today.strftime("%I\:%M%p on %A, %B %e, %Y")
    client.puts headers(output)
    client.puts output
  end



  def run
    request_parser
  end
end
