require 'socket'

PORT=7423

UDPSocket.open do |socket|

  socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_BROADCAST, true)
  socket.send("XXXXXXXXXX", 0, Socket::INADDR_BROADCAST, PORT)

end