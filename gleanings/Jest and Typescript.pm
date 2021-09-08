{
  version: 2,
  children: [
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'a',
          href: '/index',
          children: [
            {
              text: 'Jake Donham',
            },
          ],
        },
        {
          text: ' > ',
        },
        {
          type: 'a',
          href: '/gleanings/',
          children: [
            {
              text: 'Gleanings',
            },
          ],
        },
        {
          text: '  > Jest and Typescript',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Jest and Typescript',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I've found it difficult to get Jest working smoothly with Typescript. Here are some setups I've tried:",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Ts-jest',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'a',
          href: 'https://kulshekhar.github.io/ts-jest/',
          children: [
            {
              text: 'ts-jest',
              code: true,
            },
          ],
        },
        {
          text: ' is a Jest transformer that runs the actual Typescript compiler. It functions well and (of course) supports all of Typescript. But it can be unacceptably slow on a large project (this seems to be an ',
        },
        {
          type: 'a',
          href: 'https://github.com/kulshekhar/ts-jest/issues/1115',
          children: [
            {
              text: 'ongoing issue',
            },
          ],
        },
        {
          text: "). It's especially frustrating because the standalone Typescript compiler (",
        },
        {
          text: 'tsc --watch',
          code: true,
        },
        {
          text: ') is able to compile the changes quickly, and I have it running all the time anyway.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Esbuild-jest',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'a',
          href: 'https://github.com/aelbore/esbuild-jest',
          children: [
            {
              text: 'esbuild-jest',
              code: true,
            },
          ],
        },
        {
          text: ' is a Jest transformer that calls ',
        },
        {
          type: 'a',
          href: 'https://esbuild.github.io/',
          children: [
            {
              text: 'esbuild',
              code: true,
            },
          ],
        },
        {
          text: '. It is very fast, but it has some ',
        },
        {
          type: 'a',
          href: 'https://github.com/aelbore/esbuild-jest/issues/21',
          children: [
            {
              text: 'weird bugs',
            },
          ],
        },
        {
          text: ", it doesn't seem to return source maps correctly (?), and it doesn't seem to be under active development.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Babel',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The standard way to transform Typescript for Jest is to use ',
        },
        {
          type: 'a',
          href: 'https://jestjs.io/docs/getting-started#using-typescript',
          children: [
            {
              text: 'Babel',
            },
          ],
        },
        {
          text: ". (I can't remember if I tried this.)",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Sucrase',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '',
        },
        {
          type: 'a',
          href: 'https://sucrase.io/',
          children: [
            {
              text: 'sucrase',
              code: true,
            },
          ],
        },
        {
          text: ' is a "super-fast Babel alternative" that can be used as a Jest transformer (?). (I haven\'t tried it.)',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Transformer that returns ',
        },
        {
          text: 'tsc',
          code: true,
        },
        {
          text: '-compiled files',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Here is a transformer I hacked up that returns the corresponding ',
        },
        {
          text: 'tsc',
          code: true,
        },
        {
          text: "-compiled file. It's fast when ",
        },
        {
          text: 'tsc',
          code: true,
        },
        {
          text: ' is fast, but I am not sure how reliable it is. Jest and ',
        },
        {
          text: 'tsc',
          code: true,
        },
        {
          text: ' both watch the filesystem, so ',
        },
        {
          text: 'tsc',
          code: true,
        },
        {
          text: " may not have finished by the time Jest runs the transformer. And I don't know what happens if you change a file that a test depends on—is the transformer called for the test file?",
        },
      ],
    },
    {
      type: 'code',
      language: 'javascript',
      children: [
        {
          text: "const path = require('path');\nconst fs = require('fs');\n\n// we're already running tsc --watch\n// so \"transform\" source for Jest by returning\n// the code compiled by tsc\nmodule.exports = {\n  process(src, fn, config, options) {\n    const bfn = fn.replace(__dirname + '/src', __dirname + '/build');\n    const bfnParts = path.parse(bfn);\n    const jsfn = path.format({ ...bfnParts, base: bfnParts.name + '.js' });\n    const code = fs.readFileSync(jsfn, { encoding: 'utf8' });\n    const map = fs.readFileSync(jsfn + '.map', { encoding: 'utf8' });\n    return { code, map };\n  }\n};",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Put it in a file ',
        },
        {
          text: 'tscTransformer.js',
          code: true,
        },
        {
          text: ' and add the following to ',
        },
        {
          text: 'jest.config.js',
          code: true,
        },
        {
          text: ':',
        },
      ],
    },
    {
      type: 'code',
      language: 'javascript',
      children: [
        {
          text: '  "transform": {\n    "^.+\\\\.tsx?$": [ "./tscTransformer.js" ]\n  },',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Please ',
        },
        {
          type: 'a',
          href: 'mailto:jake@donham.org',
          children: [
            {
              text: 'email me',
            },
          ],
        },
        {
          text: ' with comments, criticisms, or corrections.',
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
  meta: {
    title: 'Jest and Typescript',
    layout: '/layout',
    publish: true,
  },
}
