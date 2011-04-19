$(function(){

	var $cmd = $("input[name=cmd]");
	var updateMessages = function(){
		$.getJSON('/messages', function(data){
			var $messages = $('#messages'), $div = $('.messages');
			$messages.text('');
			$(data).each(function(){
				$messages.append('<li>' + this + '</li>');
				$div.scrollTop(50000);
			});
		});
	};
	
	$("form#command").submit(function(){
		var command = $cmd.val();$cmd.val('');
		$("input[name=cmd]").focus();
		$.post('/command', {cmd:command});
		return false;
	});
	$("input[name=cmd]").focus();
	setInterval(updateMessages, 500);

});