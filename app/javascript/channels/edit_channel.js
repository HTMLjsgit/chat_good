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
	    if (data['message'] != null){
	    	$('#message-support-' + data['id']).html(data['message']);
	    }
	    message_go(data['message'], data['message_user_id'], data['id']);
        message_nil_go(data['message_nil'], data['message_user_id_nil'], data['id']);
	    // Called when there's incoming data on the websocket for this channel
	  },

	  edit: function(id, message) {
	    return this.perform('edit', {
	    	id: id,
	    	message: message
	    });
	  }
	});
      function message_go(message, user_id, id){
        if($('#messages').data('current_user') == user_id){
	    	$('#message-support-' + id).html(message);
	    	$('#edit_form_box_' + id).fadeOut('slow');
        }
      }
      function message_nil_go(message, user_id, id){
        if($('#messages').data('current_user') != user_id || user_id == null){
	    	$('#message-support-' + id).html(message);
	    	$('#edit_form_box_' + id).fadeOut('slow');
	    	
        }
      }
	$(document).on('keypress','[data-behavior~=edit_speaker]', function(event){
		if(event.shiftKey){
	      if(event.keyCode === 13){
	      	if(event.target.value == '' || event.target.id == ''){
				return false;
			}
			chat.edit(event.target.id, event.target.value);
			return event.preventDefault();
		  }
		}
	});
});