require 'monitor'
require 'thread'

class Actor

  alias :<< :send

  def initialize(*ivars)
    @methods = {}
    @msgq = Queue.new
    ivars.each do |i|
      i.each { |key, value| instance_variable_set(key,value)}
    end

    @actor = Thread.new do
      recv_loop(@msgq)
      puts "Receive loop ended"
    end
  end

  def recv_loop(msgq)
    while true
        execute(msgq.pop)
    end
  end

  def on(message, &block)
    meta = class << self; self; end
    meta.send(:define_method,message, &block)
  end

  def execute(message)
    if message.has_key?(:value)
      __send__ message[:selector], message[:value]
    else
      __send__ message[:selector]
    end
  end

  def send(msg)
    message = { }
    if msg.is_a? Hash && msg.length == 1
      message[:selector], message[:value] = msg.to_a.first
    else
      message[:selector] = msg
    end

    @msgq << message

  end

  def has(symbol, value)
    @actor[symbol] = value
  end


end
