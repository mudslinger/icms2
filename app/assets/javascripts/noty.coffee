$('.noty-button').click ->
	$slidebtn = $(@)
	$slidebox = $(@).parent()
	if $slidebox.css('left') == '-282px'
		$slidebox.animate left:0,300
		$slidebtn.animate left:280,300
	else
		$slidebox.animate left:-282,300
		$slidebtn.animate left:280,300