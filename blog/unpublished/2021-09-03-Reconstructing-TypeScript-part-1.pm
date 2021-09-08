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
          text: ' > Reconstructing TypeScript (part 1)',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Reconstructing TypeScript (part 1): bidirectional type checking',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-09-03',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'This post is part of a series about implementing type checking for a TypeScript-like lanaguge. In the ',
        },
        {
          type: 'a',
          href: '/blog/unpublished/2021-09-03-Reconstructing-TypeScript-part-0',
          children: [
            {
              text: 'last post',
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
          text: "Now let's write a type checker! We're going to start with a tiny fragment of the language, and build it up incrementally in subsequent posts.",
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
          text: 'Recall that type checking works on an ',
        },
        {
          text: 'abstract syntax tree',
          italic: true,
        },
        {
          text: ', where each expression in a program is a node, with its subexpressions as children.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'TypeScript has two main categories of syntax: ',
        },
        {
          text: 'expressions',
          italic: true,
        },
        {
          text: ' and ',
        },
        {
          italic: true,
          text: 'statements',
        },
        {
          text: '. Expressions return a value—here are some expressions:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '[1, 2, 3]\nx > 0 ? 1/x : 0\n(degreesCelsius: number) => 32 + (9/5 * degreesCelsius)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "Statements don't return a value, but have some side-effect—here are some statements:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "const x = 7\nif (x > 0) { return 1/x } else { return 0 }\nthrow new Error('bad thing')",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'To keep things simple, our language will support only expressions.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "To parse the text of expressions into an abstract syntax tree, we'll use ",
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
          text: ', which produces a ',
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
          text: ' AST satisfying the ',
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
          text: " type. Fortunately Babel provides a function to parse only expression syntax. Here's the code (see ",
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
          text: 'If we call this function on an object expression',
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
          text: 'ObjectExpression',
          code: true,
        },
        {
          text: ' AST with ',
        },
        {
          text: 'ObjectProperty',
          code: true,
        },
        {
          text: ' ASTs as children',
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
          text: " property saying what kind of syntax it represents; each kind of node has specific properties for subexpressions and other attributes. (I've trimmed properties that describe the location in the original code string of each AST node.) ",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "It's really helpful to be able to browse the AST produced by a piece of code. I use the excellent ",
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
          text: ' for this—set the language to "JavaScript" and the parser to "@babel/parser" (TypeScript extensions are parsed without special configuration).',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Be aware that AST Explorer parses statements, not expressions. Usually it's OK to write an expression where a statement is expected, but for object expressions you need to wrap parentheses around them, or else the parser sees ",
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
          text: "To synthesize and check types, we need a way to represent them. In this fragment we'll support only a few types—primitives and objects made up of properties (see ",
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
      type: 'h3',
      children: [
        {
          text: 'Constructors',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "It's convenient to have some predefined constants and helper functions to construct types (see ",
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
          text: "We represent object properties as an array, but it's often convenient to construct object types by passing an object mapping names to types, like:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const type = object({ foo: boolean, bar: string });',
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
          text: '. Otherwise it must be an object mapping property names to ',
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
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "It's also convenient to define validators for different kinds of ",
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
          text: ' is a ',
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
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We wrap constructors, validators, and other type-related functions into a module (see ',
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
          text: 'Type.boolean, Type.object({ ... })',
          code: true,
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
      type: 'p',
      children: [
        {
          text: 'The ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' module has a helper function to look up the type of a property in an object type:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function propType(type: Object, name: string): Type | undefined {\n  const prop = type.properties.find(({ name: propName }) => propName === name);\n  if (prop) return prop.type;\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Parsing types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "For writing tests it's convenient to parse a type on its own. Babel doesn't provide a function for this, but we can parse an ",
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
          text: ' AST to our ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' representation, and ',
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
          text: ') throws an exception.',
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
          text: "ast.type !== 'TSAsExpression'",
          code: true,
        },
        {
          text: ' must be false. Then ',
        },
        {
          text: "ast.type === 'TSAsExpression'",
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
          text: ', and we can safely access ',
        },
        {
          text: 'typeAnnotation',
          code: true,
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
          text: 'Synthesizing types from expressions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Recall that to ',
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
          text: "In this fragment we'll support only a few kinds of expression: primitive literal values (like ",
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'true',
          code: true,
        },
        {
          text: '), object literals (like ',
        },
        {
          text: '{ x: x, y: y }',
          code: true,
        },
        {
          text: '), and member expressions (like ',
        },
        {
          text: 'vec.x',
          code: true,
        },
        {
          text: '). To synthesize the type of an expression, we first case over the expression type and dispatch to helper functions (see ',
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
          text: '), we synthesize a type for each property value expression, then return an object type mapping property names to types:',
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
          text: "For member expressions, we synthesize the type of the left-hand side, check that it's an object that contains the named member, and return the type of the member. We call ",
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
          text: ') to raise an exception if these checks fail.',
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
          text: "Recall that to check an expression against a type (we'll show the code for this in the next section) we need to check ",
        },
        {
          text: 'subtyping',
          italic: true,
        },
        {
          text: ': a type ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of a type ',
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
          text: '.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's a function to check subtyping (see ",
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
          text: 'An object type ',
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
          text: ', and each of those fields in ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of the corresponding field in ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: "; the order of properties doesn't matter.",
        },
      ],
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
          text: 'To check an expression against a type, we first case over the expression and type and dispatch to helper functions (see ',
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
          text: "function check(ast: Expression, type: Type) {\n  if (ast.type === 'ObjectExpression' && type.type === 'Object')\n    return checkObject(ast, type);\n\n  const synthType = synth(ast);\n  if (!Type.isSubtype(synthType, type))\n    err(`expected ${Type.toString(type)}, got ${Type.toString(synthType)}`, ast);\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Object expressions are the only ones we can break down in this fragment; we synthesize types for other expressions and compare then with ',
        },
        {
          text: 'Type.isSubtype',
          code: true,
        },
        {
          text: ' (more on this below).',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "To check an object expression against an object type, we check the value expression for each property against the corresponding type. We raise an exception if the object expression is missing a property present in the type, or if it has a property that's not present in the type.",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function checkObject(ast: ObjectExpression, type: Type.Object) {\n  const astProps: { name: string, expr: Expression, key: Identifier }[] =\n    ast.properties.map(prop => {\n      if (prop.type !== 'ObjectProperty') bug(`unimplemented ${prop.type}`);\n      if (prop.computed) bug(`unimplemented computed`);\n      if (prop.key.type !== 'Identifier') bug(`unimplemented ${prop.key.type}`);\n      return {\n        name: prop.key.name,\n        expr: prop.value as Expression,\n        key: prop.key\n      };\n    });\n\n  type.properties.forEach(({ name }) => {\n    const astProp = astProps.find(({ name: astName }) => astName === name);\n    if (!astProp) err(`missing property ${name}`, ast);\n  });\n\n  astProps.forEach(({ name, expr, key }) => {\n    const prop =\n      type.properties.find(({ name: propName }) => propName === name);\n    if (prop) check(expr, prop.type);\n    else err(`extra property ${name}`, key);\n  });\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "Again we don't implement spreads or computed property names.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Finally for ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: ' expressions we synthesize by checking the expression against the given type:',
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
          text: 'In actual TypeScript, ',
        },
        {
          text: 'expression',
          code: true,
          italic: true,
        },
        {
          text: ' as ',
          code: true,
        },
        {
          text: 'type',
          code: true,
          italic: true,
        },
        {
          text: " is an unsafe cast; here it's a ",
        },
        {
          text: 'type ascription',
          italic: true,
        },
        {
          text: " that we can use to direct the type checker to check rather than synthesize a particular expression, but it can't cast to an unrelated type.",
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
          text: 'You can try out the type checker below; it synthesizes a type from the expression, but you can try checking by ascribing a type with ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: '. Remember that the only supported expressions in this fragment are primitive literals, object expressions, property accesses, and ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: ' ascriptions.',
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
          text: "Here's the plan",
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
          text: ' to track the types of variables; and see how subtyping for functions requires ',
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
                  href: '/blog/unpublished/2021-09-03-Reconstructing-TypeScript-part-0',
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
                  href: '/blog/unpublished/2021-09-03-Reconstructing-TypeScript-part-1',
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
    title: 'Reconstructing TypeScript (part 1)',
    layout: '/layout',
    publish: true,
  },
}