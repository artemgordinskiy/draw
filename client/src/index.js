import { Socket } from 'phoenix'
import { default as paper, view, Path, Point } from 'paper'
import './main.css'

function initCanvas (channel) {
  const canvas = document.querySelector('[data-canvas]')
  let myPath;

  paper.setup(canvas)
  paper.view.onMouseDown = event => {
    myPath = new Path()
    myPath.strokeColor = 'black'
  }
  paper.view.onMouseDrag = event => {
    myPath.add(event.point)
    channel.push('point:updated', { ...event.point, color: 'black' })
  }
}

const params = { user: 1 }
const socket = new Socket('ws://192.168.2.5:4000/socket', { params })

socket.connect()
const channel = socket.channel('draw:fake_uuid')
channel.on('point:updated', payload => {
  console.log(payload.body)
})
channel.join()
  .receive('ok', res => {
    console.log('Joined', res)
    initCanvas(channel)
  })
  .receive('error', res => { console.log('Joined', res) })
