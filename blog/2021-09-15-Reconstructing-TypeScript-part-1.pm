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
          href: '/blog/index',
          children: [
            {
              text: 'Technical Difficulties',
            },
          ],
        },
        {
          text: ' > Reconstructing TypeScript, part 1',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Reconstructing TypeScript, part 1: bidirectional type checking',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-09-15',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'This post is part of a series about implementing type checking for a TypeScript-like language. In the ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0',
          children: [
            {
              text: 'last post ',
            },
          ],
        },
        {
          text: " I gave some background about type checking, TypeScript's type system, and the approach we'll use, called ",
        },
        {
          text: 'bidirectional type checking',
          italic: true,
        },
        {
          text: '.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Now let's write a type checker! We're going to start with a tiny fragment of the language, and build it up incrementally in subsequent posts. In this fragment we'll handle only primitive literals like",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '7\n"TypeScript is cool."\nfalse',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'object literals like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: 7, y: 9 }\n{ foo: "bar", baz: false }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and member expressions like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: 7, y: 9 }.x',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "(We don't have variables yet, so member expressions look a little weird!)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "We'll also handle ",
        },
        {
          text: 'type ascriptions',
          italic: true,
        },
        {
          text: ' like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: 7, y: "foo" } as { x: number, y: number }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'In actual TypeScript, ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: ' is an unsafe cast, a way to tell the type checker, "trust me, this expression has this type!" Here it is a way to guide the type checker (more on this below), but it\'s not unsafe—the type checker still ensures that the program doesn\'t attempt any unsupported operations.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Parsing code into an abstract syntax tree',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Recall from ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0',
          children: [
            {
              text: 'part 0',
            },
          ],
        },
        {
          text: ' that type checking works on an ',
        },
        {
          text: 'abstract syntax tree',
          italic: true,
        },
        {
          text: ' representation of code, where each expression in a program is a node in the tree, with its subexpressions as children. So first we need to parse code strings to ASTs. We use ',
        },
        {
          type: 'a',
          href: 'https://babeljs.io/docs/en/babel-parser',
          children: [
            {
              text: '@babel/parser',
            },
          ],
        },
        {
          text: ' with the TypeScript plugin (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/ast/parse.ts',
          children: [
            {
              text: 'parse.ts',
            },
          ],
        },
        {
          text: '):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function parseExpression(input: string): Expression {\n  return Babel.parseExpression(input, {\n    plugins: [ 'typescript' ]\n  });\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'which produces a value of type ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L2058',
          children: [
            {
              text: 'Expression',
              code: true,
            },
          ],
        },
        {
          text: ' from ',
        },
        {
          type: 'a',
          href: 'https://babeljs.io/docs/en/babel-types',
          children: [
            {
              text: '@babel/types',
            },
          ],
        },
        {
          text: '. For example, if we call ',
        },
        {
          text: 'parseExpression',
          code: true,
        },
        {
          text: ' on an object expression',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: 7, y: 9 }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'we get an ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L611',
          children: [
            {
              text: 'ObjectExpression',
              code: true,
            },
          ],
        },
        {
          text: ' AST with ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L634',
          children: [
            {
              text: 'ObjectProperty',
              code: true,
            },
          ],
        },
        {
          text: ' ASTs as children:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{\n  type: "ObjectExpression",\n  properties: [\n    {\n      type: "ObjectProperty",\n      key: { type: "Identifier", name: "x" },\n      value: { type: "NumericLiteral", value: 7 }\n    },\n    {\n      type: "ObjectProperty",\n      key: { type: "Identifier", name: "y" },\n      value: { type: "NumericLiteral", value: 9 }\n    }\n  ]\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Each node has a ',
        },
        {
          text: 'type',
          code: true,
        },
        {
          text: " property saying what kind of syntax it represents, and each kind of node has kind-specific properties for subexpressions and other attributes. (I've trimmed out properties that describe the location of each AST node in the original code string.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To keep things simple, our type checker will handle only expressions, like:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '"TypeScript is cool"\n{ x: 7, y: 9 }\nx > 0 ? x : -x',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'not statements, like:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const x = 7\nfor (let i = 0; i < 10; i++) { ... }\nthrow new Error("bad thing")',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "so we only need to parse expressions. (We'll also parse types, see below.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The full ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L2058',
          children: [
            {
              text: 'Expression',
              code: true,
            },
          ],
        },
        {
          text: " type is pretty complicated, and it's not always obvious what the different properties mean. So it's really helpful to be able to browse the AST produced by a piece of code. I use the excellent ",
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
          text: ' for this. (Set the language to ',
        },
        {
          text: 'JavaScript',
          code: true,
        },
        {
          text: ' and the parser to ',
        },
        {
          text: '@babel/parser.',
          code: true,
        },
        {
          text: ' Then click the gear icon next to ',
        },
        {
          text: '@babel/parser',
          code: true,
        },
        {
          text: ', enable the ',
        },
        {
          text: 'typescript',
          code: true,
        },
        {
          text: ' plugin, and disable the ',
        },
        {
          text: 'flow',
          code: true,
        },
        {
          text: ' plugin.)',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Be aware that AST Explorer parses programs, not expressions; so if you feed it an expression, the AST is wrapped in ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L602',
          children: [
            {
              text: 'Program',
              code: true,
            },
          ],
        },
        {
          text: ' and ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L455',
          children: [
            {
              text: 'ExpressionStatement',
              code: true,
            },
          ],
        },
        {
          text: " nodes. Usually it's OK to write an expression where a statement is expected, but for object expressions you need to wrap parentheses around them, or else the parser sees ",
        },
        {
          text: '{',
          code: true,
        },
        {
          text: ' and tries to parse a block of statements.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Representing types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To synthesize and check types, we need a way to represent them. In this fragment we support only a few types—primitive literals, and objects made up of properties (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/type/types.ts',
          children: [
            {
              text: 'types.ts',
            },
          ],
        },
        {
          text: '):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "type Type = Null | Boolean | Number | String | Object;\n\ntype Null = { type: 'Null'; }\ntype Boolean = { type: 'Boolean'; }\ntype Number = { type: 'Number'; }\ntype String = { type: 'String'; }\n\ntype Object = {\n  type: 'Object';\n  properties: { name: string, type: Type }[];\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'For example, the type',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: number, y: number }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'is represented by the value',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "{\n  type: 'Object',\n  properties: [\n    { name: 'x', type: { type: 'Number' } },\n    { name: 'y', type: { type: 'Number' } }\n  ]\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Constructors',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We have predefined constants and helper functions to construct types (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/type/constructors.ts',
          children: [
            {
              text: 'constructors.ts',
            },
          ],
        },
        {
          text: '):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "const nullType: Null = { type: 'Null' };\nconst boolean: Boolean = { type: 'Boolean' };\nconst number: Number = { type: 'Number' };\nconst string: String = { type: 'String' };",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "The properties of an object type are represented as an array, but it's often convenient to construct object types by passing an object mapping names to types, like:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const type = object({ x: number, y: number });',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'so the ',
        },
        {
          text: 'object',
          code: true,
        },
        {
          text: ' constructor takes either an array of properties or an object mapping names to types:',
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: "function object(\n  properties: { name: string, type: Type }[] | { [name: string]: Type }\n): Object {\n  if (Array.isArray(properties)) {\n    return { type: 'Object', properties }\n  } else {\n    return object(\n      Object.entries(properties).map(([ name, type ]) => ({ name, type }))\n    );\n  }\n}",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'This is a nice example of the flexibility of union types: rather than define a separate function to convert an object argument to an array, we give the argument a union type. If ',
        },
        {
          text: 'Array.isArray(properties)',
          code: true,
        },
        {
          text: ' is true, we know from the argument type that ',
        },
        {
          text: 'properties',
          code: true,
        },
        {
          text: ' must be an array of ',
        },
        {
          text: '{ name: string, type: Type }',
          code: true,
        },
        {
          text: ' objects, so we can directly construct an ',
        },
        {
          text: 'Object',
          code: true,
        },
        {
          text: ' type. Otherwise it must be an object mapping property names to ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: 's, so we walk the object entries to build an array.',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Validators',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We have validators for distinguishing different kinds of ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/type/validators.ts',
          children: [
            {
              text: 'validators.ts',
            },
          ],
        },
        {
          text: '):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function isNull(t: Type): t is Null       { return t.type === 'Null'; }\nfunction isBoolean(t: Type): t is Boolean { return t.type === 'Boolean'; }\nfunction isNumber(t: Type): t is Number   { return t.type === 'Number'; }\nfunction isString(t: Type): t is String   { return t.type === 'String'; }\nfunction isObject(t: Type): t is Object   { return t.type === 'Object'; }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'The return type ',
        },
        {
          text: 't is Null',
          code: true,
        },
        {
          text: ' (for example) is a ',
        },
        {
          type: 'a',
          href: 'https://www.typescriptlang.org/docs/handbook/2/narrowing.html#using-type-predicates',
          children: [
            {
              text: 'type predicate',
            },
          ],
        },
        {
          text: '; when a call to the validator returns ',
        },
        {
          text: 'true',
          code: true,
        },
        {
          text: ', the type checker narrows ',
        },
        {
          text: 't',
          code: true,
        },
        {
          text: ' to type ',
        },
        {
          text: 'Null',
          code: true,
        },
        {
          text: ', just as it would have if the test ',
        },
        {
          text: 't.type === Null',
          code: true,
        },
        {
          text: ' had appeared directly in the code.',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Type module',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We wrap these types, constructors, validators, and other type-related functions into a module (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/type/index.ts',
          children: [
            {
              text: 'type/index.ts',
            },
          ],
        },
        {
          text: ') so we can write ',
        },
        {
          text: 'Type.Boolean',
          code: true,
        },
        {
          text: ' (the type), ',
        },
        {
          text: 'Type.boolean ',
          code: true,
        },
        {
          text: '(the constructor), ',
        },
        {
          code: true,
          text: 'Type.object({ ... })',
        },
        {
          text: ', ',
        },
        {
          text: 'Type.isObject',
          code: true,
        },
        {
          text: ', ',
        },
        {
          code: true,
          text: 'Type.toString',
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/type/toString.ts',
          children: [
            {
              text: 'toString.ts',
            },
          ],
        },
        {
          text: '), and so on.',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Parsing types',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "For writing tests it's useful to parse a type on its own. Babel doesn't provide a function for this, but we can parse an ",
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: ' expression and pull out the type:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function parseType(input: string): Type {\n  const ast = parseExpression(`_ as ${input}`);\n  if (!AST.isTSAsExpression(ast)) bug(`unexpected ${ast.type}`);\n  return Type.ofTSType(ast.typeAnnotation);\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Here ',
        },
        {
          text: 'Type.ofTSType',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/type/ofTSType.ts',
          children: [
            {
              text: 'ofTSType.ts',
            },
          ],
        },
        {
          text: ') converts a Babel ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L2488',
          children: [
            {
              text: 'TSType',
              code: true,
            },
          ],
        },
        {
          text: ' AST (which represents a parsed type) to our ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' representation. And ',
        },
        {
          text: 'bug',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/util/err.ts',
          children: [
            {
              text: 'err.ts',
            },
          ],
        },
        {
          text: ') throws an exception indicating a bug in the code.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The call to ',
        },
        {
          text: 'bug',
          code: true,
        },
        {
          text: ' shows a use of narrowing: the return type of ',
        },
        {
          text: 'bug',
          code: true,
        },
        {
          text: ' is ',
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: ', meaning that the function never returns a value (it throws an exception), so the TypeScript type checker reasons that in the remainder of the function, ',
        },
        {
          text: 'AST.isTSAsExpression(ast)',
          code: true,
        },
        {
          text: ' must be true; so the type of ',
        },
        {
          text: 'ast',
          code: true,
        },
        {
          text: ' must be ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L1961',
          children: [
            {
              text: 'TSAsExpression',
              code: true,
            },
          ],
        },
        {
          text: ' (the ',
        },
        {
          text: 'AST',
          code: true,
        },
        {
          text: ' validators are also type predicates), and we can safely access ',
        },
        {
          text: 'ast.typeAnnotation',
          code: true,
        },
        {
          text: '. We use this pattern to handle unexpected cases throughout the code.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Synthesizing types from expressions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now we have enough machinery in place to do some actual type checking:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Recall from ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0',
          children: [
            {
              text: 'part 0',
            },
          ],
        },
        {
          text: ' that to ',
        },
        {
          text: 'synthesize',
          italic: true,
        },
        {
          text: ' a type ',
        },
        {
          text: 'from',
          italic: true,
        },
        {
          text: ' an expression, we synthesize the types of its subexpressions, then combine them according to the top-level operation of the expression; for atomic expressions like literal values, we return the corresponding type.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'First we case over the expression type and dispatch to helper functions (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/typecheck/synth.ts',
          children: [
            {
              text: 'synth.ts',
            },
          ],
        },
        {
          text: '):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function synth(ast: AST.Expression): Type {\n  switch (ast.type) {\n    case 'NullLiteral':      return synthNull(ast);\n    case 'BooleanLiteral':   return synthBoolean(ast);\n    case 'NumericLiteral':   return synthNumber(ast);\n    case 'StringLiteral':    return synthString(ast);\n    case 'ObjectExpression': return synthObject(ast);\n    case 'MemberExpression': return synthMember(ast);\n\n    default: bug(`unimplemented ${ast.type}`);\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'In each ',
        },
        {
          text: 'case',
          code: true,
        },
        {
          text: ' of the ',
        },
        {
          text: 'switch',
          code: true,
        },
        {
          text: ', the type of ',
        },
        {
          text: 'ast',
          code: true,
        },
        {
          text: ' is narrowed to the corresponding arm of ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L2058',
          children: [
            {
              text: 'Expression',
              code: true,
            },
          ],
        },
        {
          text: ' (which is a big union of all the kinds of expression), so the helper functions receive the specific arm type.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For primitive literals we return the corresponding type:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function synthNull(ast: AST.NullLiteral): Type       { return Type.nullType; }\nfunction synthBoolean(ast: AST.BooleanLiteral): Type { return Type.boolean; }\nfunction synthNumber(ast: AST.NumericLiteral): Type  { return Type.number; }\nfunction synthString(ast: AST.StringLiteral): Type   { return Type.string; }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'For object expressions (of type ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L611',
          children: [
            {
              text: 'ObjectExpression',
              code: true,
            },
          ],
        },
        {
          text: '), we synthesize a type for each property value expression, then return an object type that associates property names to types:',
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: 'function synthObject(ast: AST.ObjectExpression): Type {\n  const properties =\n    ast.properties.map(prop => {\n      if (!AST.isObjectProperty(prop)) bug(`unimplemented ${prop.type}`);\n      if (!AST.isIdentifier(prop.key)) bug(`unimplemented ${prop.key.type}`);\n      if (!AST.isExpression(prop.value)) bug(`unimplemented ${prop.value.type}`);\n      if (prop.computed) bug(`unimplemented computed`);\n      return {\n        name: prop.key.name,\n        type: synth(prop.value)\n      };\n    });\n  return Type.object(properties);\n}',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "The Babel parser parses the full JavaScript expression syntax, but we're only implementing part of it, so we call ",
        },
        {
          text: 'bug(`unimplemented`)',
          code: true,
        },
        {
          text: " for cases that we don't want to handle.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "For member expressions, we synthesize the type of the left-hand side, check that it's an object and contains the named property (using ",
        },
        {
          text: 'Type.propType',
          code: true,
        },
        {
          text: ', see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/type/propType.ts',
          children: [
            {
              text: 'propType.ts',
            },
          ],
        },
        {
          text: '), and return the type of the property. We call ',
        },
        {
          text: 'err',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/util/err.ts',
          children: [
            {
              text: 'err.ts',
            },
          ],
        },
        {
          text: ') to raise an exception if these checks fail (indicating an error in the input).',
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: "function synthMember(ast: AST.MemberExpression): Type {\n  const prop = ast.property;\n  if (!AST.isIdentifier(prop)) bug(`unimplemented ${prop.type}`);\n  if (ast.computed) bug(`unimplemented computed`);\n  const object = synth(ast.object);\n  if (!Type.isObject(object)) err('. expects object', ast.object);\n  const type = Type.propType(object, prop.name);\n  if (!type) err(`no such property ${prop.name}`, prop);\n  return type;\n}",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Again we skip some cases we don't want to handle.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Subtyping',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Recall from ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0',
          children: [
            {
              text: 'part 0',
            },
          ],
        },
        {
          text: ' that in some cases we need to check whether a type ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a ',
        },
        {
          text: 'subtype',
          italic: true,
        },
        {
          text: ' of another type ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: '. I find it really helpful to think of subtyping as an adversarial game: I pass a value of type ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' to an opponent, who is allowed to perform any operations on the value that are allowed by type ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ". If my opponent can't perform any unsupported operation on the value, I win—",
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: '. Otherwise my opponent wins—',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is not a subtype of ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: '.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'My opponent can take the result of an operation and perform further operations on it. So ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ' when all the operations supported on ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ' are also supported on ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: '; and further, that the result of each operation on ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of the result of the same operation on ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: '.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Since we have only a handful of types in this fragment, the subtyping function is simple (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/type/isSubtype.ts',
          children: [
            {
              text: 'isSubtype.ts',
            },
          ],
        },
        {
          text: '):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function isSubtype(a: Type, b: Type): boolean {\n  if (isNull(a) && isNull(b)) return true;\n  if (isBoolean(a) && isBoolean(b)) return true;\n  if (isNumber(a) && isNumber(b)) return true;\n  if (isString(a) && isString(b)) return true;\n\n  if (isObject(a) && isObject(b)) {\n    return b.properties.every(({ name: bName, type: bType }) => {\n      const aType = propType(a, bName);\n      if (!aType) return false;\n      else return isSubtype(aType, bType);\n    });\n  }\n\n  return false;\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Each primitive type is a subtype of itself but no other type. An object type ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of an object type ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ' if all the properties we can access on ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ' can also be accessed on ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: " (the order of properties doesn't matter), and each of those properties on ",
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of the corresponding property on ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: '.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For example, this type of rectangles with labelled points:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{\n  upperLeft: { label: string, x: number, y: number },\n  lowerRight: { label: string, x: number, y: number },\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'is a subtype of this type of rectangles with unlabelled points:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{\n  upperLeft: { x: number, y: number },\n  lowerRight: { x: number, y: number },\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Checking expressions against types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Recall from ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0',
          children: [
            {
              text: 'part 0',
            },
          ],
        },
        {
          text: ' that to ',
        },
        {
          text: 'check',
          italic: true,
        },
        {
          text: ' an expression ',
        },
        {
          text: 'against',
          italic: true,
        },
        {
          text: " an expected type, we break down the expression and type and recursively check each expression part against the corresponding type part. When we can't break down the expression or type, we synthesize a type for the expression, then check to see that the synthesized type is a subtype of the expected type.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'First we case over the expression and expected type and dispatch to helper functions (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part1/src/typecheck/check.ts',
          children: [
            {
              text: 'check.ts',
            },
          ],
        },
        {
          text: '):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function check(ast: Expression, type: Type) {\n  if (AST.isObjectExpression(ast) && Type.isObject(type))\n    return checkObject(ast, type);\n\n  const synthType = synth(ast);\n  if (!Type.isSubtype(synthType, type))\n    err(`expected ${Type.toString(type)}, got ${Type.toString(synthType)}`, ast);\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'In this fragment, we can only break down object expressions against object types. Otherwise we synthesize a type and compare it to the expected type with ',
        },
        {
          text: 'Type.isSubtype',
          code: true,
        },
        {
          text: '.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To check an object expression against an object type, we match expression properties with type properties by name, then check each property value expression against the corresponding property type:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function checkObject(ast: ObjectExpression, type: Type.Object) {\n  const astProps: { name: string, expr: Expression, key: Identifier }[] =\n    ast.properties.map(prop => {\n      if (!AST.isObjectProperty(prop)) bug(`unimplemented ${prop.type}`);\n      if (prop.computed) bug(`unimplemented computed`);\n      if (!AST.isIdentifier(prop.key)) bug(`unimplemented ${prop.key.type}`);\n      if (!AST.isExpression(prop.value)) bug(`unimplemented ${prop.value.type}`);\n      return {\n        name: prop.key.name,\n        expr: prop.value as Expression,\n        key: prop.key\n      };\n    });\n\n  type.properties.forEach(({ name }) => {\n    const astProp = astProps.find(({ name: astName }) => astName === name);\n    if (!astProp) err(`missing property ${name}`, ast);\n  });\n\n  astProps.forEach(({ name, expr, key }) => {\n    const propType = Type.propType(type, name);\n    if (propType) check(expr, propType);\n    else err(`extra property ${name}`, key);\n  });\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "We flag an error if the object expression is missing a property present in the type. We also flag an error if it has an extra property that's not present in the type. You might wonder why, since an extra property can't do any harm; in ",
        },
        {
          text: 'isSubtype',
          code: true,
        },
        {
          text: ' we allow extra properties. But in a literal object expression, an extra property might be a bug: we meant to set an optional property but mistyped it. So we follow actual TypeScript and flag it.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Now that we've defined ",
        },
        {
          text: 'check',
          code: true,
        },
        {
          text: ', we can add a case to ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' to synthesize ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: ' expressions by checking the expression against the given type:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function synthTSAs(ast: AST.TSAsExpression): Type {\n  const type = Type.ofTSType(ast.typeAnnotation);\n  check(ast.expression, type);\n  return type;\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'So ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: " gives us a way to tell the type checker to switch from synthesis to checking. This can be useful for debugging complicated type errors. It's also a way to hide information about the type of an expression (but the language fragment so far is too simple to give a good example of this—more later).",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Example',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Let's walk through an example in detail:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{\n  x: 7,\n  y: { a: "foo", b: "bar" }.b\n} as { x: number, y: number }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: '(See ',
        },
        {
          type: 'a',
          href: 'https://astexplorer.net/#/gist/4adfad800891ef430cb87db4c60dc5c2/5612db7c5bd283efbbe3a79e986b0176f5717a31',
          children: [
            {
              text: 'here',
            },
          ],
        },
        {
          text: ' for the full AST.) Type checking starts with a call to ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ':',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'synth({\n  type: "TSAsExpression",\n  expression: { type: "ObjectExpression", properties: [ ... ] }\n  typeAnnotation: ...\n})',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'The top-level node is ',
        },
        {
          text: 'TSASExpression',
          code: true,
        },
        {
          text: ', so we call ',
        },
        {
          text: 'check',
          code: true,
        },
        {
          text: ' on the ',
        },
        {
          text: 'expression',
          code: true,
        },
        {
          text: ' property with the given type (first translating the parsed ',
        },
        {
          text: 'typeAnnotation',
          code: true,
        },
        {
          text: ' to our ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' representation with ',
        },
        {
          text: 'Type.ofTSType',
          code: true,
        },
        {
          text: '):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'check(\n  // check this expression\n  {\n    type: "ObjectExpression",\n    properties: [\n      {\n        type: "ObjectProperty",\n        key: { type: "Identifier", name: "x" },\n        value: { type: "NumericLiteral", value: 7 }\n      },\n      {\n        type: "ObjectProperty",\n        key: { type: "Identifier", name: "y" },\n        value: { type: "MemberExpression", ... }\n      }\n    ]\n  },\n  // against this type\n  {\n    type: "Object",\n    properties: [\n      { name: "x", type: { type: "Number" } },\n      { name: "y", type: { type: "Number" } }\n    ]\n  }\n)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'To check an ',
        },
        {
          text: 'ObjectExpression',
          code: true,
        },
        {
          text: ' against an ',
        },
        {
          text: 'Object',
          code: true,
        },
        {
          text: ' type, we check each property value expression against the corresponding property type:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '// property x\ncheck({ type: "NumericLiteral", value: 7 }, { type: "Number" })\n\n// property y\ncheck({ type: "MemberExpression", ... }, { type: "Number" })',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "We can't break down either of these further, so for each we ",
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' a type for the expression, then compare it to the expected type with ',
        },
        {
          text: 'isSubtype',
          code: true,
        },
        {
          text: '. For ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' we ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' type ',
        },
        {
          text: 'Number',
          code: true,
        },
        {
          text: " and check that it's a subtype of ",
        },
        {
          text: 'Number',
          code: true,
        },
        {
          text: '. For ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ' we first ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' a type for ',
        },
        {
          text: '{ a: "foo", b: "bar" }.b',
          code: true,
        },
        {
          text: ':',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'synth({\n  type: "MemberExpression",\n  object: {\n    type: "ObjectExpression",\n    properties: [\n      {\n        type: "ObjectProperty",\n        key: { type: "Identifier", name: "a" },\n        value: { type: "StringLiteral", value: "foo" }\n      },\n      {\n        type: "ObjectProperty",\n        key: { type: "Identifier", name: "b" },\n        value: { type: "StringLiteral", value: "bar" }\n      },\n    ]\n  },\n  property: { type: "Identifier", name: "b" }\n})',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'To ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' a type for a ',
        },
        {
          text: 'MemberExpression',
          code: true,
        },
        {
          text: ', we first ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' a type for the ',
        },
        {
          text: 'object',
          code: true,
        },
        {
          text: ' property—to ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' a type for an ',
        },
        {
          text: 'ObjectExpression',
          code: true,
        },
        {
          text: ' we synth types for the property values and return this type:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{\n  type: "Object",\n  properties: [\n    { name: "a", type: { type: "String" } },\n    { name: "b", type: { type: "String" } }\n  ]\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'then project the ',
        },
        {
          text: 'b',
          code: true,
        },
        {
          text: ' property to get type ',
        },
        {
          text: 'String',
          code: true,
        },
        {
          text: ' for the whole ',
        },
        {
          text: 'MemberExpression',
          code: true,
        },
        {
          text: '. Finally we check that ',
        },
        {
          text: 'String',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'Number',
          code: true,
        },
        {
          text: ', and flag an error because it is not.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Try it!',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'You can try out the type checker below: type an expression into the top box, see its synthesized type (or an error) in the bottom box. To check an expression against a type, ascribing a type with ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: '. (Remember that the only supported expressions in this fragment are primitive literals, object expressions, member expressions, and ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: ' ascriptions.)',
        },
      ],
    },
    {
      type: 'liveCode',
      children: [
        {
          text: '<iframe\n  src="https://jaked.org/reconstructing-typescript/part1/"\n  width={700}\n  height={300}\n  style={{ borderStyle: \'none\' }}\n/>',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'The plan',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For the full code of part 1 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/tree/part1',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/tree/part1',
            },
          ],
        },
        {
          text: '.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Next time we'll add functions and function calls to the language—we'll add a ",
        },
        {
          text: 'type environment',
          italic: true,
        },
        {
          text: ' to track the types of variables, and see how subtyping for functions requires ',
        },
        {
          text: 'contravariance',
          italic: true,
        },
        {
          text: '.',
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
                  text: '',
                },
                {
                  type: 'a',
                  href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0',
                  children: [
                    {
                      text: 'Part 0: intro and background',
                    },
                  ],
                },
                {
                  text: '',
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
                  text: '',
                },
                {
                  type: 'a',
                  href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1',
                  children: [
                    {
                      text: 'Part 1: bidirectional type checking',
                    },
                  ],
                },
                {
                  text: '',
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
                  text: 'Part 2: functions and function calls',
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
                  text: 'Part 3: singleton / literal types and arithmetic / logical operators',
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
                  text: 'Part 4: union types',
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
                  text: 'Part 5: intersection types',
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
                  text: 'Part 6: narrowing',
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
          text: 'Thanks to Julia Evans, Tony Chow, and Will Lachance for helpful feedback on a draft of this post.',
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
    title: 'Reconstructing TypeScript, part 1: bidirectional type checking',
    layout: '/layout',
    publish: true,
  },
}