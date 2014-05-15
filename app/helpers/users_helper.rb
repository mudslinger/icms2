module UsersHelper
  
  def user_level_options
    ret = []
    User.user_level_map.each do |i,e| 
      ret << [e,i]
    end
    ret
  end
  
end
