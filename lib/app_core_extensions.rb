#coding:utf-8

class Time
  
  def wareki_year_str
    
    "平成#{wareki_year}年"
    
  end
  
  def wareki_year
    self.year - 1988
  end
  
  
end