import consumer from "./consumer"
  $(function(){
      const chatChannel = consumer.subscriptions.create({channel: "RoomChannel", room: $('#messages').data('room_id'), current_user: $('#messages').data('current_user') }, {
        connected() {
          // Called when the subscription is ready for use on the server
        },

        disconnected() {
          // Called when the subscription has been terminated by the server
        },

        received(data) {
          // 0.01秒たったら下に移動。
          setTimeout(function(){
            var submitscroll = $('#bottomGO').offset().top;
            document.getElementById('chat_area').value = '';
            $('html, body').scrollTop(submitscroll);
          },10);
          // return $('#messages').append(data['message']);
          // console.log($('#messages').data('current_user'));
          message_go(data['message'], data['message_user_id']);
          message_nil_go(data['message_nil'], data['message_user_id_nil']);
          // Called when there's incoming data on the websocket for this channel
        },

        speak: function(message) {
          return this.perform('speak', {
            message: message
          });
        }
      });

      function message_go(message, user_id){
        if($('#messages').data('current_user') == user_id){
          return $('#messages').append(message);
          return false;
        }
      }
      function message_nil_go(message, user_id){
        if($('#messages').data('current_user') != user_id || user_id == null){
          return $('#messages').append(message);
          // return false;
        }
      }
      $(document).on('keypress submit click', '[data-behavior~=room_speaker]', function(event){
          if(event.target.value == ''){
          }
          function chatgo(){
             chatChannel.speak(event.target.value);
             event.target.value = '';
             return event.preventDefault();
          }
          if(event.shiftKey){
             if(event.keyCode === 13){
                if(event.target.value != ''){
                  chatgo();
                }else if(event.target.value == '' || event.target.length <= 1000 ){
                  event.preventDefault();
                  event.target.value = event.target.value;
                }
             }
           }
         $('#submit').click(function(){
            if(event.target.value != ''){
              chatgo();
            }else if(event.target.value == '' || event.target.length <= 1000 ){
              event.preventDefault();
            }
         });
      });  
  });