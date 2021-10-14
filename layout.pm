{
  version: 2,
  children: [
    {
      type: 'liveCode',
      children: [
        {
          text: 'export default (props: {\n  children: React.ReactNode[],\n  meta: {\n    name: string | undefined,\n    title: string | undefined,\n    description: string | undefined\n  }\n}) =>\n  <html>\n    <head>\n      <title>{props.meta.title}</title>\n<meta name="twitter:card" content="summary" />\n<meta name="twitter:site" content="@jakedonham" />\n<meta name="twitter:creator" content="@jakedonham" />\n{props.meta.title &&\n  <meta name="twitter:title" content={props.meta.title} />}\n{props.meta.title &&\n  <meta name="twitter:description" content={props.meta.title} />}\n\n<style dangerouslySetInnerHTML={{__html:`\nbody {\n  background-color: #eeeeee;\n}\n.content {\n  background-color: white;\n  padding-top: 80px;\n  padding-bottom: 80px;\n  padding-left: 120px;\n  padding-right: 120px;\n  margin-left: auto;\n  margin-right: auto;\n  max-width: 700px\n}\nblockquote { margin-block-end: 2em }\np, ul { font-family: serif; font-size: 19px; line-height: 26px }\ncode { font-family: monospace; font-size: 14px; }\npre { font-family: monospace; font-size: 14px; }\nh1, h2, h3, h4, h5, h6 { font-family: sans-serif }\na:link { text-decoration: none; }\na:visited { color: blue }\na:hover {\n  background-color: #eeeeee;\n}\nhr { border-style: solid }\n`}} />\n    { props.meta.name === \'/blog/index\' &&\n      <link\n        rel="alternate"\n        href="/blog/rss.xml"\n        type="application/rss+xml"\n        title="Technical Difficulties"\n      />\n    }\n    </head>\n    <body>\n      <div className=\'content\'>\n        {props.children}\n      </div>\n    </body>\n  </html>',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
      ],
    },
  ],
  meta: {},
}