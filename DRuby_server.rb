require 'drb/drb'
require 'ostruct'

class Connection
  include DRbUndumped
  attr_reader :name

   def initialize(server,remote)
     @remote=remote
     @server=server
     @name=remote.name
   end
   def to_server(msg)
     @server.message(@remote,msg)
   end
   def to_client(msg)
     @remote.message(msg)
   end
end

class Server
  attr_accessor :connections
  def initialize
    @connections=[]
  end
  def add_client(remote)
    puts "new client"
    c=Connection.new(self,remote)
    @connections << c
    c.to_client("users=>"+ (@connections.length != 0 ? usernames : "NO USER LOOGED IN ")  )
    c.to_client("welcome #{remote.name} from server")
    return c
  end
  def usernames
    @connections.map {|user| user.name}.join("\n")
  end
  def message(remote,msg)
    msg="#{remote.name} : #{msg}"
    connections.each do |connection|
      connection.to_client(msg) if connection.name != remote.name
    end
  end
end

DRb.start_service("druby://localhost:4200",Server.new)
DRb.thread.join


