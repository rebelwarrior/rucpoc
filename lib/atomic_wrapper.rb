module Atomize
  #This module creates an atomic +=
  #should determine java before require atomic
  if RUBY_PLATFORM['java']
    require 'atomic'
  
    def counter(x=0)
      Atomic.new(x)
    end
    
  
    def plusplus(counter=Atomic.new(0))
      counter.update { |v| v + 1 }
    end
  elsif
    def counter(x)
      x
    end
    def plustplus(counter=0)
      counter += 1
    end
  end
  
end


  