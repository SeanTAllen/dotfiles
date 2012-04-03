class Swap < Plugin

  requires_version '1.0.3'

  @entries = []

  class << self
    attr_accessor :entries
  end

  def before
    Kernel.class_eval do
      def swap(source, target)
        Swap.entries << {:only => @only||[], :except => @except||[], :source => source, :target => target}
      end
    end
  end

  def event_received(sequence)
    return false if RunningApplication.current.nil?

    Swap.entries.each do |entry|
      if for_application?(entry, RunningApplication.current.name) 
       if(Regexp.new(entry[:source]).match(sequence))
         send(sequence.gsub(entry[:source], entry[:target]))
         return true
       elsif(Regexp.new(entry[:target]).match(sequence))
         send(sequence.gsub(entry[:target], entry[:source]))
         return true
       end
      end
    end
 
    return false
  end

  def for_application?(entry, application)
    entry[:only].each do |regex|
      return false if regex.match(application).nil?
    end

    entry[:except].each do |regex|
      return false if regex.match(application)
    end

    return true
  end
  
end

