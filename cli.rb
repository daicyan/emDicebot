#!/usr/bin/ruby
# coding: utf-8
require 'readline'
require 'rubygems'
require 'websocket-client-simple'

ws = WebSocket::Client::Simple.connect 'http://localhost:8888'

ws.on :message do |msg|
  puts( "Message From Server: " + msg.data )
end

ws.on :open do
  puts( "Connected" )
end

ws.on :close do |e|
  puts( e )
  puts( "Closed" )
  exit( 0 )
end

while buf = Readline.readline("Cli> ", true)
  puts( "Sending message to Server: " + buf )
  ws.send( buf )
end
