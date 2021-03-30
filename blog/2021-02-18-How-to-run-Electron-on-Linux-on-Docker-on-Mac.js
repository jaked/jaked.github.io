
import React from 'https://cdn.skypack.dev/pin/react@v17.0.1-yH0aYV1FOvoIPeKBbHxg/mode=imports/optimized/react.js';
import ReactDOM from 'https://cdn.skypack.dev/pin/react-dom@v17.0.1-N7YTiyGWtBI97HFLtv0f/mode=imports/optimized/react-dom.js';
import Signal from '/__runtime/Signal.js';
import * as Runtime from '/__runtime/Runtime.js';

const __e = (el, props, ...children) => React.createElement(el, props, ...children)

const Error = msg => __e("div", {
  style: {
    backgroundColor: "#ffc0c0",
    padding: "10px",
    borderRadius: "10px"
  }
}, null, __e("code", {}, msg), null);

