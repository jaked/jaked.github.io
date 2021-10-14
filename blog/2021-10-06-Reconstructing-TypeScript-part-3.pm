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
          text: ' > Reconstructing TypeScript, part 3',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Reconstructing TypeScript, part 3: operators and singleton types',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-10-06',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'This post is part of a series about implementing type checking for a TypeScript-like language. In ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-27-Reconstructing-TypeScript-part-2',
          children: [
            {
              text: 'part 2',
            },
          ],
        },
        {
          text: ' we added functions and function applications to the core bidirectional type checker from ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1',
          children: [
            {
              text: 'part 1',
            },
          ],
        },
        {
          text: ". In this part we'll add operator expressions like:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'x + y\nx && y\nx || y\n!x\ntypeof x\nx === y\nx !== y',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      language: 'typescript',
      children: [
        {
          text: "so we'll be able to write more interesting programs. We'll also add a new kind of type: ",
        },
        {
          text: 'singleton',
          italic: true,
        },
        {
          text: ' types (also known as ',
        },
        {
          text: 'literal',
          italic: true,
        },
        {
          text: ' types) that contain a single value.',
        },
      ],
    },
    {
      type: 'p',
      language: 'typescript',
      children: [
        {
          text: 'These two new features are connected: when the inputs to an operator have singleton types, the type checker can compute the output value at type checking time, and synthesize a singleton output type. This gives the type checker more information to work with, so it can successfully synthesize a type for more programs.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: "What's a singleton type?",
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
          type: 'a',
          href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0',
          children: [
            {
              text: 'part 0',
            },
          ],
        },
        {
          text: ' I wrote that a type',
        },
      ],
    },
    {
      type: 'blockquote',
      children: [
        {
          type: 'p',
          children: [
            {
              text: 'describes attributes shared by [a collection of] values: what operations are supported; and, for some operations, what result they return.',
            },
          ],
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We say that a type ',
        },
        {
          text: 'contains',
          italic: true,
        },
        {
          text: ' a value (or that a value ',
        },
        {
          text: 'satisfies',
          italic: true,
        },
        {
          text: ' a type) when the value has all the attributes that are described by the type.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'A ',
        },
        {
          text: 'singleton',
          italic: true,
        },
        {
          text: ' type is a type that contains a single value. For example: ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ' is the type that contains the value ',
        },
        {
          text: '7',
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
          text: ' is the type that contains the value ',
        },
        {
          text: 'true',
          code: true,
        },
        {
          text: ', and so on. You might object—there is not just one value ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ', my program is littered with ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: "s! OK, fair, let's try again: a singleton type contains all the values that are ",
        },
        {
          text: '===',
          code: true,
        },
        {
          text: ' to a particular value. (JavaScript has a ',
        },
        {
          type: 'a',
          href: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Equality_comparisons_and_sameness',
          children: [
            {
              text: 'profusion of equalities',
            },
          ],
        },
        {
          text: ' so we should be specific which one we mean.)',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The value of a singleton type has some underlying base type (',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' for ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ' for ',
        },
        {
          text: 'true',
          code: true,
        },
        {
          text: ', and so on), so we call that the base type of the singleton type. A singleton type supports all the same operations as its base type; but it adds some information about what results are returned by the operations for its particular value. For example: in an expression ',
        },
        {
          text: 'x === 7',
          code: true,
        },
        {
          text: ', if ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' has type ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: " we don't know whether the expression returns ",
        },
        {
          text: 'true',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'false',
          code: true,
        },
        {
          text: '; but if ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' has type ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ' we know that it returns ',
        },
        {
          text: 'true',
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
          text: 'What about a compound type like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: 7, bar: true }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: '? This type contains all the values that have a ',
        },
        {
          text: 'foo',
          code: true,
        },
        {
          text: ' property with type ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ' and a ',
        },
        {
          text: 'bar',
          code: true,
        },
        {
          text: ' property with type ',
        },
        {
          text: 'true',
          code: true,
        },
        {
          text: ', like:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "{ foo: 7, bar: true }\n{ foo: 7, bar: true, baz: 'hello' }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "It's tempting to read it as the type of values equal to ",
        },
        {
          text: '{ foo: 7, bar: true }',
          code: true,
        },
        {
          text: ', but in TypeScript there are only singleton types of primitive values.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The TypeScript docs call these ',
        },
        {
          type: 'a',
          href: 'https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#literal-types',
          children: [
            {
              text: 'literal',
              italic: true,
            },
            {
              text: ' types',
            },
          ],
        },
        {
          text: "; they're called singleton types in some other languages.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'What are singleton types good for?',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "By themselves, singleton types aren't very useful. But with unions, we can use them to define enumerations:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "type color = 'red' | 'green' | 'blue'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'or variants:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "type tree =\n  { type: 'leaf', value: number } |\n  { type: 'node', left: tree, right: tree }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'And with ',
        },
        {
          text: 'intersection',
          italic: true,
        },
        {
          text: ' types (more on this in part 5), we can use singleton types to describe overloaded functions that return different types based on argument values, like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "const getElementsByTagName:\n  ((tag: 'div') => HTMLDivElement[]) &\n  ((tag: 'p') => HTMLParagraphElement[]) &\n  ...",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Representing singleton types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To represent singleton types we add an arm to the ',
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part3/src/type/types.ts#L37',
          children: [
            {
              text: 'types.ts',
            },
          ],
        },
        {
          text: ') containing the base type (as above, we permit only primitive types) and value:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "type Type = ... | Singleton;\n\ntype Singleton = {\n  type: 'Singleton';\n  base: Boolean | Number | String;\n  value: unknown;\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'When ',
        },
        {
          text: 'base',
          code: true,
        },
        {
          text: ' is ',
        },
        {
          text: 'Boolean',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'value',
          code: true,
        },
        {
          text: ' is always a ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ", and so on. (We could encode this invariant in the type, but it turns out not to work well with TypeScript's narrowing—give it a try and see what goes wrong; more on this later.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The type of ',
        },
        {
          text: 'base',
          code: true,
        },
        {
          text: ' is an example of the flexibility of unions: we want to restrict ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' to just its ',
        },
        {
          text: 'Boolean',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'Number',
          code: true,
        },
        {
          text: ', and ',
        },
        {
          text: 'String',
          code: true,
        },
        {
          text: " arms, so we simply write the union of those arms. In most languages this is much more painful: in most object-oriented languages we'd need to bake it into the class hierarchy; in most languages with variants we'd need a separate variant—either way, it's painful enough that we'd most likely give ",
        },
        {
          text: 'base',
          code: true,
        },
        {
          text: ' the type ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' instead, and check the restriction at run time (losing some development-time checking).',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'As usual we add a constructor function (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part3/src/type/constructors.ts#L20',
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
          text: "function singleton(value: boolean | number | string): Singleton {\n  switch (typeof value) {\n    case 'boolean': return { type: 'Singleton', base: boolean, value };\n    case 'number': return { type: 'Singleton', base: number, value };\n    case 'string': return { type: 'Singleton', base: string, value };\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and a validator function (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part3/src/type/validators.ts#L27',
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
          text: "function isSingleton(type: Type): type is Singleton {\n  return type.type === 'Singleton';\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and cases for singleton types in ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part3/src/type/toString.ts#L24',
          children: [
            {
              text: 'toString.ts',
            },
          ],
        },
        {
          text: ' and ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part3/src/type/ofTSType.ts#L40',
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
      type: 'h2',
      children: [
        {
          text: 'Synthesizing types from primitive values',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now when synthesizing types from primitive expressions (',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L556',
          children: [
            {
              text: 'BooleanLiteral',
              code: true,
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L539',
          children: [
            {
              text: 'NumericLiteral',
              code: true,
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L534',
          children: [
            {
              text: 'StringLiteral',
              code: true,
            },
          ],
        },
        {
          text: '), we return a singleton type instead of the underlying base type (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part3/src/typecheck/synth.ts#L22',
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
          text: 'function synthBoolean(env: Env, ast: AST.BooleanLiteral): Type {\n  return Type.singleton(ast.value);\n}\n\nfunction synthNumber(env: Env, ast: AST.NumericLiteral): Type {\n  return Type.singleton(ast.value);\n}\n\nfunction synthString(env: Env, ast: AST.StringLiteral): Type {\n  return Type.singleton(ast.value);\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "In actual TypeScript, singleton types are synthesized for immutable values but not mutable values. This makes sense—a mutable value of singleton type is effectively immutable, since you can only mutate it to another value that's ",
        },
        {
          text: '===',
          code: true,
        },
        {
          text: ' to the original. For example:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const x = 7  // x has type 7\nlet y = true // y has type boolean\n\nconst obj1 = { foo: 7, bar: true }\n// obj1 has type { foo: number, bar: boolean }\n\nconst obj2 = { foo: 7, bar: true } as const\n// obj2 has type { readonly foo: 7, readonly bar: true }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'In our language we have only immutable values, so we always synthesize singleton types.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Synthesizing types from operator expressions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We add cases to ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' for different kinds of operator expression (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part3/src/typecheck/synth.ts#L217',
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
          text: "function synth(env: Env, ast: AST.Expression): Type {\n  ...\n  case 'BinaryExpression':  return synthBinary(env, ast);\n  case 'LogicalExpression': return synthLogical(env, ast);\n  case 'UnaryExpression':   return synthUnary(env, ast);\n  ...\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Binary operators',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For binary operators (',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L357',
          children: [
            {
              text: 'BinaryExpression',
              code: true,
            },
          ],
        },
        {
          text: ') we:',
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
                  text: 'synthesize types from the ',
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
                  text: ' subexpressions;',
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
                  text: 'when both have singleton type, apply the operator and return a singleton type;',
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
                  text: 'otherwise return the appropriate base type,',
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
          text: "Here's the code:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function synthBinary(env: Env, ast: AST.BinaryExpression): Type {\n  if (!AST.isExpression(ast.left)) bug(`unimplemented ${ast.left.type}`)\n  const left = synth(env, ast.left);\n  const right = synth(env, ast.right);\n  switch (ast.operator) {\n    case '===':\n      if (Type.isSingleton(left) && Type.isSingleton(right))\n        return Type.singleton(left.value === right.value);\n      else\n        return Type.boolean;\n\n    case '!==':\n      if (Type.isSingleton(left) && Type.isSingleton(right))\n        return Type.singleton(left.value !== right.value);\n      else\n        return Type.boolean;\n\n    case '+':\n      if (Type.isSubtype(left, Type.number) && Type.isSubtype(right, Type.number)) {\n        if (Type.isSingleton(left) && Type.isSingleton(right)) {\n          if (typeof left.value !== 'number' || typeof right.value !== 'number')\n            bug('unexpected value');\n          return Type.singleton(left.value + right.value);\n        } else {\n          return Type.number;\n        }\n      } else {\n        err('+ expects numbers', ast);\n      }\n\n    default: bug(`unimplemented ${ast.operator}`);\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'In the case for ',
        },
        {
          text: '+',
          code: true,
        },
        {
          text: ', we check subtyping rather than equality with ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ', so we can add a singleton ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' to a ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' or vice versa. (See below about ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-06-Reconstructing-TypeScript-part-3#subtyping-singleton-types',
          children: [
            {
              text: 'subtyping singleton types',
            },
          ],
        },
        {
          text: '.)',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Actual TypeScript does not synthesize singleton types for these operators. I have some ideas about why not, but let's go with it for now and see where it leads.",
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Logical operators',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "We'll need some helper functions that determine whether values of a type are known at type checking time to be ",
        },
        {
          type: 'a',
          href: 'https://developer.mozilla.org/en-US/docs/Glossary/Truthy',
          children: [
            {
              text: 'truthy or falsy',
            },
          ],
        },
        {
          text: '. For singletons we can check the specific value; otherwise we know that objects and functions are always truthy, ',
        },
        {
          text: 'null',
          code: true,
        },
        {
          text: " is falsy, and for numbers, strings, and booleans we don't know.",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function isTruthy(type: Type) {\n  switch (type.type) {\n    case 'Object':    return true;\n    case 'Function':  return true;\n    case 'Singleton': return type.value;\n    default:          return false;\n  }\n}\n\nfunction isFalsy(type: Type) {\n  switch (type.type) {\n    case 'Null':      return true;\n    case 'Singleton': return !type.value;\n    default:          return false;\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now for logical operators (',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L576',
          children: [
            {
              text: 'LogicalExpression',
              code: true,
            },
          ],
        },
        {
          text: ') we:',
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
                  text: 'synthesize types from the ',
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
                  text: ' subexpressions;',
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
                  text: 'when we know at type checking time which subexpression is returned, then return its type (recall that in JavaScript ',
                },
                {
                  type: 'a',
                  href: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Logical_AND',
                  children: [
                    {
                      text: 'logical operators are short-circuit and return the value of the last-evaluated subexpression',
                    },
                  ],
                },
                {
                  text: ');',
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
                  text: 'otherwise return ',
                },
                {
                  text: 'boolean',
                  code: true,
                },
                {
                  text: " (this is not correct but we can't return the correct type until we add unions in part 4).",
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
          text: "Here's the code:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function synthLogical(env: Env, ast: AST.LogicalExpression): Type {\n  const left = synth(env, ast.left);\n  const right = synth(env, ast.right);\n  switch (ast.operator) {\n    case '&&':\n      if (Type.isFalsy(left))       return left;\n      else if (Type.isTruthy(left)) return right;\n      else                          return Type.boolean; // left | right\n\n    case '||':\n      if (Type.isTruthy(left))      return left;\n      else if (Type.isFalsy(left))  return right;\n      else                          return Type.boolean; // left | right\n\n    default: bug(`unimplemented ${ast.operator}`);\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Actual TypeScript does synthesize singleton types for these operators—for example:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const a = 7\nconst b = 9\nconst x = (a && b) // x has type 9',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Unary operators',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For unary operators (',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L705',
          children: [
            {
              text: 'UnaryExpression',
              code: true,
            },
          ],
        },
        {
          text: ') we',
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
                  text: 'synthesize a type from the ',
                },
                {
                  text: 'argument',
                  code: true,
                },
                {
                  text: ' subexpression;',
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
                  text: 'for ',
                },
                {
                  text: '!',
                  code: true,
                },
                {
                  text: ' return a singleton if we know whether the argument is truthy or falsy; otherwise return ',
                },
                {
                  text: 'boolean',
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
                  text: 'for ',
                },
                {
                  text: 'typeof',
                  code: true,
                },
                {
                  text: ' return the appropriate singleton given the argument type.',
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
          text: "Here's the code:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function typeofType(type: Type): string {\n  switch (type.type) {\n    case 'Singleton': return typeofType(type.base);\n    case 'Boolean': return 'boolean';\n    case 'Function': return 'function';\n    case 'Null': return 'object';\n    case 'Number': return 'number';\n    case 'Object': return 'object';\n    case 'String': return 'string';\n  }\n}\n\nfunction synthUnary(env: Env, ast: AST.UnaryExpression): Type {\n  const argument = synth(env, ast.argument);\n  switch (ast.operator) {\n    case '!':\n      if (Type.isTruthy(argument))     return Type.singleton(false);\n      else if (Type.isFalsy(argument)) return Type.singleton(true);\n      else                             return Type.boolean;\n\n    case 'typeof':\n      return Type.singleton(typeofType(argument));\n\n    default: bug(`unimplemented ${ast.operator}`);\n  }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Actual TypeScript synthesizes singleton types for ',
        },
        {
          text: '!',
          code: true,
        },
        {
          text: ' but not for ',
        },
        {
          text: 'typeof',
          code: true,
        },
        {
          text: ". I don't know why not! But again let's go with it.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Subtyping singleton types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'A singleton type is a subtype of another singleton type only when they have the same value.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "A singleton type is always a subtype of its base type (as above, it supports all the same operations as its base type), so it's a subtype of another type when its base type is a subtype of the other type. So for example ",
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ". (We'll be able to construct less-trivial examples once we add unions.)",
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part3/src/type/isSubtype.ts#L27',
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
          text: 'function isSubtype(a: Type, b: Type): boolean {\n  ...\n  if (Type.isSingleton(a)) {\n    if (Type.isSingleton(b)) return a.value === b.value;\n    else                     return isSubtype(a.base, b);\n  }\n  ...\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Checking expressions against singleton types',
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
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1#checking-expressions-against-types',
          children: [
            {
              text: 'part 1',
            },
          ],
        },
        {
          text: " that to check an expression against a type, we break down the expression and type, then check their corresponding parts. But since we have singleton types for primitive values only, there's nothing to break down—we just fall back to the default: synthesize a type from the expression, then check that the synthesized type is a subtype of the expected type. So there is no new code to write.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Operator expressions are always synthesized; we can't in general deduce input types from output types. For example, to check ",
        },
        {
          text: 'x + y',
          code: true,
        },
        {
          text: ' against ',
        },
        {
          text: '16',
          code: true,
        },
        {
          text: ', we know that ',
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
          text: ' must have singleton ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' types that sum to ',
        },
        {
          text: '16',
          code: true,
        },
        {
          text: ", but we don't know how to split ",
        },
        {
          text: '16',
          code: true,
        },
        {
          text: " between them. So we fall back to synthesizing and checking subtyping. (In part 6 we'll see that narrowing involves deducing ",
        },
        {
          text: 'constraints',
          italic: true,
        },
        {
          text: ' on input types from output types.)',
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
          text: '<iframe\n  src="https://jaked.org/reconstructing-typescript/part3/"\n  width={700}\n  height={500}\n  style={{ borderStyle: \'none\' }}\n/>',
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
          text: 'For the full code of part 3 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/tree/part3',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/tree/part3',
            },
          ],
        },
        {
          text: '. To view the changes between part 2 and part 3 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/compare/part2...part3',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/compare/part2...part3',
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
          text: "Next time we'll add ",
        },
        {
          text: 'union',
          italic: true,
        },
        {
          text: ' types to represent type alternatives like ',
        },
        {
          text: 'string | boolean',
          code: true,
        },
        {
          text: '.',
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
          text: 'Thanks to Hazem Alhalabi for helpful feedback on a draft of this post.',
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
    title: 'Reconstructing TypeScript, part 3: singleton types and operators',
    layout: '/layout',
    publish: true,
  },
}