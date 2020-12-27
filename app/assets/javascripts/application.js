$(function(){
	var startPos = 0, winScrollTop = 0;
	$(window).on('scroll', function(){
		winScrollTop = $(this).scrollTop();
		if(winScrollTop >= startPos){
			// 閉じるとき
			$('.topBox').addClass('hide');
			$('.searchformBox').css('transform', "TranslateY(-100%)");
			$('.searchformBox').css('transition', '0.3s');
			$('.cp_menu').css('display', 'none')
		}else{
			// 開くとき
			$('.topBox').removeClass('hide');
			$('.searchformBox').css('transform', "TranslateY(0px)");
			$('.cp_menu').css('display', 'block')
		}
		startPos = winScrollTop;
	});
		var click = true

	$('.searchButton').click(function(){
		if(click == true){
			$('.searchformBox .formsearchGOBOx').fadeIn('slow');
			click = false;
		}else if(click == false){
			$('.searchformBox .formsearchGOBOx').fadeOut('slow');
			click = true;
		}
	});
	$.fn.animate2 = function (properties, duration, ease) {
	    ease = ease || 'ease';
	    var $this = this;
	    var cssOrig = { transition: $this.css('transition') };
	    return $this.queue(next => {
	        properties['transition'] = 'all ' + duration + 'ms ' + ease;
	        $this.css(properties);
	        setTimeout(function () {
	            $this.css(cssOrig);
	            next();
	        }, duration);
	    });
	};
	var open_notice_click = false;
	$('#notice-button-open').click(function(){
		if(open_notice_click == false){
			$.ajax({
				url: '/notifications/check_save',
				type: 'POST'
			})
			$('.notification-all-box').css('display', 'block');	
			open_notice_click = true;
		}else{
			$('.notification-all-box').css('display', 'none');	
			open_notice_click = false;
		}

	});
});