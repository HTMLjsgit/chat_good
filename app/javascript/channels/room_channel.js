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

          // return $('#messages').append(data['message']);
          // console.log($('#messages').data('current_user'));
          message_go(data['message'], data['message_user_id']);
          message_nil_go(data['message_nil'], data['message_user_id_nil']);
          message_reply_create(data['message_create_id'], data['create_reply'])
          reply_message_go(data['render_message_admin'], data['bot'], data['message_id'], data['user_id']);
          reply_message_nil_go(data['message_reply_nil'], data['bot'], data['message_id'], data['user_id']);
          setTimeout(function(){
            var submitscroll = $('#bottomGO').offset().top;
            document.getElementById('chat_area').value = '';
            $('html, body').scrollTop(submitscroll);
          },10);
          // Called when there's incoming data on the websocket for this channel
        },

        speak: function(message) {
          return this.perform('speak', {
            message: message
          });
        },
        reply: function(message, message_id){
          return this.perform('reply', {
            message: message,
            message_id: message_id
          })
        }
      });

      function message_go(message, user_id){
        if($('#messages').data('current_user') == user_id){
          return $('#messages').append(message);

        }
      }
      function message_reply_create(id, message_reply){
        if($('#messages').data('current_user') != null){
          $(`#message-reply-create-${id}`).html(message_reply);
        }
      }
      function message_nil_go(message, user_id){
        if($('#messages').data('current_user') != user_id || user_id == null){
          return $('#messages').append(message);
        }
      }
      function reply_message_go(message, bot, id, user_id){
        if($('#messages').data('current_user') == user_id){
          if(bot == true){
            $('#chat_area-' + id).val('');
            $(`#message-form-${id}-button`).click();

            return $(`#message-support-${id}`).append(message);

          }else{
            $('#chat_area-' + id).val('');
            $(`#message-form-${id}-button`).click();
            return $(`#message-support-${id}`).append(message);
          }
        }
      }
      function reply_message_nil_go(message, bot, id, user_id){
        if($("#messages").data('current_user') != user_id || user_id == null){
          if(bot == true){
            $('#chat_area-' + id).val('');
            return $(`#message-support-${id}`).append(message);
          }else{
            $('#chat_area-' + id).val('');
            return $(`#message-support-${id}`).append(message);
          }
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
      $(document).on('keypress submit click', '[data-behavior~=message_reply_speaker]', function(event){
        if(event.shiftKey){
          if(event.keyCode === 13){
            var id_go = event.target.id.replace("chat_area-", "");
            chatChannel.reply(event.target.value, id_go);
          }
        }
      });

  });