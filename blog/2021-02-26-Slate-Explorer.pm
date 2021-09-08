{
  version: 2,
  children: [
    {
      type: 'liveCode',
      children: [
        {
          text: "import SlateExplorer from './Slate-Explorer'",
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
          href: '/blog/index',
          children: [
            {
              text: 'Technical Difficulties',
            },
          ],
        },
        {
          text: ' > Slate Explorer',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Slate Explorer, a tool for exploring the Slate API',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-02-26',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I have been programming for a pretty long time—let's just say that ",
        },
        {
          type: 'a',
          href: 'https://en.wikipedia.org/wiki/Atari_8-bit_family#/media/File:Atari-400-Comp.jpg',
          children: [
            {
              text: 'this',
            },
          ],
        },
        {
          text: " is not an unfamiliar object. Insofar as I've gotten better at it in that time, it's been a byproduct of doing programming (for work and for fun); but I never set myself a goal to improve, or thought about ",
        },
        {
          text: 'how',
          italic: true,
        },
        {
          text: ' to improve. Now at the ',
        },
        {
          type: 'a',
          href: '/blog/2021-02-12-Recurse-Center',
          children: [
            {
              text: 'Recurse Center',
            },
          ],
        },
        {
          text: " I'm surrounded by people who are focused on becoming better programmers, so I've been thinking about what that means for me.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "One thing I noticed about myself is that I often do things the hard way: type something out rather than copy and paste; manually change several occurrences rather than use search and replace or multicursor; retype the same commands at a shell or REPL rather than make a script or build a tool. It's a weird form of laziness—do more work to avoid the work needed to do less work—but I think it makes psychological sense: Breaking out of a groove takes mental effort; and it can feel risky if you're anxious about keeping focus. It's often not clear that the \"easier\" way will turn out to be easier in the end.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I think this is a way I could improve: try to notice when I'm doing things the hard way, and push myself a little more to stop and figure out an easier way. (This doesn't always pay off! But I think I err on the side of doing it too little, for psychological reasons.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now I want to talk about a tool I made to make things easier for myself, but first some background about',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Slate',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/programmable-matter',
          children: [
            {
              text: 'Programmable Matter',
            },
          ],
        },
        {
          text: " I'm using a framework for building rich-text editors called ",
        },
        {
          type: 'a',
          href: 'https://www.slatejs.org/',
          children: [
            {
              text: 'Slate',
            },
          ],
        },
        {
          text: ". It is very cool! The basic idea is that editor state is represented as a tree, the UI is rendered from the tree (using React), and actions in the UI are expressed as tree manipulations. You can write most of your editor code in terms of trees, without thinking about the concrete UI. In particular it's really easy to write tests: Slate comes with a library for writing editor state as a ",
        },
        {
          type: 'a',
          href: 'https://reactjs.org/docs/introducing-jsx.html',
          children: [
            {
              text: 'JSX expression',
            },
          ],
        },
        {
          text: ', like so:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '<editor>\n  <h1>Text</h1>\n  <ul>\n    <li><anchor/>plain<focus/>; or</li>\n    <li><text bold="true">bold</text>; or\n    </li>\n    <li><text italic="true">italic</text>\n    </li>\n  </ul>\n</editor>',
        },
      ],
      language: 'markup',
    },
    {
      type: 'p',
      children: [
        {
          text: "You can write a test for an editor action by giving an initial editor state, performing the action (manipulating the tree), then comparing the result to an expected final editor state. This is very compact and doesn't deal with the concrete UI at all. Nice!",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Slate is very flexible about what trees look like, so in this example the ',
        },
        {
          text: 'editor',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'text',
          code: true,
        },
        {
          text: ' nodes are built in, but ',
        },
        {
          text: 'h1',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'ul',
          code: true,
        },
        {
          text: ', and ',
        },
        {
          text: 'li',
          code: true,
        },
        {
          text: " are application-specific. The application can render them as HTML, but that's not predefined; you're free to use whatever nodes you like and render them however you like. The ",
        },
        {
          text: 'anchor',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'focus',
          code: true,
        },
        {
          text: ' nodes represent the endpoints of the selected region (so here the word "plain" is selected). Managing the selection is really important for making a usable editor: actions should apply in a sensible way to the current selection, and after an action the selection should be left in a sensible place. So having an easy way to write tests for it is hugely useful.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "There's a lot more to say about Slate but I will save it for a future post; let's move on to",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Understanding the Slate API',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Slate is amazing, but there are some wrinkles: the API is pretty complicated, it's not very well-documented, and I've run across several confusing bugs. For example, here is the signature of a function that splits nodes:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "Transforms.splitNodes: (\n  editor: Editor,\n  options?: {\n    at?: Location\n    match?: (node: Node, path: Path) => boolean\n    mode?: 'highest' | 'lowest'\n    always?: boolean\n    height?: number\n    voids?: boolean\n  }\n) => void",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'The ',
        },
        {
          type: 'a',
          href: 'https://docs.slatejs.org/api/transforms#transforms-splitnodes-editor-editor-options',
          children: [
            {
              text: 'documentation',
            },
          ],
        },
        {
          text: " is thin; it's hard to know what these arguments do and how they interact. Here are some ways I have tried to understand it:",
        },
      ],
    },
    {
      type: 'ul',
      children: [
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'Read the code',
                  bold: true,
                },
                {
                  text: ". I find this is a good approach when I'm trying to understand a specific bug (in my code or in Slate) but it's hard to get a general sense of what a function is supposed to do. It is a lot of work, and I tend to forget the details I learned pretty quickly.",
                },
              ],
            },
          ],
        },
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'Write a test',
                  bold: true,
                },
                {
                  text: ". This is useful when I have a specific hypothesis about how something works: I can write a test and confirm or refute the hypothesis. It's easy to get started, since I already have a file of tests set up and I can usually cut and paste to get started; and it's a useful as a way to capture my understanding, since the tests are part of my project code. But it's hard to get a general sense without writing dozens of tests, and sometimes writing and running a test feels like a lot of overhead.",
                },
              ],
            },
          ],
        },
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'Experiment in the console',
                  bold: true,
                },
                {
                  text: '. ',
                },
                {
                  text: 'require',
                  code: true,
                },
                {
                  text: " the Slate module, make an editor, populate it with some nodes, try some API calls, see what happens. It's a little bit painful to get started, but it's easy to try lots of things quickly (compared to setting up a bunch of tests) to get a general sense. Working in the console is a pain: there's no JSX, so I construct trees manually, and inspect them with ",
                },
                {
                  text: 'JSON.stringify',
                  code: true,
                },
                {
                  text: ". It's hard to match up the selection with where it goes in the tree. When I'm doing this I often feel like I should figure out a better way.",
                },
              ],
            },
          ],
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To make things easier for myself, I decided that I would spend some time making a tool to explore the Slate API, called',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Slate Explorer',
        },
      ],
    },
    {
      type: 'liveCode',
      children: [
        {
          text: '<SlateExplorer />',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The box at the upper left is a Slate editor widget. It is basically the stock editor; I added rendering for a few HTML tags (',
        },
        {
          text: 'h1',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'h2',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'h3',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'p',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'ul',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'li',
          code: true,
        },
        {
          text: '), and text styles (',
        },
        {
          text: 'bold',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'italic',
          code: true,
        },
        {
          text: "), but didn't customize the editing behavior at all. So there is no UI for setting text styles or inserting headers or lists.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "The box at the upper right is an XML rendering of the editor state; as you edit or move the selection in the Slate editor you'll see updates to the state. You can also edit the XML, and changes will be reflected back to the Slate editor. You can add the supported HTML tags by editing the XML. (I'm using a stock XML parser here, and XML is not exactly JSX: you can't embed Javascript expressions in curly braces, so use e.g. ",
        },
        {
          text: "bold='true'",
          code: true,
        },
        {
          text: ' rather than ',
        },
        {
          text: 'bold={true}',
          code: true,
        },
        {
          text: '; and the whitespace handling is slightly different, to avoid losing whitespace in the editor state when going Slate -> XML -> Slate.)',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The box in the middle contains arbitrary Javascript, with ',
        },
        {
          text: 'editor',
          code: true,
        },
        {
          text: ' and some Slate modules (',
        },
        {
          text: 'Editor',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'Element',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'Node',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'Path',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'Range',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'Text',
          code: true,
        },
        {
          text: ', and ',
        },
        {
          text: 'Transforms',
          code: true,
        },
        {
          text: ') available in the environment. Put whatever you like here to transform the editor state. The boxes at the bottom show the result of the transformation, rendered by Slate and as XML.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We can see in the example that calling ',
        },
        {
          text: 'splitNodes(editor)',
          code: true,
        },
        {
          text: ' with no options splits the innermost node at the cursor position, and leaves the cursor at the beginning of the new node. Some other things to try:',
        },
      ],
    },
    {
      type: 'ul',
      children: [
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'what happens if a range of text is selected? (surprising but OK)',
                },
              ],
            },
          ],
        },
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'what does ',
                },
                {
                  text: "mode: 'highest'",
                  code: true,
                },
                {
                  text: ' do? (makes sense)',
                },
              ],
            },
          ],
        },
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'if you give a location to split at, e.g. ',
                },
                {
                  text: 'at: { path: [1, 0, 0], offset: 3 }',
                  code: true,
                },
                {
                  text: ', what happens to the selection? (nice)',
                },
              ],
            },
          ],
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'You can try Slate Explorer ',
        },
        {
          type: 'a',
          href: 'https://slate-explorer.glitch.me/',
          children: [
            {
              text: 'here',
            },
          ],
        },
        {
          text: ', and see the code ',
        },
        {
          type: 'a',
          href: 'https://glitch.com/edit/#!/slate-explorer',
          children: [
            {
              text: 'here',
            },
          ],
        },
        {
          text: '. Take a look at the ',
        },
        {
          type: 'a',
          href: 'https://docs.slatejs.org/',
          children: [
            {
              text: 'Slate docs',
            },
          ],
        },
        {
          text: ' for functions to explore, especially the ',
        },
        {
          type: 'a',
          href: 'https://docs.slatejs.org/concepts/06-editor',
          children: [
            {
              text: 'Editor',
            },
          ],
        },
        {
          text: ' interface and ',
        },
        {
          type: 'a',
          href: 'https://docs.slatejs.org/api/transforms',
          children: [
            {
              text: 'Transforms',
            },
          ],
        },
        {
          text: '.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Did it pay off?',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'HARD YES!',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I spent about 3 days building Slate Explorer, which might seem like a lot for an ad-hoc tool, but I have definitely burned days trying to understand the Slate API in the more arduous ways above. (Also I polished it more than I might have for a personal tool, because I want to show it to RC and Slate people.) I learned about CSS grid layout along the way, so that's a bonus.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I don't think I will ever experiment with Slate in the console again; it's now very easy to set up editor state and try a bunch of API calls. I will probably write more Slate tests (I use them in part to capture bugs and surprising behavior), and I can now repro them in Slate Explorer then copy the editor state into a test. I will certainly read the Slate code again, and it will be really helpful to use Slate Explorer for support.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Here I want to call out ',
        },
        {
          type: 'a',
          href: 'https://astexplorer.net/',
          children: [
            {
              text: 'AST Explorer',
            },
          ],
        },
        {
          text: ', a great tool for seeing the parse trees that result from various parsers, which I have used a ton while working on Programmable Matter, and which inspired the name Slate Explorer. Figuring out parse trees is another thing I used to burn a lot of time doing in the console. I hope that people building on Slate will find Slate Explorer as useful.',
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
  ],
  meta: {
    title: 'Slate Explorer, a tool for exploring the Slate API',
    publish: true,
    layout: '/layout',
  },
}