module CollectionsHelper
  def red_green_yellow_grey_tag(invoice)
    if invoice.nil?
      "grey"
    elsif !invoice.amount_owed.nil? 
      if invoice.paid?
        "green"
      elsif invoice.being_processed?
        "yellow"
      else
        "red"
      end
    else
      "grey"
    end
  end
    
end
