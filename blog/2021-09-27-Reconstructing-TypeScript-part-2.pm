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
          text: ' > Reconstructing TypeScript, part 2',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Reconstructing TypeScript, part 2: functions and function calls',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-09-27',
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
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1',
          children: [
            {
              text: 'last post',
            },
          ],
        },
        {
          text: ' we walked through the code for type checking a small fragment of the language, with only primitive literals, object expressions, and member expressions.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "In this part we'll add function definitions like",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(x: number, y: number) => ({ x: x, y: y })',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and function calls like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'f(7, 9)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "Since function definitions bind variables that can be used in the body of the function, we'll need to handle variable expressions like",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'x\ny',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "and also keep track of the types of variables. Let's start there:",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Environments',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'An ',
        },
        {
          text: 'environment',
          italic: true,
        },
        {
          text: ' is a table mapping variable names to types. A ',
        },
        {
          text: 'binding',
          italic: true,
        },
        {
          text: " is a single name-to-type entry in the environment. When type checking a function definition, we add a binding for each argument to the environment; when we encounter a variable in the function body, we look up its type in the environment; and we drop the new bindings after type checking the function, since they're no longer in scope.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'A straightforward way to implement this is with "functional update": to add a binding to an environment, copy the old environment and add the new binding. The old environment is not affected, so when we\'re finished type checking the function we discard the new environment and go back to the using the old one.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's the environment type (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/typecheck/env.ts',
          children: [
            {
              text: 'env.ts',
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
          text: 'type Env = {\n  get(name: string): Type | undefined;\n  set(name: string, type: Type): Env;\n  entries(): IterableIterator<[string, Type]>;\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'We can ',
        },
        {
          text: 'get',
          code: true,
        },
        {
          text: ' the type of a variable (it might be ',
        },
        {
          text: 'undefined',
          code: true,
        },
        {
          text: ' if the variable is unbound) or ',
        },
        {
          text: 'set',
          code: true,
        },
        {
          text: ' the type of a variable (returning a new environment). For debugging we can iterate over the ',
        },
        {
          text: 'entries',
          code: true,
        },
        {
          text: ' (bindings) in an environment.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's the environment constructor:",
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: 'function Env(map: Map<string, Type> | { [name: string]: Type }): Env {\n  if (map instanceof Map) {\n    return {\n      get: (name: string) => map.get(name),\n      set: (name: string, type: Type) =>\n        Env(new Map([...map, [name, type]]))\n      entries: () => map.entries()\n    }\n  } else {\n    return Env(new Map(Object.entries(map)));\n  }\n}',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Bindings are stored in an underlying ',
        },
        {
          text: 'Map',
          code: true,
        },
        {
          text: '; to ',
        },
        {
          text: 'get',
          code: true,
        },
        {
          text: ' the type of a variable, just look it up in the ',
        },
        {
          text: 'Map',
          code: true,
        },
        {
          text: '; to ',
        },
        {
          text: 'set',
          code: true,
        },
        {
          text: ' the type of a variable, copy the ',
        },
        {
          text: 'Map',
          code: true,
        },
        {
          text: ' and add the new binding. Like the ',
        },
        {
          text: 'Type.object',
          code: true,
        },
        {
          text: ' constructor from ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1#constructors',
          children: [
            {
              text: 'part 1',
            },
          ],
        },
        {
          text: ', ',
        },
        {
          text: 'Env',
          code: true,
        },
        {
          text: ' can also take an object mapping names to types.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Finally we have an ',
        },
        {
          text: 'Env',
          code: true,
        },
        {
          text: ' module with an ',
        },
        {
          text: 'empty',
          code: true,
        },
        {
          text: ' environment; and we export these all under the same name:',
        },
      ],
    },
    {
      type: 'code',
      language: 'typescript',
      children: [
        {
          text: 'module Env {\n  export const empty = Env({});\n}\n\nexport default Env;',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'so we can refer to them uniformly as ',
        },
        {
          text: 'Env',
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
          text: "import Env from './env';\n\nconst env1: Env = Env.empty;\nconst env2: Env = Env({ foo: Type.string });",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "(This relies on TypeScript's ",
        },
        {
          type: 'a',
          href: 'https://www.typescriptlang.org/docs/handbook/declaration-merging.html',
          children: [
            {
              text: 'declaration merging',
            },
          ],
        },
        {
          text: "—honestly I don't understand it very well, but it does what I want here.)",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Representing function types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To represent function types we add an arm to the ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' union from ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1#representing-types',
          children: [
            {
              text: 'part 1',
            },
          ],
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/type/types.ts#L30',
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
          text: "type Type = ... | Function;\n \ntype Function = {\n  type: 'Function';\n  args: Type[];\n  ret: Type;\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'For example, a function type',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(x: number, y: number) => number',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'is represented as',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "{\n  type: 'Function',\n  args: [ Type.number, Type.number ],\n  ret: Type.number\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "(We don't store the argument names; they aren't needed during type checking.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We also add a constructor function (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/type/constructors.ts#L16',
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
          text: "function functionType(args: Types.Type[], ret: Types.Type): Types.Function {\n  return { type: 'Function', args, ret };\n}",
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/type/validators.ts#L23',
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
          text: "export function isFunction(type: Types.Type): type is Types.Function {\n  return type.type === 'Function';\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and cases for function types in ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/type/toString.ts#L18',
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/type/ofTSType.ts#L27',
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
          text: 'Synthesizing types from expressions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now we can add cases to synthesize types (see ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1#synthesizing-types-from-expressions',
          children: [
            {
              text: 'part 1',
            },
          ],
        },
        {
          text: ') from variable, function, and call expressions. First we need to update ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' to take the current environment as an argument, and pass it down to all its helper functions and recursive calls; then add cases to dispatch to new helper functions (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/typecheck/synth.ts#L118',
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
          text: "function synth(env: Env, ast: AST.Expression): Type {\n  ...\n  case 'Identifier':              return synthIdentifier(env, ast);\n  case 'ArrowFunctionExpression': return synthFunction(env, ast);\n  case 'CallExpression':          return synthCall(env, ast);\n  ...\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Variable expressions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To synthesize a type from a variable expression (',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L513',
          children: [
            {
              text: 'Identifier',
              code: true,
            },
          ],
        },
        {
          text: '), we look it up in the environment:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function synthIdentifier(env: Env, ast: AST.Identifier): Type {\n  const type = env.get(ast.name);\n  if (!type) err(`unbound identifier '${ast.name}'`, ast);\n  return type;\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "or fail if the variable isn't bound.",
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Function expressions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To synthesize a type from a function expression (',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L761',
          children: [
            {
              text: 'ArrowFunctionExpression',
              code: true,
            },
          ],
        },
        {
          text: ') like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(x: number, y: number) => ({ x: x, y: y })',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'we:',
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
                  text: 'add bindings to the environment for each function argument and its type;',
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
                  text: 'synthesize the type of the function body using the new environment; and',
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
                  text: 'return a function type from the argument types to the return type.',
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
          text: "function synthFunction(env: Env, ast: AST.ArrowFunctionExpression): Type {\n  if (!AST.isExpression(ast.body)) bug(`unimplemented ${ast.body.type}`)\n  const bindings = ast.params.map(param => {\n    if (!AST.isIdentifier(param)) bug(`unimplemented ${param.type}`);\n    if (!param.typeAnnotation) err(`type required for '${param.name}'`, param);\n    if (!AST.isTSTypeAnnotation(param.typeAnnotation)) bug(`unimplemented ${param.type}`);\n    return {\n      name: param.name,\n      type: Type.ofTSType(param.typeAnnotation.typeAnnotation),\n    };\n  });\n  const args = bindings.map(({ type }) => type);\n  const bodyEnv =\n    bindings.reduce(\n      (env, { name, type }) => env.set(name, type),\n      env\n    );\n  const ret = synth(bodyEnv, ast.body);\n  return Type.functionType(args, ret);\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'We require that function arguments have type annotations so we can bind them in the environment, and convert the type annotations to our ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' representation with ',
        },
        {
          text: 'ofTSType',
          code: true,
        },
        {
          text: ". As usual we exclude some syntax that we don't handle.",
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Call expressions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To synthesize a type from a call expression (',
        },
        {
          type: 'a',
          href: 'https://github.com/babel/babel/blob/v7.15.3/packages/babel-types/src/ast-types/generated/index.ts#L412',
          children: [
            {
              text: 'CallExpression',
              code: true,
            },
          ],
        },
        {
          text: ') like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'f(7, 9)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      language: 'typescript',
      children: [
        {
          text: ' we:',
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
                  text: 'synthesize the type of the left-hand side (the ',
                },
                {
                  text: 'callee',
                  italic: true,
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
                  text: "if it's not a function type, fail;",
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
                  text: 'check (see ',
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
                  text: ') each argument expression against the corresponding argument type; and',
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
                  text: "return the callee's return type.",
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
          text: 'function synthCall(env: Env, ast: AST.CallExpression): Type {\n  if (!AST.isExpression(ast.callee)) bug(`unimplemented ${ast.callee.type}`);\n  const callee = synth(env, ast.callee);\n  if (!Type.isFunction(callee)) err(`call expects function`, ast.callee);\n  if (callee.args.length !== ast.arguments.length)\n    err(`expected ${callee.args.length} args, got ${ast.arguments.length} args`, ast);\n  callee.args.forEach((type, i) => {\n    const arg = ast.arguments[i];\n    if (!AST.isExpression(arg)) bug(`unimplemented ${arg.type}`)\n    check(env, arg, type);\n  });\n  return callee.ret;\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "It would be safe to allow a call to have fewer arguments than expected by the callee's type when the missing arguments have types that are subtypes of ",
        },
        {
          text: 'undefined',
          code: true,
        },
        {
          text: '; I left this out for simplicity. To get this behavior in actual TypeScript you need to explicitly mark the argument as optional (with a trailing ',
        },
        {
          text: '?',
          code: true,
        },
        {
          text: "). It would also be safe to allow calls with extra arguments, but it isn't useful, and might be a bug, so better to flag an error.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Subtyping function types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'When is a function type ',
        },
        {
          text: 'A1 => A2',
          code: true,
        },
        {
          text: ' a subtype of ',
        },
        {
          text: 'B1 => B2',
          code: true,
        },
        {
          text: '?',
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
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1',
          children: [
            {
              text: 'part 1',
            },
          ],
        },
        {
          text: ' that we can think of subtyping as an adversarial game: I pass a function of type ',
        },
        {
          text: 'A1 => A2',
          code: true,
        },
        {
          text: ' to an opponent who may perform any operations supported by type ',
        },
        {
          text: 'B1 => B2',
          code: true,
        },
        {
          text: " on it; if my opponent can't perform any unsupported operations on the value, then ",
        },
        {
          text: 'A1 => A2',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'B1 => B2',
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
          text: 'My opponent may pass the function an argument of type ',
        },
        {
          text: 'B1',
          code: true,
        },
        {
          text: ', and the function (of type ',
        },
        {
          text: 'A1 => A2',
          code: true,
        },
        {
          text: ') may perform any operations on the argument that are supported by ',
        },
        {
          text: 'A1',
          code: true,
        },
        {
          text: '. So ',
        },
        {
          text: 'B1',
          code: true,
        },
        {
          text: ' must be a subtype of ',
        },
        {
          text: 'A1',
          code: true,
        },
        {
          text: ',  since it must support any operation supported by ',
        },
        {
          text: 'A1',
          code: true,
        },
        {
          text: '. After the function returns a value (of type ',
        },
        {
          text: 'A2',
          code: true,
        },
        {
          text: '), my opponent may perform any operations supported by ',
        },
        {
          text: 'B2',
          code: true,
        },
        {
          text: '. So ',
        },
        {
          text: 'A2',
          code: true,
        },
        {
          text: ' must be a subtype of ',
        },
        {
          text: 'B2',
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
          text: 'We say that function types are ',
        },
        {
          text: 'covariant',
          italic: true,
        },
        {
          text: ' in their return type, because the subtyping goes the same way: if ',
        },
        {
          text: 'A1 => A2',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'B1 => B2',
          code: true,
        },
        {
          text: ' then ',
        },
        {
          text: 'A2',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'B2',
          code: true,
        },
        {
          text: '. And we say that function types are ',
        },
        {
          text: 'contravariant',
          italic: true,
        },
        {
          text: ' in their argument types, because the subtyping goes the opposite way: if ',
        },
        {
          text: 'A1 => A2',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'B1 => B2',
          code: true,
        },
        {
          text: ' then ',
        },
        {
          text: 'B1',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'A1',
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
          text: 'So we add a case for function types to ',
        },
        {
          text: 'isSubtype',
          code: true,
        },
        {
          text: ' as follows (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/type/isSubtype.ts',
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
          text: 'function isSubtype(a: Type, b: Type): boolean {\n  ...\n\n  if (Type.isFunction(a) && Type.isFunction(b)) {\n    return a.args.length === b.args.length &&\n      a.args.every((a, i) => isSubtype(b.args[i], a)) &&\n      isSubtype(a.ret, b.ret);\n  }\n  ...\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'It would be safe for a function type ',
        },
        {
          text: '(a: A) => C',
          code: true,
        },
        {
          text: ' to be a subtype of ',
        },
        {
          text: '(a: A, b: B) => C',
          code: true,
        },
        {
          text: ', because the extra argument can be ignored. And it would be safe for a function type ',
        },
        {
          text: '(a: A, b: B | undefined) => C',
          code: true,
        },
        {
          text: ' to be a subtype of ',
        },
        {
          text: '(a: A) => C',
          code: true,
        },
        {
          text: ', because the missing argument can be treated as ',
        },
        {
          text: 'undefined',
          code: true,
        },
        {
          text: '. I left these cases out for simplicity; actual TypeScript supports them (but again requires an explicit ',
        },
        {
          text: '?',
          code: true,
        },
        {
          text: ' marker in the second case).',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Checking function expressions against function types',
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
          text: ' that to check an expression against a type, we break down the expression and type and check their corresponding parts. To check a function expression against a function type we:',
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
                  text: 'match up the function expression arguments against the function type arguments;',
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
                  text: 'add each name-to-type binding to the environment; and',
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
                  text: 'check the function body against the return type using the new environment.',
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part2/src/typecheck/check.ts',
          children: [
            {
              text: 'check.ts',
            },
          ],
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
          text: 'function check(env: Env, ast: AST.Expression, type: Type) {\n  ...\n  if (AST.isArrowFunctionExpression(ast) && Type.isFunction(type))\n    return checkFunction(env, ast, type);\n  ...\n}\n\nfunction checkFunction(env: Env, ast: AST.ArrowFunctionExpression, type: Type.Function) {\n  if (!AST.isExpression(ast.body)) bug(`unimplemented ${ast.body.type}`)\n  if (type.args.length != ast.params.length)\n    err(`expected ${type.args.length} args, got ${ast.params.length} args`, ast);\n  const bindings = ast.params.map((param, i) => {\n    if (!AST.isIdentifier(param)) bug(`unimplemented ${param.type}`);\n    return { name: param.name, type: type.args[i] };\n  });\n  const bodyEnv =\n    bindings.reduce(\n      (env, { name, type }) => env.set(name, type),\n      env\n    );\n  check(bodyEnv, ast.body, type.ret);\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "Again we could handle some cases here where the argument lists have different lengths; I've left them out for simplicity.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Note that we don't require type annotations on the function arguments. I mentioned in ",
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
          text: ' that a benefit of bidirectional type checking over just synthesis with subtyping is that it reduces necessary type annotations—when checking a function expression against a function type, we already know the argument types, so we can omit them in the expression. This is especially convenient with higher-order functions, like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '[1, 2, 3].map(x => x + 1)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'However, if you do include argument type annotations we just ignore them; it would be better to check (as actual TypeScript does) that each argument type annotation is a subtype of the expected argument type.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Example?',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'I tried to write up an example like I did for ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1#example',
          children: [
            {
              text: 'part 1',
            },
          ],
        },
        {
          text: ', but with environments in the mix it got too complicated and tedious—instead I added an interactive call tree to the demo widget so you can work through examples yourself, see below.',
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
          text: 'You can try out the type checker below. In the top box, click on an example button or type an expression (remember that the supported expressions are primitive literals, object expressions, member expressions, variables, functions, function calls, and ',
        },
        {
          text: 'as',
          code: true,
        },
        {
          text: " ascriptions). In the bottom box you'll see a trace of the type checker execution, ending in a synthesized type (or an error). The trace is a tree of function calls; click on a function call to expand the tree under that call, or mouse over a call to highlight the matching return value.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Notice how the environment changes when we ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' a function expression or ',
        },
        {
          text: 'check',
          code: true,
        },
        {
          text: ' a function expression against a function type. Also notice how type checking switches from ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' to ',
        },
        {
          text: 'check',
          code: true,
        },
        {
          text: ' when we ',
        },
        {
          text: 'synth',
          code: true,
        },
        {
          text: ' a call expression.',
        },
      ],
    },
    {
      type: 'liveCode',
      children: [
        {
          text: '<iframe\n  src="https://jaked.org/reconstructing-typescript/part2/"\n  width={700}\n  height={500}\n  style={{ borderStyle: \'none\' }}\n/>',
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
          text: 'For the full code of part 2 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/tree/part2',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/tree/part2',
            },
          ],
        },
        {
          text: '. To view the changes between part 1 and part 2 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/compare/part1...part2',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/compare/part1...part2',
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
          text: 'singleton',
          italic: true,
        },
        {
          text: ' types and some operators so we can write more interesting programs.',
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
    title: 'Reconstructing TypeScript, part 2: functions and function types',
    layout: '/layout',
    publish: true,
  },
}