require 'bundler'

Bundler.setup(:test)

$:.unshift File.join(File.dirname(File.dirname(__FILE__)), 'lib')

require 'miner'