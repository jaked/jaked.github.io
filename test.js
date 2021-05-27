
import React from 'https://cdn.skypack.dev/pin/react@v17.0.1-yH0aYV1FOvoIPeKBbHxg/mode=imports/optimized/react.js';
import ReactDOM from 'https://cdn.skypack.dev/pin/react-dom@v17.0.1-N7YTiyGWtBI97HFLtv0f/mode=imports/optimized/react-dom.js';
import Signal from '/__runtime/Signal.js';
import * as Runtime from '/__runtime/Runtime.js';

const __e = (el, props, ...children) => React.createElement(el, props, ...children)

const x = Signal.cellOk(57);
const y = Signal.cellOk("86");

const Range = ({
  value: value,
  onChange: onChange
}) => __e("input", {
  type: "range",
  onChange: e => onChange(e.currentTarget.value),
  value: value
});
ReactDOM.hydrate(Signal.node(Signal.join(Signal.join(x, x).map(() => () => x.map(__v => (x.setOk(__v + 1), __v + 1)).get()), x).map(__v => __e("button", {
  onClick: __v[0]
}, __v[1]))), document.getElementById("__root0"));
ReactDOM.hydrate(Signal.node(x), document.getElementById("__root1"));
ReactDOM.hydrate(Signal.node(Signal.join(y, Signal.join(y).map(() => v => (y.setOk(v), v).get())).map(__v => __e(Range, {
  value: __v[0],
  onChange: __v[1]
}))), document.getElementById("__root2"));
ReactDOM.hydrate(Signal.node(y.map(__v => __e("div", {
  style: {
    fontSize: __v + "px"
  }
}, "foo"))), document.getElementById("__root3"));
