module Atomize
  #This module creates an atomic +=
  #should determine java before require atomic
  if RUBY_PLATFORM['java']
    require 'atomic'
  
    def new_counter(x=0)
      Atomic.new(x)
    end
    
    def get_counter(x)
      x.get
    end
  
    def plusplus(counter=Atomic.new(0))
      counter.update { |v| v + 1 }
    end
    
  elsif
    def counter(x)
      x
    end
    
    def get_counter(x)
      x
    end
    
    def plustplus(counter=0)
      counter += 1
    end
  end
  
end


  