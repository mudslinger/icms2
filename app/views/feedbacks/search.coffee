$('#aja').html("<%=escape_javascript render 'search' %>")
$('.smart_select').on 'click', ->
  $("#<%=@return_id%>").val($(@).attr('data-shop-id'))
  $('#aja').dialog('close')
$('#aja').dialog()