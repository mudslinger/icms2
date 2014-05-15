if $('#location').get(0) && $('#zoom').get(0)
	idokeido = $('#location').text()
	zoom = $('#zoom').text()
	lat = idokeido.split(',')[0] if idokeido?
	lng = idokeido.split(',')[1] if idokeido?
	latlng = new google.maps.LatLng(lat, lng)
	mapOptions = {
		zoom: parseInt(zoom)
		center: latlng
		mapTypeId: google.maps.MapTypeId.ROADMAP
		scaleControl: true
	}
	mapObj = new google.maps.Map(document.getElementById('maps'), mapOptions)
	marker = new google.maps.Marker(
		position: latlng
		map: mapObj
	)