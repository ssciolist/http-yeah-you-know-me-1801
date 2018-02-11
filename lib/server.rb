# creates server object
require 'socket'
require 'pry'

class Server
  attr_reader :client
  def initialize
    @tcp_server = TCPServer.new(9292)
    @hello_counter = 0
  end

  def request_parser
    @client = @tcp_server.accept
    @request_lines = []
    loop do
    while line = client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    puts "Got this request:"
    puts @request_lines.inspect
    @request_lines
    respond
    end
  end

  def respond
    response = "Hello World! (#{@hello_counter})"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
    @hello_counter += 1
    request_parser
  end

  def run
    request_parser
  end
end
