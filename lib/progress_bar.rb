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
  
  def inc
    @pstore.transaction do
      arr = @pstore.fetch(0, false)
      raise unless arr
      arr << 1
      @pstore[0] = arr
    end    
  end
  
  def clear
    @pstore.transaction do
      @pstore[0] = []
    end
  end
  
  def size
    if @pstore
      arr = @pstore.transaction { @pstore.fetch(0, [])}
      arr.size  
    else
      0
    end
  end
   
end

