require 'sinatra/base'
require 'json'
require 'haml'
require 'miner/extensions/event_machine'

module Miner
  class Application < Sinatra::Base
    
    set :root, File.dirname(__FILE__)
  
    class << self
    
      def attempt_server_start
        EM.popen3('java -jar minecraft_server.jar', Miner::ServerListener, StdErrRedirector, self)
      end
      
      def on_init(server)
        set :minecraft_server, server
      end
    
      def on_start(server)
        set :server_started, true
      end
    
      def on_message(msg)
        @messages ||= []
        @messages.push(msg)
      end
    
      def on_stop(arg)
        nil
      end
    
      attr_reader :messages
    end
  
    helpers do
      def start_mc; self.class.start_minecraft; end
      def mc_server; options.minecraft_server; end
      def stop_mc; mc_server.stop; end
      def messages; self.class.messages; end
      def command(cmd); handles?(cmd) ? dispatch(cmd) : mc_server.send_data(cmd + "\n"); end
    end
    
    get '/' do
      haml :index
    end
  
    get '/messages' do
      content_type :json
      messages.to_json
    end
  
    get '/js/main.js' do
      content_type :js
      mainjs
    end
  
    post '/command' do
      self.class.on_message(params[:cmd])
      command(params[:cmd])
    end
  
    post '/restart' do
      nil
    end
  
    post '/stop' do
      if mc_server.running?
        stop_mc
        "Stopping"
      else
        "Not running"
      end
    end
  
    post '/start' do
      if mc_server.running?
        "already started"
      else
        start_mc
        "Starting"
      end
    end

    helpers do
      def mainjs
        %{
        }.gsub(/^        /, '')
      end
    end
  end
end