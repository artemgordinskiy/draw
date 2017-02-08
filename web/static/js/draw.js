import {Socket, Presence} from 'phoenix'

class Draw {
  constructor () {}

  initialize () {
    this.socket = new Socket('/socket', {
      params: {user: 'user' + Math.floor(Math.random() * 999)}}
    );

    this.socket.connect();

    this.channel = this.socket.channel('draw:fake_uuid');

    this.channel.on('point:updated', (point) => {
      console.log("X:" + point.x + ", Y:" + point.y)
    });

    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) });

    document.addEventListener('mousemove', (e) => {
      this.channel.push('point:updated', {
        x: e.pageX,
        y: e.pageY,
        color: '000000'
      });
    });
  }
}

export default Draw
