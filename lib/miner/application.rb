require 'sinatra/base'
require 'json'
require 'haml'
require 'miner/extensions/event_machine'

module Miner
  class Application < Sinatra::Base
  
    class << self
    
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
      def command(cmd); mc_server.send_data(cmd + "\n"); end
    end
    
    get '/' do
      haml :home
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
  
  
    template :home do%{
  %html
    %head
      %title MinecraftManager
      %script(src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js")
      %script(src="/js/main.js")
    %body
      .messages(style="height: 300px; overflow-y:scroll; overflow-x:hidden ")
        %ul#messages
      %form#command
        %input(name="cmd")
  }end

    helpers do
      def mainjs
        %{$(function(){
        
            var $cmd = $("input[name=cmd]");
            var updateMessages = function(){
              $.getJSON('/messages', function(data){
                var $messages = $('#messages'), $div = $('.messages');
                $messages.text('');
                $(data).each(function(){
                  $messages.append('<li>' + this + '</li>');
                  $div.scrollTop(50000);
                });
              });
            };
            $("form#command").submit(function(){
              var command = $cmd.val();
              $.post('/command', {cmd:command}, function(){
                $cmd.val('');
              });
              return false;
            });
            setInterval(updateMessages, 500);
          
          });
        }.gsub(/^        /, '')
      end
    end
  end
end