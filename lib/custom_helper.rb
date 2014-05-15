#coding:utf-8
#require 'rss'
#サイトに固有のヘルパ
module CustomHelper
  #
  #
  #
  def each_headline_seminar(status, per_page = :all)
    per_page = per_page == :all ? 999 : per_page
    catg_name = "seminar"
    field_name = "status"
    
    logger.debug("each_headline_seminarが呼ばれた")
    
    headline('seminar', per_page).where("entries.id IN( SELECT entry_id FROM entry_metas, forms, fields
WHERE 
forms.template_name=? AND 
forms.id=fields.form_id AND 
fields.name=? AND 
fields.id=entry_metas.field_id  AND 
entry_metas.string_value=?)", catg_name, field_name, status).each do |entry|
      yield entry
    end
    
  end
  
  #
  #
  #
  def shop_count
    headline("shop", 9999, :where => "{status}='1' ").total_count
  end
  
  #
  #
  #
  def link_to_return(title)
#    case url
#      when "index"
#        link_to title, "index.html"
#      when "category"
#        link_to title, "category.html"
#      when "area_category"
#        link_to title, "area_category.html"
#      else
#        link_to title, "#", :onclick => "history.back(); return false;"
#    end

    url = params[:return]
    if url.blank?
      link_to title, "#", :onclick => "history.back(); return false;"
    else
      link_to title, "/#{url}"
    end
    
  end
  
  
  
  #
  #
  #
  def shop_detail_path_for(entry, return_url)
    contents_detail_path(:name => entry.form.template_name, :id => entry.id, :return => return_url)
  end
  
  def params_integer(key)
   val = params[key]
   unless val.blank?
     val[/\d+/]
   end
  end
 
  def alt_title(entry)
   if entry
     str = entry.cf.name
     unless str.blank?
       str
     else
       entry.title
     end
   end
  end
end