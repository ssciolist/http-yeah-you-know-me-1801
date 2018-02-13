# creates server object
require 'socket'
require 'time'
require 'pry'

class Server
  attr_reader :client

  def initialize
    @tcp_server = TCPServer.new(9292)
    @counter = 0
    @hello_counter = 0
  end

  def request_parser

    # @request_lines = []
    loop do
      @client = @tcp_server.accept
      @request_lines = []
      while line = client.gets and !line.chomp.empty?
        #look into tcp server.read
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

  def diagnostics
    verb = @request_lines[0].split(" ")[0]
    @path = @request_lines[0].split(" ")[1]
    protocol = @request_lines[0].split(" ")[2]
    host = @request_lines.grep(/^Host/)[0].split(' ')[1].split(':')[0]
    port = @request_lines.grep(/^Host/)[0].split(' ')[1].split(':')[1]
    origin = @request_lines[1].split(" ")[1].split(":")[0]
    # will need to fix that to not be host somehow
    accept = @request_lines.grep(/^Accept:/)[0].split(' ')[1]
    # binding.pry
    "<pre>
    Verb: #{verb}
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

  def root_respond
    output = "<html><head></head><body>#{diagnostics}</body></html>"
    client.puts headers(output)
    client.puts output
    # request_parser
  end

  def hello_world_respond
    output = "Hello World! (#{@hello_counter})"
    client.puts headers(output)
    client.puts output
    @hello_counter += 1
    # request_parser
  end

  def datetime_respond
    output = Time.now.strftime("%I\:%M%p on %A, %B %e, %Y")
    client.puts headers(output)
    client.puts output
    # request_parser
  end

  def shutdown_respond
    output = "Total Requests: #{@counter}"
    client.puts headers(output)
    client.puts output
    # request_parser
  end

  def pathfinder
    if @path == "/"
      root_respond
    elsif @path == "/hello"
      hello_world_respond
    elsif @path == "/datetime"
      datetime_respond
    elsif @path == "/shutdown"
      shutdown_respond
    end
  end

  def run
    request_parser
  end
end
