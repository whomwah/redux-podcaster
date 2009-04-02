# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def to_guid(pid)
    Obscurer.obscure(pid)  
  end

  def to_pid(guid)
    Obscurer.unobscure(guid)  
  end
end
