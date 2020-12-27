import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('.notification-all-box').append(data['notification']);
    debugger;
    $('.notification_count-menu').text(data['count'])
    // Called when there's incoming data on the websocket for this channel
  },

  notice: function() {
    return this.perform('notice');
  }
});
