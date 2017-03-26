import {Socket, Presence} from 'phoenix'
import { default as paper, view, Path, Point, Size } from 'paper'

class Draw {
  constructor () {
    this.config = window.DRAW_CONFIG || {};
    this.drawing_id = this.config.drawing_id;

    if (!this.drawing_id) {
      throw new Error('Missing a drawing ID');
    }
  }

  initialize () {
    this.canvas = document.querySelector('[data-canvas]');
    let path;

    this.socket = new Socket('/socket', {params: {}});

    this.socket.connect();

    this.channel = this.socket.channel('draw:' + this.drawing_id);

    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) });

    paper.setup(this.canvas)
    paper.view.onMouseDown = event => {
      path = new Path({ strokeColor: 'black' })
    };

    paper.view.onMouseDrag = event => {
      path.add(event.point);
      this.channel.push(
        'point:updated',
        {
           x: event.point.x,
           y: event.point.y,
           color: '#000000'
        }
      )
    };

    this.channel.on('point:updated', data => {
      let path = new Path({ strokeColor: data.color });
      let point = new Point(data.x, data.y);
      path.add(point);
    })
  }
}

export default Draw
