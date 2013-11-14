require "socket"
require "ipaddr"

MULTICAST_ADDR = "224.0.0.1"
BIND_ADDR = "0.0.0.0"
PORT = 3000

UDPSocket.open do

#join multicast group membership
  membership = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton
  socket.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership)

#allowing binding of multiple programs to bind to same port
  socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)

  socket.bind(BIND_ADDR, PORT)

  loop do
    message, address = socket.recvfrom(255)
    puts message
  end
end