// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function geoCodePick(picker_path, id_to_set){
	var picker_url = picker_path + "?";
	
	var geocode_orig = $("#" + id_to_set).val();
	var adress_orig = $("#" + id_to_set + "_address").val();
	if(! adress_orig){ //undefined
		adress_orig = "";
	}
	var params = { address : adress_orig, "id_to_set" : id_to_set, latlng : geocode_orig }; 
	var str = jQuery.param(params);
	picker_url += str;
	
	window.open(picker_url);
	
}


function entryPick(picker_path, id_to_set){
	var picker_url = picker_path + "?";
	var params = {  "id_to_set" : id_to_set, "id_to_set_title" : id_to_set + "_title" };
	var str = jQuery.param(params);
	picker_url += str;
	window.open(picker_url);
}
function entryPickDelete(id_to_set){
	$("#" + id_to_set ).val("");
	$("#" + id_to_set + "_title").text("");
}

function entryPicked(obj){
	
	console.log("pikked:" + $(obj).data('title'));
}