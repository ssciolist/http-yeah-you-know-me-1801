# creates server object
require 'socket'
require 'pry'

class Server
  def initialize
    tcp_server = TCPServer.new(9292)
    @client = tcp_server.accept
  end

  def request_parser
    @request_lines = []
    while line = @client.gets and !line.chomp.empty?
      @request_lines << line.chomp
    end
    puts "Got this request:"
    puts @request_lines.inspect
  end

  def response_writer
    response = "<pre>" + @request_lines.join("\n") + "</pre>"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "server: ruby",
              "content-type: text/html; charset=iso-8859-1",
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    @client.puts headers
    @client.puts output
    @client.close
    puts ["Wrote this response:", headers, output].join("\n")
    puts "\nResponse complete, exiting."
  end

  def respond
    request_parser
    response_writer
  end
end
