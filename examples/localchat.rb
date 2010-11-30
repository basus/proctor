# This is a simple chat server that accepts clients, drops them into a shared
# chat room. Clients can send messages to this shared room and private messages
# to each other

$LOAD_PATH.unshift File.expand_path('../', __FILE__)
require 'actor.rb'

Server = Actor.new :@clients => {}

Server.on :register do |client|
  @clients[client[:name]] = client[:actor]
  client[:actor] << :connected
end

Server.on :public do |message|
  @clients.each_value do |client|
    client << :public => message[:sender] +": "+ message[:text]
  end
  puts message[:sender] +":"+ message[:text]
end

Server.on :private do |message|
  @client[message[:to]] << :private => message
end

# Make a generic client
Client = Actor.new :@server => Server

Client.on :name do |name|
  @name = name
end

Client.on :connect do
  @server << :register => { :name => @name, :actor => self}
end

Client.on :connected do
  puts "Connected"
end

Client.on :public do |message|
  puts message
end

Client.on :private do |message|
  puts "!!" + message[:sender] + "!! " + message[:text]
end

# Make some clients and start talking
John = Client.clone
John << :name "John"
John << :connect
John.on :public do |message|
    @server << :public => {:sender => @name, :text => "I don't agree with you"}
end

Mary = Client.clone
Mary << :name "Mary"
Mary << :connect
Mary.on :public do |message|
  @server << :public => {:sender => @name, :text => "I like what you said" }
end


