require 'eventmachine'

module Miner
  module Extensions
    module EventMachine
      def popen3 cmd, stdio_handler, stderr_handler, *args
        new_stderr = $stderr.dup
        pipe_out, pipe_in = IO::pipe
        $stderr.reopen pipe_in
        returns = EM.popen(cmd, stdio_handler, *args)
        EM.attach pipe_out, stderr_handler, *([returns] + args)
        $stderr.reopen new_stderr
        returns
      end
    end
  end
end

EventMachine.extend Miner::Extensions::EventMachine