import consumer from "./consumer"
$(function(){

	const chat = consumer.subscriptions.create({channel: "DeleteChannel", room: $("#messages").data('room_id') }, {
	  connected() {
	    // Called when the subscription is ready for use on the server
	  },

	  disconnected() {
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
	    // Called when there's incoming data on the websocket for this channel
	    $("#message-" + data['id']).remove()

	  },
	  delete: function(id){
	  	return this.perform('delete', {
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
});