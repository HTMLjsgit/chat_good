import consumer from "./consumer"
$(function(){

	const chat = consumer.subscriptions.create({channel: "DeleteChannel", room: $("#messages").data('room_id'), current_user: $('#messages').data('current_user') }, {
	  connected() {
	    // Called when the subscription is ready for use on the server
	  },

	  disconnected() {
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
	    // Called when there's incoming data on the websocket for this channel
	    if($('#messages').data('current_user') == data['user_id'] && data['message_reply'] == false){
	    	$("#message-support-" + data['id']).remove();
	    }else if($("#messages").data('current_user') == data['user_id'] && data['message_reply'] == true){
	    	$('#message_reply-support-' + data['id']).remove();
	    }
	  },
	  delete: function(id){
	  	return this.perform('delete', {
	  		id: id
	  	})
	  },
	  delete_reply: function(id){
	  	return this.perform('delete_reply', {
	  		id: id
	  	})
	  }
	});

	$(document).on('click', '.delete_btn', function(event){
		if(window.confirm("本当に削除しますか？")){
			chat.delete(event.target.id);

		}else{
			return false;
		}

	});
	$(document).on('click', '.delete_btn_reply', function(event){
		if(window.confirm("本当に削除しますか？")){
			chat.delete_reply(event.target.dataset.id);
		}else{
			return false;
		}
	});
});