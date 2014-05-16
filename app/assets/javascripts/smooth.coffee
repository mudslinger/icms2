$("#nav ul li a[href^='#']").on 'click', (e)->
	e.preventDefault()
	hash = @hash
	$('html, body').animate
		scrollTop: $(this.hash).offset().top
		300
		->
	    	window.location.hash = hash

$(window).resize ->
	$('[data-spy="scroll"]').each ->
		$(@).scrollspy('refresh')