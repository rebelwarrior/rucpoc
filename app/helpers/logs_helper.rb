module LogsHelper
  protected

    def log_resource
      @log = @log || @collection.log.build(params[:log])
    end 
    
    
end
