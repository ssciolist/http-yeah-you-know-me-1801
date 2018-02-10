# creates server object
require 'socket'

class Server

  def initialize
    tcp_server = TCPServer.new(9292)
    client = tcp_server.accept
  end

  def store_requests
    puts "Ready for a request"
    request_lines = []
    while line = client.gets and !line.chomp.empty?
      request_lines << line.chomp
    end
  end

  def show_request
    puts "Got this request:"
    puts request_lines.inspect
  end

  def respond
    response = "Hello World!"
    output = "<html><head></head><body>#{response}</body></html>"
    headers = ["http/1.1 200 ok",
            "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
            "server: ruby",
            "content-type: text/html; charset=iso-8859-1",
            "content-length: #{output.length}\r\n\r\n"].join("\r\n")
    client.puts headers
    client.puts output
  end

  puts ["Wrote this response:", headers, output].join("\n")
  client.close
  puts "\nResponse complete, exiting."
end
