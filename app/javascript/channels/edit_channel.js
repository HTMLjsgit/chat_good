import consumer from "./consumer"
$(function(){
	var chat = consumer.subscriptions.create({channel: "EditChannel", room: $("#messages").data('room_id'), current_user: $('#messages').data('current_user') }, {
	  connected() {
	    // Called when the subscription is ready for use on the server
	  },

	  disconnected() {
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
	  	// $(`#message-99`).html(data['message'])
	  	// data['id']がしゅとくできないから　⇃　が　うまくいかない。　data['id']がundefinedになります。
	  	if(!data['message_reply']){
		    message_go(data['message'], data['message_user_id'], data['id']);
	        message_nil_go(data['message_nil'], data['message_user_id_nil'], data['id']);
	    }else{
			message_reply_go(data['render_message'], data['reply_message_user_id'], data['id']);
		    message_reply_nil_go(data['render_nil_message'], data['reply_message_user_id'], data['id']);
	    }
		    
	    
	    // Called when there's incoming data on the websocket for this channel
	  },

	  edit: function(id, message) {
	    return this.perform('edit', {
	    	id: id,
	    	message: message
	    });
	  },
	  reply_edit: function(id, message){
	  	return this.perform('edit_reply', {
	  		id: id,
	  		message: message
	  	});
	  }
	});
      function message_go(message, user_id, id){
        if($('#messages').data('current_user') == user_id){
	    	$('#message-support-' + id).html(message);

        }
      }
      function message_nil_go(message, user_id, id){
        if($('#messages').data('current_user') != user_id || user_id == null){
	    	$('#message-support-' + id).html(message);

        }
      }
      function message_reply_go(message, user_id, id){
      	if($("#messages").data('current_user') == user_id){
      		$('#message_reply-support-' + id).html(message);
  		    $('#edit_click-' + id).click();
      	}
      }
      function message_reply_nil_go(message, user_id, id){
      	if($("#messages").data('current_user') != user_id || user_id == null){
      		$('#message_reply-support-' + id).html(message);
  		    $('#edit_click-' + id).click();

      	}
      }

	$(document).on('keypress', '[data-behavior~=edit_speaker]', function(event){
	  if(event.shiftKey){
	    if(event.keyCode === 13){
	      if(event.target.value == '' || event.target.id == ''){
			return false;
		  }
			chat.edit(event.target.id.replace(/message_edit_/, ""), event.target.value);
			return event.preventDefault();
		}
	  }
	});
	$(document).on('keypress', '[data-behavior~=edit_reply_speaker]', function(event){
	  if(event.shiftKey){
	    if(event.keyCode === 13){
	      if(event.target.value == '' || event.target.id == ''){
			return false;
		  }
			chat.reply_edit(event.target.id.replace(/message_edit_reply-/, ""), event.target.value);
			return event.preventDefault();
		}
	  }
	});
});