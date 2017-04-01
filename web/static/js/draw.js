import {Socket, Presence} from 'phoenix'
import { default as paper, view, Path, Point, Size } from 'paper'

class Draw {
  constructor () {
    this.config = window.DRAW_CONFIG || {};
    this.drawing_id = this.config.drawing_id;
    this.current_path = null;
    this.current_color = '#000000';
    this.remote_paths = {};

    if (!this.drawing_id) {
      throw new Error('Missing a drawing ID');
    }
  }

  initialize () {
    this.canvas = document.querySelector('[data-canvas]');

    this.socket = new Socket('/socket', {params: {}});

    this.socket.connect();

    this.channel = this.socket.channel('draw:' + this.drawing_id);

    this.channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) });

    paper.setup(this.canvas);

    paper.view.onMouseDown = event => {
      this.current_path = new Path({ strokeColor: this.current_color });
      this.current_path.add(event.point);

      this.channel.push(
        'path:started',
        {
          x: event.point.x,
          y: event.point.y,
          color: this.current_color
        }
      )
    };

    paper.view.onMouseUp = () => {
      const path_starting_point = this.current_path.getFirstSegment()._point;

      this.channel.push(
        'path:ended',
        {
          x: path_starting_point._x,
          y: path_starting_point._y
        }
      );
      this.current_path = null;
    };

    paper.view.onMouseDrag = event => {
      this.current_path.add(event.point);

      const path_starting_point = this.current_path.getFirstSegment()._point;
      this.channel.push(
        'path:point-added',
        {
           x: event.point.x,
           y: event.point.y,
           path: {
             x: path_starting_point._x,
             y: path_starting_point._y,
           }
        }
      )
    };

    this.channel.on('path:started', data => {
      let path = new Path({ strokeColor: data.color });
      let point = new Point(data.x, data.y);

      path.add(point);
      this.addRemotePath(data.x, data.y, path);
    });

    this.channel.on('path:point-added', data => {
      let path = this.getRemotePath(data.path.x, data.path.y);

      if (!path) {
        throw new Error('Remote path for received update does not exist');
      }

      let point = new Point(data.x, data.y);
      path.add(point);
    });

    this.channel.on('path:ended', data => {
      let path = this.getRemotePath(data.x, data.y);

      if (!path) {
        throw new Error('Remote ended path not found locally')
      }

      this.deleteRemotePath(data.x, data.y);
    });
  }

  addRemotePath (x, y, path) {
    if (this.getRemotePath(x, y)) {
      throw new Error('Path already exists');
    }

    this.remote_paths[x] = this.remote_paths[x] || {};
    this.remote_paths[x][y] = path;
  }

  getRemotePath (x, y) {
    if (typeof this.remote_paths[x] !== 'object') {
      return null;
    }

    if (typeof this.remote_paths[x][y] !== 'object') {
      return null;
    }

    return this.remote_paths[x][y];
  }

  deleteRemotePath (x, y) {
    if (!this.getRemotePath(x, y)) {
      throw new Error('There is no path at specified coordinates');
    }

    this.remote_paths[x][y] = null;
  }
}

export default Draw
