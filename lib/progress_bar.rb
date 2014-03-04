require 'pstore' #TODO try Redis or Memcached if necesary
require 'tempfile'

class ProgressBar
  # include PStoreHash
  attr_accessor :pstore, :storage_file
      
  def initialize 
    @storage_file = Tempfile.new('progress_bar.pstore')
    @pstore = PStore.new(@storage_file)
    # @pstore.transaction do
    #   @pstore[0] = []
    # end
    self.clear
    @pstore
  end
  
  def inc(amount=1)
    @pstore.transaction do
      arr = @pstore.fetch(0, false)
      raise unless arr
      amount.times do 
        arr << 1
      end
      @pstore[0] = arr
    end    
  end
  
  def clear
    @pstore.transaction do
      @pstore[0] = []
    end
  end
  
  def read
    @pstore.transaction do
      @pstore.fetch(0, []).size
    end
  end
  
  def self.size
    if @pstore
      @pstore.transaction do
        @pstore.fetch(0, []).size
      end  
    else
      0
    end
  end
   
end

