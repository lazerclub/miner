module Miner
  class Server < Thin::Server
    
    def initialize(host = '0.0.0.0', port = 9898)
      super(host, port, Miner::Application)
      @pid_file = '~/miner'
      @log_file = '~/miner.log'
      daemonize
    end
    
    def name
      "miner " + Miner::VERSION
    end
  end
end