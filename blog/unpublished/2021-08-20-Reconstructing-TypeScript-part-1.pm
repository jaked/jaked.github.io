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
          text: 'Reconstructing TypeScript (part 1)',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-08-20',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'I\'ve been building a "document development environment" called ',
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
          text: " that supports live code embedded in documents, with a simple TypeScript-like programming language. It's been fun figuring out how to implement it—the type system in ",
        },
        {
          type: 'a',
          href: 'https://www.typescriptlang.org/',
          children: [
            {
              text: 'TypeScript',
            },
          ],
        },
        {
          text: ' is unusual and very cool!',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I want to dig into what's cool and unusual about TypeScript by presenting a type checker for a fragment of this language (written in actual TypeScript). I'll start with a tiny fragment and build it up over several posts. But first:",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: "What's a type checker?",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'You\'ve probably used a type checker, and have an idea what "type" and "type checking" mean. But I want to unpack these concepts a little:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "In JavaScript, a variable can hold values of different types. Suppose we don't know what type ",
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: " holds—maybe we know it's a ",
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ' or a ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ' but not which one. If we test the type',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "if (typeof x === 'string') {\n  ...\n} else {\n  ...\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'then we can reason (at development time) that if the test succeeds (at run time) the value must have type ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: '; so we can safely treat ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' as a ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ' in the true branch (and a ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ' in the false branch).',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "As programmers, reasoning about the behavior of programs is our main job! We mostly do it in our heads, but it's really useful to automate it—to catch mistakes, and to support interactive development features like code completion. This is where a type checker comes in: it's a way to reason automatically at development time about the behavior of programs at run time.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Our human reasoning can be arbitrarily creative and complex, but a type checker is just a program, so its "reasoning" is limited. For our purpose, a type checker just ensures that a program doesn\'t attempt any unsupported operations on values (such as accessing a property that doesn\'t exist on an object).',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Since a type checker runs at development time, it can't know the actual values flowing through a program at run time. Instead, for each expression in the program, it lumps together the values that might be computed by the expression, and gives the expression a type that describes operations supported on all the values. For example, in",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const vec = { x: x, y: y };',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'if ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ' have type ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ', then ',
        },
        {
          text: 'vec',
          code: true,
        },
        {
          text: ' has type',
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
          text: 'meaning that it supports accessing the ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ' property (and further that the properties are ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: '). ',
        },
        {
          code: true,
          text: 'x',
        },
        {
          text: ' and ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ' may take on many different values as the program runs, so ',
        },
        {
          text: 'vec',
          code: true,
        },
        {
          text: ' may also take on many values; all such values support accessing the ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ' property.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now, if the program contains an expression ',
        },
        {
          text: 'vec.z',
          code: true,
        },
        {
          text: ', we can see from the type of ',
        },
        {
          text: 'point',
          code: true,
        },
        {
          text: " that this is an unsupported operation. So a type checker ensures that a program doesn't attempt any unsupported operations on ",
        },
        {
          text: 'concrete values at run time',
          italic: true,
        },
        {
          text: " by checking that it doesn't attempt any unsupported operations on ",
        },
        {
          text: 'expression types at development time',
          italic: true,
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
          text: "What's cool about TypeScript?",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "In most type systems, primitive types can't be mixed, so a variable can't hold either ",
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ". But there's usually a way to mix certain compound types and test the type of a value. In a language with classes and objects, a variable of class ",
        },
        {
          text: 'Shape',
          code: true,
        },
        {
          text: ' can hold objects of subclasses ',
        },
        {
          text: 'Circle',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'Square',
          code: true,
        },
        {
          text: ', and we can test the class of the object with ',
        },
        {
          text: 'instanceof',
          code: true,
        },
        {
          text: ' (or some equivalent). Or in a language with variant types (aka sums or tagged unions), a variable of type ',
        },
        {
          text: 'Tree',
          code: true,
        },
        {
          text: ' can hold values of variant arms ',
        },
        {
          text: 'Leaf',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'Node',
          code: true,
        },
        {
          text: ', and we can learn what arm a value is by pattern-matching.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'In TypeScript, any types can be mixed. If we know that ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' holds a ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ' or a ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ' we can give it a ',
        },
        {
          text: 'union',
          italic: true,
        },
        {
          text: ' type, ',
        },
        {
          text: 'string | boolean',
          code: true,
        },
        {
          text: '. When we test the type in the example above, the type checker ',
        },
        {
          text: 'narrows',
          italic: true,
        },
        {
          text: ' the type of ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' in the branches of the ',
        },
        {
          text: 'if',
          code: true,
        },
        {
          text: ' / ',
        },
        {
          text: 'else',
          code: true,
        },
        {
          text: ' according to the result of the test: in the true branch, ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' has type ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: '; in the false branch, ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ' (if a ',
        },
        {
          text: 'string | boolean',
          code: true,
        },
        {
          text: ' is not ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ' it must be ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ').',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'This idea goes pretty far—for example, we can define a variant-like tree type as a union of leaf and node objects:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type tree = { value: number } | { left: tree, right: tree }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "and TypeScript checks that it's safe to use the ",
        },
        {
          text: 'left',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'right',
          code: true,
        },
        {
          text: ' fields after we check the presence of the ',
        },
        {
          text: 'value',
          code: true,
        },
        {
          text: ' field:',
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: "function height(t: tree): number {\n  if ('value' in t) return 1;\n  else return 1 + Math.max(height(t.left), height(t.right));\n}",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I like programming with union types and narrowing a lot. They make it possible to get useful checking of typical JavaScript idioms that depend on run-time type tests, so it's straightforward to translate most JavaScript code to TypeScript. And unions are an appealing alternative to variant types or class hierarchies, because they're simpler and more flexible. (I'll give some examples along the way to justify this claim.)",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Reconstructing TypeScript',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I have to confess—I don't know how actual TypeScript works! There isn't an ",
        },
        {
          type: 'a',
          href: 'https://github.com/Microsoft/TypeScript/issues/15711',
          children: [
            {
              text: 'up-to-date specification',
            },
          ],
        },
        {
          text: " of how it's supposed to work, and I haven't tried to read the implementation. Also, the language in Programmable Matter fills a pretty different niche from actual TypeScript, so I've chosen to diverge from it in several ways.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "What I'll present here is a reconstruction of TypeScript, based on TypeScript's informal documentation, experimenting with the actual TypeScript implementation, research papers about related systems, background knowledge about implementing type checkers, and my own opinions on how it should work. (I'll point out interesting differences between this reconstruction and actual TypeScript along the way.)",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Bidirectional type checking',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "As above, a type checker needs to know the type of every expression in a program, so it can check that the program doesn't attempt any unsupported operations.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Often we can ',
        },
        {
          text: 'synthesize',
          italic: true,
        },
        {
          text: ' a type from an expression. The type of primitive expressions is easy: ',
        },
        {
          text: '"foo"',
          code: true,
        },
        {
          text: ' has type ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'true',
          code: true,
        },
        {
          text: ' has type ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ', and so on. For a compound expression, we can find the types of its subexpressions, then combine them according to the top-level operation of the expression—if ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ' have type ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' then',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: x, y: y }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'has type',
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
          text: 'When we synthesize a type from an expression, the type describes operations supported by values computed by the expression.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Sometimes we expect an expression to have a certain type based on context; then, instead of synthesizing, we can ',
        },
        {
          text: 'check',
          italic: true,
        },
        {
          text: " an expression against the type: break down the expression and type, and recursively check each expression part against each type part; when we reach an expression that can't be broken down, synthesize its type and compare it against the expected type. For example, when type checking a function call:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type vector = { x: number, y: number }\n\nconst magnitude = (v: vector) => Math.sqrt(v.x * v.x + v.y * v.y)\n\nconst m = magnitude({ x: 7, y: "nine" })',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'we break down the function argument and its expected type, then check ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ' against ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: '"nine"',
          code: true,
        },
        {
          text: ' against ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' (so discover a type error). When we check an expression against a type, we check that the operations supported by the type are also supported by values computed by the expression.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "This approach—synthesize a type from an expression when we don't know what type to expect, check an expression against a type when we do—is called ",
        },
        {
          text: 'bidirectional type checking',
          italic: true,
        },
        {
          text: ", so named because type information flows in two directions in the AST: from leaves to root when synthesizing, from root to leaves when checking. Actual TypeScript mostly follows this approach, so that's what we'll do.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Now let's write a type checker! (For the full code of part 1 see ",
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
          text: '.)',
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
          text: "In this first fragment we'll support only a few types—primitives and objects made up of properties (see ",
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
          text: "(We don't have an ",
        },
        {
          text: 'any',
          code: true,
        },
        {
          text: ' type. In actual TypeScript ',
        },
        {
          type: 'a',
          href: 'https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#any',
          children: [
            {
              text: 'any',
              code: true,
            },
            {
              text: ' is an escape hatch from type checking',
            },
          ],
        },
        {
          text: ", to accommodate existing JavaScript that doesn't fit into the type system; here we won't provide any escape hatches.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "When consuming types we'll work directly with these objects; but we have helper functions to construct them (see ",
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
          text: "We represent object properties as an array, but it's often convenient to construct object types by passing an object mapping names to types:",
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
          text: ' constructor takes either:',
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
          text: 'This is a nice example of the flexibility of union types: rather than define a separate function to convert an object argument to an array, we give the argument a union type.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We wrap constructors and other type-related functions into a module (see ',
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
          text: 'Type.object',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'Type.toString',
          code: true,
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
      type: 'h2',
      children: [
        {
          text: 'Parsing code',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "To parse code into an abstract syntax tree we'll use ",
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
          text: ', which parses JavaScript with TypeScript extensions to a ',
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
          text: ' AST (with ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts',
          children: [
            {
              text: 'this TypeScript type',
            },
          ],
        },
        {
          text: ').',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "To keep things simple we'll handle only ",
        },
        {
          text: 'Expression',
          code: true,
        },
        {
          text: ' nodes in the AST (see ',
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
          text: "For writing tests it's convenient to be able to parse types separately:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function parseType(input: string): Type {\n  const ast = parseExpression(`_ as ${input}`);\n  if (ast.type !== 'TSAsExpression') bug(`unexpected ${ast.type}`);\n  return Type.ofTSType(ast.typeAnnotation);\n}",
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
          text: 'TSType',
          code: true,
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
          text: ' must be false. Therefore ',
        },
        {
          text: "ast.type === 'TSAsExpression'",
          code: true,
        },
        {
          text: ' and we can safely access ',
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
          text: ' for this—set the language to "JavaScript" and the parser to "@babel/parser"; TypeScript extensions are parsed without special configuration.',
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
          text: "In this first fragment we'll support only a few kinds of expression: primitive literals, object literals (like ",
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
          text: "function synth(ast: Expression): Type {\n  switch (ast.type) {\n    case 'NullLiteral':      return synthNull(ast);\n    case 'BooleanLiteral':   return synthBoolean(ast);\n    case 'NumericLiteral':   return synthNumber(ast);\n    case 'StringLiteral':    return synthString(ast);\n    case 'ObjectExpression': return synthObject(ast);\n    case 'MemberExpression': return synthMember(ast);\n    case 'TSAsExpression':   return synthTSAs(ast);\n\n    default: bug(`unimplemented ${ast.type}`);\n  }\n}",
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
          text: 'function synthNull(ast: NullLiteral): Type { return Type.nullType; }\nfunction synthBoolean(ast: BooleanLiteral): Type { return Type.boolean; }\nfunction synthNumber(ast: NumericLiteral): Type { return Type.number; }\nfunction synthString(ast: StringLiteral): Type { return Type.string; }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'For object expressions, we synthesize a type for each property value expression, then return an object type mapping property names to types:',
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: "function synthObject(ast: ObjectExpression): Type {\n  const properties =\n    ast.properties.map(prop => {\n      if (prop.type !== 'ObjectProperty') bug(`unimplemented ${prop.type}`);\n      if (prop.computed) bug(`unimplemented computed`);\n      if (prop.key.type !== 'Identifier') bug(`unimplemented ${prop.key.type}`);\n      return {\n        name: prop.key.name,\n        type: synth(prop.value as Expression)\n      };\n    });\n  return Type.object(properties);\n}",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We call ',
        },
        {
          text: 'bug(`unimplemented`)',
          code: true,
        },
        {
          text: ' when the object expression contains the spread operator (',
        },
        {
          text: '...',
          code: true,
        },
        {
          text: ') or a computed property name (',
        },
        {
          text: '[name]: value',
          code: true,
        },
        {
          text: "). (We're obliged to cast ",
        },
        {
          text: 'prop.value',
          code: true,
        },
        {
          text: ' here because the Babel AST type is imprecise—it uses ',
        },
        {
          text: 'ObjectProperty',
          code: true,
        },
        {
          text: ' for both ',
        },
        {
          text: 'ObjectExpression',
          code: true,
        },
        {
          text: 's and ',
        },
        {
          text: 'ObjectPattern',
          code: true,
        },
        {
          text: 's, so permits non-',
        },
        {
          text: 'Expression',
          code: true,
        },
        {
          text: " pattern nodes, even though they don't actually appear.)",
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
          text: "function synthMember(ast: MemberExpression): Type {\n  if (ast.computed) bug(`unimplemented computed`);\n  const prop = ast.property;\n  if (prop.type !== 'Identifier') bug(`unimplemented ${prop.type}`);\n  const object = synth(ast.object);\n  if (object.type !== 'Object') err('. expects object', ast.object);\n  const typeProp =\n    object.properties.find(({ name: typeName }) => typeName === prop.name);\n  if (!typeProp) err(`no such property ${prop.name}`, prop);\n  return typeProp.type;\n}",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Again we don't implement computed property names.",
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
          text: 'function synthTSAs(ast: TSAsExpression): Type {\n  const type = Type.ofTSType(ast.typeAnnotation);\n  check(ast.expression, type);\n  return type;\n}',
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
          text: "Again we don't implement spreads or computed property names. ",
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
          text: 'In ',
        },
        {
          text: 'check',
          code: true,
        },
        {
          text: ", when we can't break down the expression or type, we synthesize a type and compare it to the expected type. Recall that checking an expression against a type means checking that the expression supports the operations described by the type; recall also that the type synthesized for an expression describes the operations it supports. So, putting these together, to compare types here we need to check that the operations supported by the ",
        },
        {
          text: 'expected',
          italic: true,
        },
        {
          text: ' type are also supported by the ',
        },
        {
          text: 'synthesized',
          italic: true,
        },
        {
          text: ' type. When the operations supported by type ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ' are also supported by type ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ', we say that ',
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
          text: ' of ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ' , or ',
        },
        {
          text: 'A <: B',
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
          text: 'When ',
        },
        {
          text: 'A <: B',
          code: true,
        },
        {
          text: ', then an operation supported on ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ' is also supported on ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: '. So it makes sense that subtyping should be reflexive (',
        },
        {
          text: 'A <: A',
          code: true,
        },
        {
          text: ' for any ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ') and transitive (if ',
        },
        {
          text: 'A <: B',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'B <: C',
          code: true,
        },
        {
          text: ' then ',
        },
        {
          text: 'A <: C',
          code: true,
        },
        {
          text: ' for any ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ', and ',
        },
        {
          text: 'C',
          code: true,
        },
        {
          text: ').',
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
          text: "function isSubtype(a: Type, b: Type): boolean {\n  if (a.type === 'Null' && b.type === 'Null') return true;\n  if (a.type === 'Boolean' && b.type === 'Boolean') return true;\n  if (a.type === 'Number' && b.type === 'Number') return true;\n  if (a.type === 'String' && b.type === 'String') return true;\n\n  if (a.type === 'Object' && b.type === 'Object') {\n    return b.properties.every(({ name: bName, type: bType }) => {\n      const aProp = a.properties.find(({ name: aName }) => aName === bName);\n      if (!aProp) return false;\n      else return isSubtype(aProp.type, bType);\n    });\n  }\n\n  return false; \n}",
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
          text: "; the order of fields doesn't matter.",
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
      type: 'ul',
      children: [
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'Part 1: bidirectional type checking',
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
      type: 'h2',
      children: [
        {
          text: 'References',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'On bidirectional type checking see Pierce and Turner, ',
        },
        {
          type: 'a',
          href: 'https://www.cis.upenn.edu/~bcpierce/papers/lti-toplas.pdf',
          children: [
            {
              text: 'Local Type Inference',
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
          text: 'The ',
        },
        {
          type: 'a',
          href: 'https://github.com/microsoft/TypeScript/blob/main/doc/TypeScript%20Language%20Specification%20-%20ARCHIVED.pdf?raw=true',
          children: [
            {
              text: 'TypeScript Language Specification',
            },
          ],
        },
        {
          text: ' is 5 years out of date but still interesting.',
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
    title: 'Reconstructing TypeScript (part 1)',
    layout: '/layout',
    publish: true,
  },
}