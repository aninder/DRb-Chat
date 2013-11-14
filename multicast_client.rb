require "socket"

MULTICAST_ADDR = "224.0.0.1"
PORT = 3000

UDPSocket.open do |socket|

socket.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, 1)
socket.send("#########", 0, MULTICAST_ADDR, PORT)

end