{
  version: 2,
  children: [
    {
      type: 'liveCode',
      children: [
        {
          text: "import Parts from 'components/parts'",
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
          text: ' > Reconstructing TypeScript, part 6',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Reconstructing TypeScript, part 6: narrowing',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-11-11',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'This post is part of a series about implementing type checking for a TypeScript-like language. See ',
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
          text: ' for background, and parts ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1',
          children: [
            {
              text: '1',
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-27-Reconstructing-TypeScript-part-2',
          children: [
            {
              text: '2',
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-06-Reconstructing-TypeScript-part-3',
          children: [
            {
              text: '3',
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-14-Reconstructing-TypeScript-part-4',
          children: [
            {
              text: '4',
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-28-Reconstructing-TypeScript-part-5',
          children: [
            {
              text: '5',
            },
          ],
        },
        {
          text: ' for the implementation so far.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "In this part we'll add conditional expressions like",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "// x: { type: 'a', a: boolean } | { type: 'b', b: string }\nx.type === 'a' ? x.a : x.b",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and implement ',
        },
        {
          text: 'narrowing',
          italic: true,
        },
        {
          text: ': the type checker will use information from the test to deduce a more-specific type for ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' in the true and false branches of the conditional expression, so it can check that the property accesses are safe.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: "What's narrowing?",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'In a conditional expression like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "// x: { type: 'a', a: boolean } | { type: 'b', b: string }\nx.type === 'a' ? x.a : x.b",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'the ',
        },
        {
          text: 'true branch',
          italic: true,
        },
        {
          text: ' ',
        },
        {
          text: 'x.a',
          code: true,
        },
        {
          text: ' is executed only when the ',
        },
        {
          text: 'test',
          italic: true,
        },
        {
          text: ' ',
        },
        {
          text: "x.type === 'a'",
          code: true,
        },
        {
          text: ' is true, and the ',
        },
        {
          text: 'false branch',
          italic: true,
        },
        {
          text: ' ',
        },
        {
          text: 'x.b',
          code: true,
        },
        {
          text: ' is executed only when the test is false. So while type checking the true branch we can assume that the test is true, then use information deduced from that assumption to give more-specific (',
        },
        {
          text: 'narrower',
          italic: true,
        },
        {
          text: ') types to variables in the environment; and similarly for the false branch.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'While type checking the true branch ',
        },
        {
          text: 'x.a',
          code: true,
        },
        {
          text: ' we assume that ',
        },
        {
          text: "x.type === 'a'",
          code: true,
        },
        {
          text: ' is true; from that assumption and the current environment we deduce',
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
                  text: 'x.type',
                  code: true,
                },
                {
                  text: ' satisfies the type ',
                },
                {
                  text: "'a'",
                  code: true,
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
                  code: true,
                  text: 'x',
                },
                {
                  text: ' satisfies the type ',
                },
                {
                  text: "{ type: 'a' }",
                  code: true,
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
                  text: 'we know that ',
                },
                {
                  text: 'x',
                  code: true,
                },
                {
                  text: ' satisfies ',
                },
                {
                  text: "{ type: 'a', a: boolean } | { type: 'b', b: string }",
                  code: true,
                },
                {
                  text: ' from the current environment ',
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
                  text: 'but ',
                },
                {
                  text: "{ type: 'a' }",
                  code: true,
                },
                {
                  text: ' and ',
                },
                {
                  text: "{ type: 'b' }",
                  code: true,
                },
                {
                  text: ' conflict, so ',
                },
                {
                  text: 'x',
                  code: true,
                },
                {
                  text: ' cannot satisfy the second arm of the union',
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
                  text: 'so ',
                },
                {
                  text: 'x',
                  code: true,
                },
                {
                  text: ' must satisfy ',
                },
                {
                  text: "{ type: 'a', a: boolean }",
                  code: true,
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
          text: 'Using this narrower type for ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' we see that ',
        },
        {
          text: 'x.a',
          code: true,
        },
        {
          text: ' is safe.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Narrowing as logical implication',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "It's useful to think of the type environment as a logical statement that asserts facts about the types of variables. For example, this environment",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x: { type: 'a', a: boolean } | { type: 'b', b: string }\ny: string\nz: number",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'corresponds to this logical statement',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x: { type: 'a', a: boolean } | { type: 'b', b: string } AND\ny: string AND\nz: number",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'As we saw in ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-28-Reconstructing-TypeScript-part-5#whats-an-intersection-type',
          children: [
            {
              text: 'part 5',
            },
          ],
        },
        {
          text: ', we can also think of intersection and union types as logical AND and OR; so all of these logical statements mean the same thing',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x: 'a' | 'b' AND x: 'a'\nx: ('a' | 'b') & 'a'\nx: 'a'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'We can read a conditional test as a logical statement; then to assume it true (when we type check the true branch of a conditional), we conjoin it to the environment',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x: { type: 'a', a: boolean } | { type: 'b', b: string } AND\ny: string AND\nz: number AND\nx.type === 'a'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'then deduce that this statement implies',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x: { type: 'a', a: boolean }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "However, type environments hold bindings of variables to types, so we can't represent the statement above directly; but we can work around the limitations:",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "We can't directly represent a value equality, but we can represent an equivalent singleton type: ",
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: "x.type: 'a' // represents x.type === 'a'",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "We can't directly represent the type of a member expression, but we can represent an equivalent variable binding:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x: { type: 'a' } // represents x.type: 'a'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "We can't directly represent a conjunction of statements about the same variable (since type environments hold only a single type for each variable), but we can represent an equivalent intersection type:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x: ({ type: 'a', a: boolean } | { type: 'b', b: string }) & { type: 'a' }\n// represents\n// x: { type: 'a', a: boolean } | { type: 'b', b: string } AND\n// x: { type: 'a' }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "In the code we'll stick with the existing type environment representation; but keep in mind the view of the environment as a logical statement.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Representing negation',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To type check the false branch of the example, we need to represent the logical statement',
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: "NOT (x.type === 'a')",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "There's no way to shoehorn this into the existing implementation—we need another kind of type: ",
        },
        {
          text: 'negation',
          italic: true,
        },
        {
          text: ' types, written ',
        },
        {
          text: '!t',
          code: true,
        },
        {
          text: '. As usual we extend the ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' union (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/type/types.ts#L66',
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
          text: "type Type = ... | Not;\n  \n\ntype Not = {\n  type: 'Not';\n  base: Type;\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'add a constructor (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/type/constructors.ts#L31',
          children: [
            {
              text: 'constructors.ts',
            },
          ],
        },
        {
          text: ') and validator (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/type/validators.ts#L47',
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
          text: "function not(base: Type): Not {\n  return { type: 'Not', base };\n}\n\nfunction isNot(type: Type): type is Not {\n  return type.type === 'Not';\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and a case for ',
        },
        {
          text: 'Not',
          code: true,
        },
        {
          text: ' in ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/type/toString.ts#L51',
          children: [
            {
              text: 'toString.ts',
            },
          ],
        },
        {
          text: ". Actual TypeScript doesn't support negation types, and the Babel parser doesn't parse any syntax for them, so we don't add a case to ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/type/ofTSType.ts',
          children: [
            {
              text: 'ofTSType.ts',
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
          text: 'Now, for the false branch ',
        },
        {
          text: 'x.b',
          code: true,
        },
        {
          text: ', we assume ',
        },
        {
          text: "x.type === 'a'",
          code: true,
        },
        {
          text: ' is false and deduce',
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
                  text: 'x.type',
                  code: true,
                },
                {
                  text: ' satisfies ',
                },
                {
                  text: "!'a'",
                  code: true,
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
                  code: true,
                  text: 'x',
                },
                {
                  text: ' satisfies ',
                },
                {
                  text: "{ type: !'a' }",
                  code: true,
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
                  text: 'x satisfies ',
                },
                {
                  text: "{ type: 'a', a: boolean } | { type: 'b', b: string }",
                  code: true,
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
                  text: 'but ',
                },
                {
                  text: "{ type: !'a' }",
                  code: true,
                },
                {
                  text: ' and ',
                },
                {
                  text: "{ type: 'a' }",
                  code: true,
                },
                {
                  text: ' conflict, so ',
                },
                {
                  text: 'x',
                  code: true,
                },
                {
                  text: ' cannot satisfy the first arm of the union',
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
                  text: 'so ',
                },
                {
                  text: 'x',
                  code: true,
                },
                {
                  text: ' must satisfy ',
                },
                {
                  text: "{ type: 'b', b: string }",
                  code: true,
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
          text: 'so ',
        },
        {
          text: 'x.b',
          code: true,
        },
        {
          text: ' is safe.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Negation types could be useful in ordinary programming, but we won't support them in the whole type checker; to keep things simple we'll use them only in narrowing. ",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Implementing narrowing',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Narrowing involves several related functions—it's a lot of code!",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function narrow(env: Env, ast: AST.Expression, assume: boolean): Env',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'When we type check a branch of a conditional expression, we call ',
        },
        {
          text: 'narrow',
          code: true,
        },
        {
          text: ' with the current environment, the test expression, and a flag saying whether the test is assumed to be true or false. It returns an updated environment incorporating the information deduced from the test and assumption.',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function narrowPath(env: Env, ast: AST.Expression, type: Type): Env',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'When we deduce that a subexpression of the test must satisfy a type, we call ',
        },
        {
          text: 'narrowPath',
          code: true,
        },
        {
          text: ' to incorporate it into the environment. Here a ',
        },
        {
          text: 'path',
          italic: true,
        },
        {
          text: ' is an expression that references a variable, like ',
        },
        {
          text: 'x.type',
          code: true,
        },
        {
          text: '; as above, we need to reason backwards until we reach a variable so we can update the environment.',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function narrowType(x: Type, y: Type): Type',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'When we reach a variable, we call ',
        },
        {
          text: 'narrowType',
          code: true,
        },
        {
          text: " with the current type of the variable from the environment and the deduced type, then update the variable's type with the result. This corresponds to a logical AND, so ",
        },
        {
          text: 'narrowType',
          code: true,
        },
        {
          text: ' is a kind of intersection—more on this below.',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'narrow',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's the top-level ",
        },
        {
          text: 'narrow',
          code: true,
        },
        {
          text: ' function (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L261',
          children: [
            {
              text: 'narrow.ts',
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
          text: "function narrow(env: Env, ast: AST.Expression, assume: boolean): Env {\n  switch (ast.type) {\n    case 'UnaryExpression':\n      return narrowUnary(env, ast, assume);\n\n    case 'LogicalExpression':\n      return narrowLogical(env, ast, assume);\n\n    case 'BinaryExpression':\n      return narrowBinary(env, ast, assume);\n\n    default:\n      return narrowPath(env, ast, assume ? Type.truthy : Type.falsy);\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'For unary, logical, and binary expressions we dispatch to AST-specific functions to break them down. Otherwise the expression is a path, so we call ',
        },
        {
          text: 'narrowPath',
          code: true,
        },
        {
          text: ' to narrow the path to a type that satisfies ',
        },
        {
          text: 'truthy',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'falsy',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/type/truthiness.ts#L24',
          children: [
            {
              text: 'truthiness.ts',
            },
          ],
        },
        {
          text: ').',
        },
      ],
    },
    {
      type: 'h4',
      children: [
        {
          text: 'narrowUnary',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Assuming an expression is true is the same as assuming its negation is false (and vice versa); so for ',
        },
        {
          text: '!',
          code: true,
        },
        {
          text: ' we narrow the argument with the assumption flipped. Since ',
        },
        {
          text: 'typeof',
          code: true,
        },
        {
          text: ' always returns a truthy string, we deduce nothing (but see the ',
        },
        {
          text: 'narrowPath',
          code: true,
        },
        {
          text: ' case for ',
        },
        {
          text: 'typeof',
          code: true,
        },
        {
          text: " below, when it appears inside an equality test). Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L178',
          children: [
            {
              text: 'narrow.ts',
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
          text: "function narrowUnary(env: Env, ast: AST.UnaryExpression, assume: boolean) {\n  switch (ast.operator) {\n    case '!':\n      return narrow(env, ast.argument, !assume);\n\n    case 'typeof':\n      return env;\n\n    default: bug(`unexpected ${ast.operator}`);\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h4',
      children: [
        {
          text: 'narrowLogical',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'When an ',
        },
        {
          text: '&&',
          code: true,
        },
        {
          text: '-expression is assumed true, both sides must be true, so we narrow assuming both sides are true. When an ',
        },
        {
          text: '&&',
          code: true,
        },
        {
          text: '-expression is assumed false, one side must be false: if we know the left side is true then we narrow assuming the right side is false; if we know the right side is true then we narrow assuming the left side is false; otherwise we deduce nothing. (The case for ',
        },
        {
          text: '||',
          code: true,
        },
        {
          text: "-expressions follows similar reasoning.) Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L197',
          children: [
            {
              text: 'narrow.ts',
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
      language: 'typescript',
      children: [
        {
          text: "function narrowLogical(env: Env, ast: AST.LogicalExpression, assume: boolean) {\n  switch (ast.operator) {\n    case '&&':\n      if (assume) {\n        env = narrow(env, ast.left, true);\n        return narrow(env, ast.right, true);\n      } else {\n        if (Type.isTruthy(synth(env, ast.left)))\n          return narrow(env, ast.right, false);\n        else if (Type.isTruthy(synth(env, ast.right)))\n          return narrow(env, ast.left, false);\n        else\n          return env;\n      }\n\n    case '||':\n      if (!assume) {\n        env = narrow(env, ast.left, false);\n        return narrow(env, ast.right, false);\n      } else {\n        if (Type.isFalsy(synth(env, ast.left)))\n          return narrow(env, ast.right, true);\n        else if (Type.isFalsy(synth(env, ast.right)))\n          return narrow(env, ast.left, true);\n        else\n          return env;\n      }\n\n    default: bug(`unexpected AST ${ast.operator}`);\n  }\n}",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "When we don't know that one side is true, we still know that one side must be false! We could express this by the logical statement",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(NOT ast.left) OR (NOT ast.right)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'but we have no way to represent this statement using type environments. We have union and negation types, but they describe individual variables; ',
        },
        {
          text: 'ast.left',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'ast.right',
          code: true,
        },
        {
          text: ' could mention different variables or be arbitrarily complicated logical statements.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Actual TypeScript doesn't do much better here; it seems to deduce the disjunction only for tests involving the same variable:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const z = 1 as 1 | 2 | 3\n\nif (z !== 1 && z !== 2) {\n  z // z has type 3\n} else if (z !== 1) {\n  z // z has type 2\n  // because ((NOT (z !== 1)) OR (NOT (z !== 2))) AND (z !== 1)\n  // implies NOT (z !== 2)\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "This doesn't work for two different variables, or for two properties of the same object.",
        },
      ],
    },
    {
      type: 'h4',
      children: [
        {
          text: 'narrowBinary',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'When an ',
        },
        {
          text: '===',
          code: true,
        },
        {
          text: '-expression is assumed true (or a ',
        },
        {
          text: '!==',
          code: true,
        },
        {
          text: '-expression assumed false), we can deduce the logical statement',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'ast.left === ast.right',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "We can't represent this directly with types and environments, but we can represent the statement that each side has the same type as the other side (since the value must satisfy both types); so we narrow each side to the type of the other.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'When a ',
        },
        {
          text: '!==',
          code: true,
        },
        {
          text: '-expression is assumed true (or an ',
        },
        {
          text: '===',
          code: true,
        },
        {
          text: '-expression assumed false), we can deduce the logical statement',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'ast.left !== ast.right',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'When one side has singleton type we can narrow the other side to the negation of the singleton type; in other cases we have no way to represent the statement.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L235',
          children: [
            {
              text: 'narrow.ts',
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
          text: "function narrowBinary(env: Env, ast: AST.BinaryExpression, assume: boolean) {\n  if (!AST.isExpression(ast.left)) bug(`unimplemented ${ast.left.type}`);\n  const left = synth(env, ast.left);\n  const right = synth(env, ast.right);\n\n  if (ast.operator === '===' && assume || ast.operator === '!==' && !assume) {\n    env = narrowPath(env, ast.left, right);\n    return narrowPath(env, ast.right, left);\n\n  } else if (ast.operator === '!==' && assume || ast.operator === '===' && !assume) {\n    if (Type.isSingleton(right))\n      env = narrowPath(env, ast.left, Type.not(right));\n    if (Type.isSingleton(left))\n      env = narrowPath(env, ast.right, Type.not(left));\n    return env;\n\n  } else return env;\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'narrowPath',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's the top-level ",
        },
        {
          text: 'narrowPath',
          code: true,
        },
        {
          text: ' function (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L157',
          children: [
            {
              text: 'narrow.ts',
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
          text: "function narrowPath(env: Env, ast: AST.Expression, type: Type): Env {\n  switch (ast.type) {\n    case 'Identifier':\n      return narrowPathIdentifier(env, ast, type);\n\n    case 'MemberExpression':\n      return narrowPathMember(env, ast, type);\n\n    case 'UnaryExpression':\n      return narrowPathUnary(env, ast, type);\n\n    default: return env;\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'For ASTs representing paths we dispatch to AST-specific functions; otherwise we deduce nothing.',
        },
      ],
    },
    {
      type: 'h4',
      children: [
        {
          text: 'narrowPathIdentifier',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For an identifier, we look up the current type in the environment, narrow it to the deduced type with ',
        },
        {
          text: 'narrowType',
          code: true,
        },
        {
          text: ', then update the environment (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L83',
          children: [
            {
              text: 'narrow.ts',
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
          text: "function narrowPathIdentifier(env: Env, ast: AST.Identifier, type: Type) {\n  const ident = env.get(ast.name);\n  if (!ident) bug('expected bound identifer');\n  return env.set(ast.name, narrowType(ident, type));\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h4',
      children: [
        {
          text: 'narrowPathMember',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "As above, we can't directly represent a logical statement giving a type to a member expression like",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x.type: 'a'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'so we turn it into the equivalent',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "x: { type: 'a' }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L95',
          children: [
            {
              text: 'narrow.ts',
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
          text: 'function narrowPathMember(env: Env, ast: AST.MemberExpression, type: Type) {\n  if (ast.computed) bug(`unimplemented computed`);\n  if (!AST.isIdentifier(ast.property)) bug(`unexpected ${ast.property.type}`);\n  return narrowPath(\n    env,\n    ast.object,\n    Type.object({ [ast.property.name]: type })\n  );\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h4',
      children: [
        {
          text: 'narrowPathUnary',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For a logical statement like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "typeof x === 'boolean'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'we give the left side the equivalent singleton type (via ',
        },
        {
          text: 'narrowBinary',
          code: true,
        },
        {
          text: ')',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "typeof x: 'boolean'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'then deduce information about ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' from the type of ',
        },
        {
          text: 'typeof x',
          code: true,
        },
        {
          text: ". Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L111',
          children: [
            {
              text: 'narrow.ts',
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
          text: "function narrowPathUnary(env: Env, ast: AST.UnaryExpression, type: Type) {\n  switch (ast.operator) {\n    case '!':\n      return env;\n\n    case 'typeof':\n      if (Type.isSingleton(type)) {\n        switch (type.value) {\n          case 'boolean':\n            return narrowPath(env, ast.argument, Type.boolean);\n          case 'number':\n            return narrowPath(env, ast.argument, Type.number);\n          case 'string':\n            return narrowPath(env, ast.argument, Type.string);\n          case 'object':\n            return narrowPath(env, ast.argument, Type.object({}));\n          default: return env;\n        }\n      } else if (Type.isNot(type) && Type.isSingleton(type.base)) {\n        switch (type.base.value) {\n          case 'boolean':\n            return narrowPath(env, ast.argument, Type.not(Type.boolean));\n          case 'number':\n            return narrowPath(env, ast.argument, Type.not(Type.number));\n          case 'string':\n            return narrowPath(env, ast.argument, Type.not(Type.string));\n          case 'object':\n            return narrowPath(env, ast.argument, Type.not(Type.object({})));\n          default: return env;\n        }\n      }\n      else return env;\n\n    default: bug(`unexpected ${ast.operator}`);\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'If the ',
        },
        {
          text: 'typeof',
          code: true,
        },
        {
          text: ' a path satisfies the negation of a singleton type tag, we deduce that the path must satisfy the negation of the corresponding type. All object types are subtypes of ',
        },
        {
          text: '{}',
          code: true,
        },
        {
          text: '; but we have no way to represent a type that includes all functions, so for ',
        },
        {
          text: "'function'",
          code: true,
        },
        {
          text: ' we deduce nothing.',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'narrowType',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'As above, ',
        },
        {
          text: 'narrowType(x, y)',
          code: true,
        },
        {
          text: ' corresponds to a logical statement that some variable has type ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' AND it has type ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: "; so it's a kind of intersection of ",
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
          text: ". However, we don't implement it with ",
        },
        {
          text: 'Type.intersection',
          code: true,
        },
        {
          text: '. There are two reasons for this:',
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
                  text: 'narrowType',
                  code: true,
                },
                {
                  text: ' handles ',
                },
                {
                  text: 'Not',
                  code: true,
                },
                {
                  text: "-types; we don't want to hair up the rest of the type checker with ",
                },
                {
                  text: 'Not',
                  code: true,
                },
                {
                  text: '-types, so we have a specialized function.',
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
                  text: 'Type.intersection',
                  code: true,
                },
                {
                  text: " doesn't normalize inside object types (see ",
                },
                {
                  type: 'a',
                  href: '/blog/2021-10-28-Reconstructing-TypeScript-part-5#normalizing-intersection-types',
                  children: [
                    {
                      text: 'part 5',
                    },
                  ],
                },
                {
                  text: '), but our strategy in ',
                },
                {
                  text: 'narrowPathMember',
                  code: true,
                },
                {
                  text: " produces intersections of object types that we'd like to normalize to produce more readable types.",
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
          text: "Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L30',
          children: [
            {
              text: 'narrow.ts',
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
          text: 'function narrowType(x: Type, y: Type): Type {\n  if (Type.isNever(x) || Type.isNever(y)) return Type.never;\n  if (Type.isUnknown(x)) return widenNots(y);\n  if (Type.isUnknown(y)) return x;\n\n  if (Type.isUnion(x))\n    return Type.union(...x.types.map(a => narrowType(a, y)));\n  if (Type.isUnion(y))\n    return Type.union(...y.types.map(b => narrowType(x, b)));\n\n  if (Type.isIntersection(x))\n    return Type.intersection(...x.types.map(a => narrowType(a, y)));\n  if (Type.isIntersection(y))\n    return Type.intersection(...y.types.map(b => narrowType(x, b)));\n\n  if (Type.isNot(y)) {\n    if (Type.isSubtype(x, y.base)) {\n      return Type.never;\n    } else if (Type.isBoolean(x) && Type.isSingleton(y.base) && Type.isBoolean(y.base.base)) {\n      return Type.singleton(!y.base.value);\n    } else {\n      return x;\n    }\n  }\n\n  if (Type.isSingleton(x) && Type.isSingleton(y))\n    return (x.value === y.value) ? x : Type.never;\n  if (Type.isSingleton(x))\n    return (x.base.type === y.type) ? x : Type.never;\n  if (Type.isSingleton(y))\n    return (y.base.type === x.type) ? y : Type.never;\n\n  if (Type.isObject(x) && Type.isObject(y)) {\n    const properties =\n      x.properties.map(({ name, type: xType }) => {\n          const yType = Type.propType(y, name);\n          const type = yType ? narrowType(xType, yType) : xType;\n          return { name, type };\n          // if there are  fields in `y` that are not in `x`, ignore them\n        },\n        { }\n      );\n    if (properties.some(({ type }) => Type.isNever(type)))\n      return Type.never;\n    else\n      return Type.object(properties);\n  }\n\n  return Type.intersection(x, y);\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'narrowType',
          code: true,
        },
        {
          text: ' is similar to ',
        },
        {
          text: 'overlaps',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-28-Reconstructing-TypeScript-part-5#detecting-empty-intersections',
          children: [
            {
              text: 'part 5',
            },
          ],
        },
        {
          text: '); but instead of returning a flag it returns a type representing the overlap between its arguments (or ',
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: " if they don't overlap).",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          code: true,
          text: 'narrowType',
        },
        {
          text: ' accepts ',
        },
        {
          text: 'Not',
          code: true,
        },
        {
          text: '-types in its second argument, but does not return ',
        },
        {
          text: 'Not-',
          code: true,
        },
        {
          text: 'types; so we never put ',
        },
        {
          text: 'Not',
          code: true,
        },
        {
          text: "-types in the environment, and the rest of the type checker doesn't need to deal with them.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Normally ',
        },
        {
          text: 'unknown & t',
          code: true,
        },
        {
          text: ' ',
        },
        {
          text: '=== t',
          code: true,
        },
        {
          text: ' for any type ',
        },
        {
          text: 't',
          code: true,
        },
        {
          text: ', but here ',
        },
        {
          text: 't',
          code: true,
        },
        {
          text: ' might contain ',
        },
        {
          text: 'Not',
          code: true,
        },
        {
          text: '-types, so in this case we call ',
        },
        {
          text: 'widenNots',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/narrow.ts#L8',
          children: [
            {
              text: 'narrow.ts',
            },
          ],
        },
        {
          text: ') to remove them.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'If the second argument is ',
        },
        {
          text: '!t',
          code: true,
        },
        {
          text: ' and the first argument is a subtype of ',
        },
        {
          text: 't',
          code: true,
        },
        {
          text: ", then there's no overlap between them, so we return ",
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: '. Along with the union rule, this makes types like ',
        },
        {
          text: '0|1 & !1',
          code: true,
        },
        {
          text: ' reduce to ',
        },
        {
          text: '0',
          code: true,
        },
        {
          text: '; but since ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ' is not explicitly a union, we special-case it so ',
        },
        {
          text: 'boolean & !true',
          code: true,
        },
        {
          text: ' reduces to ',
        },
        {
          text: 'false',
          code: true,
        },
        {
          text: ' (and vice versa).',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Using narrowing in type checking',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "OK! Now we know how to narrow type environments to incorporate information deduced from tests—let's see how to apply it in type checking:",
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Synthesizing types from conditional expressions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'A conditional expression parses into a ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L429',
          children: [
            {
              text: 'ConditionalExpression',
              code: true,
            },
          ],
        },
        {
          text: ' AST node. To synthesize a type from it, we',
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
                  text: 'synthesize a type from the the test expression',
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
                  text: 'synthesize a type from the true branch (also known as the ',
                },
                {
                  text: 'consequent',
                  italic: true,
                },
                {
                  text: '), using an environment narrowed with the assumption that the test is true',
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
                  text: 'synthesize a type from the false branch (also known as the ',
                },
                {
                  text: 'alternate',
                  italic: true,
                },
                {
                  text: '), using an environment narrowed with the assumption that the test is false',
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
                  text: 'return the union of the true and false branch types',
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
          text: "Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/synth.ts#L230',
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
          text: "function synth(env: Env, ast: AST.Expression): Type {\n  ...\n  case 'ConditionalExpression': return synthConditional(env, ast);\n  ...\n}\n\nfunction synthConditional(env: Env, ast: AST.ConditionalExpression): Type {\n  const test = synth(env, ast.test);\n  const consequent = () => synth(narrow(env, ast.test, true), ast.consequent)\n  const alternate = () => synth(narrow(env, ast.test, false), ast.alternate);\n  if (Type.isTruthy(test))\n    return consequent();\n  else if (Type.isFalsy(test))\n    return alternate();\n  else\n    return Type.union(consequent(), alternate());\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "When the test is true, we return the type of the consequent directly, and don't type check the alternate at all (and similarly when it's false). This is a little weird! It means you can put nonsense in an untaken branch, like",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'true ? 7 : 7(9)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "But it's correct in the sense that the untaken branch is never executed, so its type (or whether it has type errors) can't matter. And it makes it possible to check expressions against intersection types. For example, in",
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: "(x => 0 + (typeof x === 'number' ? x : x(7))) as\n  ((x: number) => number) & ((x: ((n: number) => number)) => number)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'we check the function expression against the intersection by separately checking against each part (',
        },
        {
          text: '0 +',
          code: true,
        },
        {
          text: ' before the conditional forces it to be synthesized, not checked); when checking against the first part, the environment contains ',
        },
        {
          text: 'x: number',
          code: true,
        },
        {
          text: ', so ',
        },
        {
          text: 'x(7)',
          code: true,
        },
        {
          text: ' would cause a type error, but ',
        },
        {
          text: "typeof x === 'number'",
          code: true,
        },
        {
          text: " is true, so we don't type check the false branch.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "One way to think about what's happening here is that if we did type check the untaken branch, ",
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' would be narrowed to ',
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: '. We could add a case to ',
        },
        {
          text: 'Type.map',
          code: true,
        },
        {
          text: ' to propagate ',
        },
        {
          text: 'never',
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
          text: 'function map(t: Type, fn: (t: Type) => Type)) {\n  if (Type.isNever(t)) return Type.never;\n  ...\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "Then we'd synthesize ",
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: ' from ',
        },
        {
          text: 'x(7)',
          code: true,
        },
        {
          text: ' in the untaken branch, so the example would type check without error. But total nonsense like ',
        },
        {
          text: '7(9)',
          code: true,
        },
        {
          text: ' would cause an error. This might be a good idea?',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Actual TypeScript flags an unreachable code error for untaken branches, but still type checks both branches.',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Checking conditional expressions against types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To check a conditional expression against an expected type we',
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
                  text: 'synthesize a type from the the test expression',
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
                  text: 'check the true branch against the expected type, using an environment narrowed with the assumption that the test is true',
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
                  text: 'check the false branch against the expected type, using an environment narrowed with the assumption that the test is false',
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
          text: "Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/check.ts#L55',
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
          text: 'function check(env: Env, ast: AST.Expression, type: Type): void {\n  ...\n  if (AST.isConditionalExpression(ast))\n    return checkConditional(env, ast, type);\n  ...\n}\n\nfunction checkConditional(env: Env, ast: AST.ConditionalExpression, type: Type): void {\n  const test = synth(env, ast.test);\n  const consequent = () => check(narrow(env, ast.test, true), ast.consequent, type)\n  const alternate = () => check(narrow(env, ast.test, false), ast.alternate, type)\n  if (Type.isTruthy(test)) {\n    consequent();\n  } else if (Type.isFalsy(test)) {\n    alternate();\n  } else {\n    consequent();\n    alternate();\n  }\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Narrowing in logical operators',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Because logical operators are short-circuit, we can also narrow the environment when type checking the right side. For an ',
        },
        {
          text: '&&',
          code: true,
        },
        {
          text: '-expression, the right side is executed only when the left side is true, so we narrow assuming the left side is true (and similarly for an ',
        },
        {
          text: '||',
          code: true,
        },
        {
          text: '-expression).',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "We can finally give a precise result type for logical expressions when we don't know whether the left side is true or false: it's the union of the types of the sides, but the left side is narrowed to falsy values for ",
        },
        {
          text: '&&',
          code: true,
        },
        {
          text: ' (',
        },
        {
          type: 'a',
          href: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_AND#short-circuit_evaluation',
          children: [
            {
              text: 'when the left side is not falsy the right side is returned',
            },
          ],
        },
        {
          text: ') and truthy values for ',
        },
        {
          text: '||',
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
          text: "Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part6/src/typecheck/synth.ts#L164',
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
          text: "function synthLogical(env: Env, ast: AST.LogicalExpression): Type {\n  const left = synth(env, ast.left);\n  const right = () => synth(narrow(env, ast.left, ast.operator === '&&'), ast.right);\n  switch (ast.operator) {\n    case '&&':\n      if (Type.isFalsy(left))\n        return left;\n      else if (Type.isTruthy(left))\n        return right();\n      else\n        return Type.union(narrowType(left, Type.falsy), right());\n\n    case '||':\n      if (Type.isTruthy(left))\n        return left;\n      else if (Type.isFalsy(left))\n        return right();\n      else\n        return Type.union(narrowType(left, Type.truthy), right());\n\n    default: bug(`unimplemented ${ast.operator}`);\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Aside: narrowing as logical implication, revisited',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'I wrote the narrowing code by following my nose; later I read a research paper (',
        },
        {
          type: 'a',
          href: 'https://www2.ccs.neu.edu/racket/pubs/icfp10-thf.pdf',
          children: [
            {
              text: 'Logical Types for Untyped Languages',
            },
          ],
        },
        {
          text: ') that gave me a different perspective on what the code does, and alerted me to some deficiencies:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "As above, there are some logical statements that can't be represented faithfully (such as the disjunction produced by assuming an ",
        },
        {
          text: '&&',
          code: true,
        },
        {
          text: '-expression false).',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Also, our implementation does redundant work: for example, in',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'a && b && c',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'b',
          code: true,
        },
        {
          text: ' is typechecked in an environment narrowed with ',
        },
        {
          text: 'a',
          code: true,
        },
        {
          text: ', and ',
        },
        {
          text: 'c',
          code: true,
        },
        {
          text: ' is typechecked in an environment narrowed with ',
        },
        {
          text: 'a && b',
          code: true,
        },
        {
          text: ', which narrows ',
        },
        {
          text: 'a',
          code: true,
        },
        {
          text: ' again. The problem is that narrowing information is not returned from ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ', so must be reconstructed. In the paper, ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' returns a type and also a pair of logical statements representing what can be deduced from the expression if it is assumed true or false.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'It would be interesting to rewrite the type checker to use explicit logical statements to avoid these issues.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Also, I wonder if representing union and intersection types as logical statements might address the problems of incomplete subtyping (see ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-14-Reconstructing-TypeScript-part-4#subtyping-union-types',
          children: [
            {
              text: 'part 4',
            },
          ],
        },
        {
          text: ' and ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-28-Reconstructing-TypeScript-part-5#subtyping-intersection-types',
          children: [
            {
              text: 'part 5',
            },
          ],
        },
        {
          text: '). Subtyping can be seen as a kind of logical implication; maybe it can be implemented like a SAT solver? If you know something about this please get in touch!',
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
          text: "You can try out the type checker below. Click on an example button or type an expression in the top box. In the bottom box you'll see a trace of the type checker execution, ending in a synthesized type (or an error). The trace is a tree of function calls; click on a function call to expand the tree under that call, or mouse over a call to highlight the matching return value.",
        },
      ],
    },
    {
      type: 'liveCode',
      children: [
        {
          text: '<iframe\n  src="https://jaked.org/reconstructing-typescript/part6/"\n  width={700}\n  height={500}\n  style={{ borderStyle: \'none\' }}\n/>',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'I love it when a plan comes together',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For the full code of part 6 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/tree/part6',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/tree/part6',
            },
          ],
        },
        {
          text: '. To view the changes between part 5 and part 6 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/compare/part5...part6',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/compare/part5...part6',
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
          text: "Here's the whole series:",
        },
      ],
    },
    {
      type: 'liveCode',
      children: [
        {
          text: '<Parts />',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'There are other interesting aspects of TypeScript that I might cover in the future, like',
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
                  href: 'https://www.typescriptlang.org/docs/handbook/2/generics.html',
                  children: [
                    {
                      text: 'generic types',
                    },
                  ],
                },
                {
                  text: ' and type parameter inference',
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
                  text: 'recursive types',
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
                  href: 'https://www.typescriptlang.org/docs/handbook/2/types-from-types.html',
                  children: [
                    {
                      text: 'type-level computation',
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
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'but for now this is the last part of Reconstructing TypeScript. Thanks for reading!',
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
    publish: true,
    layout: '/layout',
    title: 'How to implement a TypeScript-style type checker (Reconstructing TypeScript), part 6: narrowing',
  },
}
