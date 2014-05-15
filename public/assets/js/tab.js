/* topnav news */

$(function(){
	$("ul.panel li:not("+$("ul.tabs li a.selected").attr("href")+")").hide(); //初期表示

	$("ul.tabs li a").click(function(){

		$("ul.tabs li a").removeClass("selected");

		$(this).addClass("selected");

		$("ul.panel li").slideUp("fast");
		$($(this).attr("href")).slideDown("fast");
		return false;
	})



})