require 'drb/drb'
require 'ostruct'

class Client
  attr_accessor :name
  include DRbUndumped
  def initialize(name)
    @name=name
  end
  def message(msg)
    puts msg
  end
end

DRb.start_service
remote_connection=DRbObject.new(nil,"druby://localhost:4200")

puts "enter your chat name"
name = gets.chomp
client = Client.new(name)
connection=remote_connection.add_client(client)
loop do
  gets.chomp
  connection.to_server($_)
  if $_ =="bye"
    remote_connection.bye
    break
  end
end
