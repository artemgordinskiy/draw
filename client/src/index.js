import { Socket } from 'phoenix'
import { default as paper, view, Path, Point } from 'paper'

import './main.css'

function initCanvas (channel) {
  const canvas = document.querySelector('[data-canvas]')
  let myPath;

  paper.setup(canvas)
  paper.view.onMouseDown = event => {
    myPath = new Path({ strokeColor: 'black' })
  }
  paper.view.onMouseDrag = event => {
    console.log(event.point)
    myPath.add(event.point)
    channel.push('point:updated', { ...event.point, color: 'black' })
  }
  channel.on('point:updated', data => {
    const path = new paper.Path({ strokeColor: 'black' })
    const point = new Point(data)
    path.add(point)
  })
}

const user = Date.now()
const socket = new Socket('ws://192.168.2.5:4000/socket', { params: { user } })

socket.connect()
const channel = socket.channel('draw:fake_uuid')
channel.join()
  .receive('ok', res => {
    console.log('Joined', res)
    initCanvas(channel)
  })
  .receive('error', res => { console.log('Joined', res) })
