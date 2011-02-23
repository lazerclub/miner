module Miner
  class ServerListener < EventMachine::Connection
    include EventMachine::Protocols::LineText2
    
    def initialize(*args)
      super(*args)
      @connected, @started = false, false
      @listener = args.first
    end
    
    def stop
      send_data("stop\n")
    end
    
    def receive_line(msg)
      if !running?
        @connected = true
        listener.on_init(self)
      end
       
      if msg =~ /Done/
        listener.on_start(self)
        @started = true 
      end
      
      
      listener.on_message(msg.chomp)
    end
    
    def unbind
      listener.on_stop(self)
      @connected = false
    end
    
    attr_reader :listener
    
    def started?
      @started
    end
    
    def running?
      @connected
    end
  end
end