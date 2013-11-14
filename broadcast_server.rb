require 'socket'

BIND_ADDR = "0.0.0.0"
PORT = 7423

# Create socket and bind to address
UDPSocket.open do |socket|

#allowing binding of multiple programs to bind to same port
  socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)

  socket.bind(BIND_ADDR, PORT)

  loop do
    data, addr = socket.recvfrom(1024)
    puts "address: #{addr}  ,  data: #{data}"
  end
end


#BasicSocket.do_not_reverse_lookup = true
