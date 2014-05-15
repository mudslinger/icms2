#= require jquery
#= require jquery_ujs

#= require bootstrap/affix
#= require bootstrap/alert
#= require bootstrap/button
#= require bootstrap/carousel
#= require bootstrap/collapse
#= require bootstrap/dropdown
#= require bootstrap/modal
#= require bootstrap/tooltip
#= require bootstrap/popover
#= require bootstrap/scrollspy
#= require bootstrap/tab
#= require bootstrap/transition
#= require jquery.heightLine
#価格の書き換え
#= require digits
#google maps 読み込み
#= require maps

#topナビゲーション 透明化
#= require top_header

#Notification slide
#= require noty

#apply heightline
#$("div.thumbnail").heightLine() if $("div.thumbnail")
rf = (ticker,news,i)->
	ticker.css(left: '3000px',opacity: 1)
	ticker.html(news.get(i))
	ticker.animate left:0,800
	ret = (if i+1 >= news.length then 0 else i+1)

if $('body.top').get(0)?
	ticker = $('#ticker')
	#iconを追加
	news = $('a.original-news').clone(false)
	# news.each =>
	# 	$("<span class='glyphicon glyphicon-bullhorn' />").prependTo($(@))

	idx = rf(ticker,news,0)
	setInterval -> 
		idx = rf(ticker,news,idx)
	,10000



