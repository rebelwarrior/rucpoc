module LogsHelper
  protected
    def log_resource
      @log ||= @collection.log.build(params[:log])
    end 
end
