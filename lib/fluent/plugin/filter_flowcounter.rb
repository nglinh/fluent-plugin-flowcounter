# Be lazy to to implement filter plugin, use output plugin instance
require_relative 'out_flowcounter'
require 'forwardable'

class Fluent::FlowCounterFilter < Fluent::Filter
  Fluent::Plugin.register_filter('flowcounter', self)

  extend Forwardable
  attr_reader :output
  def_delegators :@output, :configure, :start, :shutdown, :flush_emit

  def initialize
    super
    @output = Fluent::FlowCounterOutput.new
  end

  def filter_stream(tag, es)
    @output.emit(tag, es, Fluent::NullOutputChain.instance)
    es
  end
end if defined?(Fluent::Filter)
