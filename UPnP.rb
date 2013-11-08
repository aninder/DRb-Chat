require 'socket'

class UPnP
  RHOST='192.168.1.3'

  def initialize
    @mutex=Mutex.new
    @upnp_port = 0
    @found_upnp_port = false
    @key_to_port={}
  end

  def upnp_server(server)
    client = server.accept
    request = client.readline()
    puts request
    if (request =~ /GET \/([\da-f]+).xml/)
      @mutex.synchronize {
        @found_upnp_port = true
        @upnp_port = @key_to_port[$1]
        # Important: Keep the client connection open
        @client_socket = client
      }
    end
  end

  def scan_for_upnp_port
    upnp_port = 0
    server = TCPServer.open(20001)
    server_thread = Thread.new { self.upnp_server(server) }
    begin
      socket = UDPSocket.new
      upnp_location = "http://#{RHOST}:20001"

      puts "[*] Listening for UPNP requests on: #{upnp_location}"
      puts "[*] Sending UPNP Discovery replies..."

      port = 49152;
      while port < 65536 && @mutex.synchronize { @found_upnp_port == false }
        key = sprintf("%.2x%.2x%.2x%.2x%.2x",
                      rand(255), rand(255), rand(255), rand(255),
                      rand(255))
          @key_to_port[key] = port
        upnp_reply =
            "HTTP/1.1 200 Ok\r\n" +
                "ST: urn:schemas-upnp-org:service:WANIPConnection:1\r\n" +
                "USN: uuid:7076436f-6e65-1063-8074-0017311c11d4\r\n" +
                "Location: #{upnp_location}/#{key}.xml\r\n\r\n"
        socket.send(upnp_reply, 0, RHOST, port)
        port += 1
      end
      socket.close
      puts "sent to all ports........"
      @mutex.synchronize {
        if (@found_upnp_port)
          upnp_port = @upnp_port
        end
      }

      server_thread.join
    end
    return upnp_port
  end
end

UPnP.new.scan_for_upnp_port