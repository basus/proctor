require 'actor'

Server = Actor.new  :@resources => {}

Server.on :print do |resource|
  if @resources.include? resource
    puts @resources[resource]
  else
    puts "No such resource"
  end
end

Server.on :request do |request|
  if @resources.includes? request[:resource]
    request[:to] << :respond => @resources[request[:resource]]
  else
    request[:to] << :respond => "No such resource"
  end
end

Server.on :show do
  puts @resources
end

Server.on :register do |resource|
  puts resource
  @resources = @resources.merge(resource)
end

Server << :register => {"class" => "ece491"}
Server << :register => { "student" => "Shrutarshi Basu"}

Server << :print => "student"
Server << :request => {:resource => "class", :to => self }
Server << :show
