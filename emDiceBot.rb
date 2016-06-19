#!/usr/bin/ruby

$LOAD_PATH << File.dirname(__FILE__)

require 'em-websocket'
require 'json'
require 'pp'
require 'logger'
require 'bcdiceCore.rb'

require 'eventmachine'

def parseCmd ( buf )
  parseStr = buf.split( nil, 3 )
  if ( parseStr.length == 2 ) then
    $bcdice.setGameByTitle("")
    $bcdice.setMessage(parseStr[1])
    ret, secret = $bcdice.dice_command
    return ( ret )
  elsif ( parseStr.length == 3 ) then
    if ( parseStr[0] == "rollDice" ) then
      ret1=$bcdice.setGameByTitle(parseStr[2])
      $bcdice.setMessage(parseStr[1])
      ret2, secret = $bcdice.dice_command
      return ( ret1 + ret2 )
    else
      return ("Invaclid command: " + buf )
    end
  else
    return ("Invaclid command: " + buf )
  end
end

$bcdiceMaker = BCDiceMaker.new()
$bcdice = $bcdiceMaker.newBcDice()

EM::WebSocket.start({:host => "0.0.0.0", :port => 8888}) do |wsConnection|
  wsConnection.onopen do
  end

  wsConnection.onmessage do |message|
    ret = parseCmd( message )
    wsConnection.send(ret)
  end

end
