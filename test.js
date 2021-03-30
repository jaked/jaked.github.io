
import React from 'https://cdn.skypack.dev/pin/react@v17.0.1-yH0aYV1FOvoIPeKBbHxg/mode=imports/optimized/react.js';
import ReactDOM from 'https://cdn.skypack.dev/pin/react-dom@v17.0.1-N7YTiyGWtBI97HFLtv0f/mode=imports/optimized/react-dom.js';
import Signal from '/__runtime/Signal.js';
import * as Runtime from '/__runtime/Runtime.js';

const __e = (el, props, ...children) => React.createElement(el, props, ...children)

const Ball = ({
  r: r,
  x: x,
  y: y,
  fill: fill
}) => __e("svg", {
  height: r * 2,
  width: r * 2,
  style: {
    position: "fixed",
    top: y - r,
    left: x - r
  }
}, null, __e("ellipse", {
  cx: r,
  cy: r,
  rx: r,
  ry: r,
  fill: fill
}), null);

const theta = Runtime.now.map(now => now / 500 % (2 * Math.PI));
ReactDOM.hydrate(Signal.node(Signal.join(Runtime.mouse, theta).map(([mouse, theta]) => __e(Ball, {
  r: 25,
  x: mouse.clientX + Math.cos(theta) * 50,
  y: mouse.clientY + Math.sin(theta) * 50,
  fill: "pink"
}))), document.getElementById("__root0"));
