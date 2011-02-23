module Miner
  class StdErrRedirector < EM::Connection
    def initialize(*args)
      super(*args)
      @listener = args.first
    end
  
    def receive_data(msg)
      @listener.receive_data(msg)
    end
  end
end