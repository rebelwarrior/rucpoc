module LogsHelper
  protected
    def find_log_user_email(log_id)
      user = User.find_by_id(log_id)
      user.nil? ? "error: Usuario no fue registrado" : user.email
    end
    

  
    def log_resource
      @log ||= @collection.log.build(params[:log])
    end 
    
    
end
