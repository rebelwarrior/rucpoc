require 'observer'

class MyObserverClass
  def update(new_data)
    puts "+++>> New data:: #{new_data}"
    # render text: new_data, layout: false
    @data = new_data
  end
  
  def data
    @data ||= 0
  end
end