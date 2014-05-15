$(document).ready(function(){
	var display_state; //変数 display_stateをつくる

  $('.hasSubMenu').mouseover(function() {　// .hasSubMenuにマウスオーバーしたら
		display_state = $("ul",this).css("display"); //display_state　に、この要素の次のulのdisplayプロパティを代入する

		if(display_state == "none"){ //display_stateの値がnoneだった場合次を実行する
			
			$("ul",this).css("display", "block");//この要素内のulをスライドダウンで表示しなさい
		}
  });

  $('.hasSubMenu').mouseout(function() {
		display_state = $("ul",this).css("display");

		if(display_state != "none"){
			$("ul",this).css("display", "none");
		}
  });
});