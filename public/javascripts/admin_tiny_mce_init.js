function admin_tiny_mce_init(admin_tiny_mce_content_css){
	tinyMCE.init({
		/*
    	mode : "specific_textareas",
    	editor_selector : "wysiwyg",
		language : "ja",
		theme : "advanced",
		plugins : "pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,inlinepopups,autosave",
		relative_urls : false, //相対パスに変換しない

		theme_advanced_buttons4 : "tablecontrols,|",
		theme_advanced_toolbar_location : "top",
		*/
		
		// General options
		mode : "specific_textareas",
		editor_selector : "wysiwyg",
		language : "ja",
		theme : "advanced",
		plugins : "pagebreak,style,layer,table,save,advhr,advimage,advlink,emotions,iespell,inlinepopups,insertdatetime,preview,media,searchreplace,print,contextmenu,paste,directionality,fullscreen,noneditable,visualchars,nonbreaking,xhtmlxtras,template,wordcount,advlist,autosave",
		relative_urls : false, //相対パスに変換しない
		
		// Theme options
		theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,justifyfull,fontsizeselect,formatselect,|,link,unlink,image,preview,|,forecolor,backcolor",
		theme_advanced_buttons2 : "tablecontrols,|,ltr,rtl,|,fullscreen,|,code",
		theme_advanced_buttons3 : "",
		
		theme_advanced_toolbar_location : "top",
		theme_advanced_toolbar_align : "left",
		theme_advanced_statusbar_location : "bottom",
		theme_advanced_resizing : true,

		// Example content CSS (should be your site CSS)
		content_css : admin_tiny_mce_content_css,

	
	
	});
	
}	