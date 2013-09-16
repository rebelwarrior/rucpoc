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
    
  def collection_last_updated(collection)
    if collection.logs #inject == reduce
      collection.logs.inject(collection.updated_at) do |acc, log|
        acc = (acc > log.updated_at) ? acc : log.updated_at 
      end
    else
      collection.updated_at
    end
  end
    
end
