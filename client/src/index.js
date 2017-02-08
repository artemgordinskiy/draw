import './main.css'
import { default as paper, Path, Point } from 'paper'

const canvas = document.querySelector('[data-canvas]')
let myPath;

paper.setup(canvas)

const path = new Path()
path.strokeColor = 'black'

paper.view.onMouseDown = (event) => {
  myPath = new Path()
  myPath.strokeColor = 'black'
}

paper.view.onMouseDrag = (event) => {
  myPath.add(event.point)
  console.log(event.point.x, event.point.y)
}
