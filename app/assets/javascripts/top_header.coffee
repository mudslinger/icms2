if $('body.top').get(0)?
	$('#header').on
	  'mouseenter': ->
	    $(@).stop()
	    $(@).animate {opacity: 0.95},300,null
	  'mouseleave': ->
	    $(@).stop()
	    $(@).animate {opacity: 0.85},1000,null
	$('#header').animate {opacity: 0.85},3000,null

