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
          text: ' > Reconstructing TypeScript, part 4',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Reconstructing TypeScript, part 4: union types',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-10-14',
          italic: true,
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "This post is part of a series about implementing type checking for a TypeScript-like language. The language fragment we've covered so far (in parts ",
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
          text: ', and ',
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
          text: ') supports:',
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
                  text: 'primitives, object expressions and member lookups, functions and function applications, and some arithmetic and logical operators; and',
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
                  text: 'primitive, object, function, and singleton types.',
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
          text: "In this part we'll add ",
        },
        {
          text: 'union',
          italic: true,
        },
        {
          text: ' types like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "string | boolean\n'red' | 'green' | 'blue'\n{ x: number, y: number } | undefined\n\n{ type: 'cartesian', x: number, y: number } |\n  { type: 'polar', angle: number, magnitude: number }",
          code: true,
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "to describe collections of values where we know each value satisfies (at least) one arm of the union, but we don't know which one.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: "What's a union type?",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'I wrote in ',
        },
        {
          type: 'a',
          href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0#whats-a-type-checker',
          children: [
            {
              text: 'part 0',
            },
          ],
        },
        {
          text: ' that a type',
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
          text: 'Now I need to complicate that explanation a little to make sense of union types.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'First, a reminder that these are all ways of saying the same thing:',
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
                  text: 'a value ',
                },
                {
                  text: 'supports the operations described by',
                  italic: true,
                },
                {
                  text: ' a type',
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
                  text: 'a value ',
                },
                {
                  text: 'satisfies',
                  italic: true,
                },
                {
                  text: ' a type',
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
                  text: 'a type ',
                },
                {
                  text: 'contains',
                  italic: true,
                },
                {
                  text: ' a value',
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
          text: "In what follows I'll use all these ways to describe the same situation, don't be confused!",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Values satisfying a type may have additional attributes that aren't described by the type (for example, extra object properties); different values may have different additional attributes; and we may view the same value as different types at different points in a program. For example, in",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "const v1 = { x: 7, y: 9 };\nconst v2 = { type: 'cartesian', x: 7, y: 9 };\n\nconst magnitude = (v: { x: number, y: number }) =>\n  Math.sqrt(x * x + y * y);\n\nmagnitude(v1);\nmagnitude(v2);",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'v1',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'v2',
          code: true,
        },
        {
          text: ' have different types, but in the body of ',
        },
        {
          text: 'magnitude',
          code: true,
        },
        {
          text: " they're viewed as the same type. So a type isn't a complete description of a collection of values; it describes ",
        },
        {
          text: "what's known",
          italic: true,
        },
        {
          text: ' about the values ',
        },
        {
          text: 'at a certain point in a program',
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
          text: 'A ',
        },
        {
          text: 'union',
          italic: true,
        },
        {
          text: " type describes a situation where what's known about a collection of values is that each value satisfies (at least) one of several types (called ",
        },
        {
          text: 'arms',
          italic: true,
        },
        {
          text: " of the union), but we don't know which one. What can we do with this knowledge—what operations are supported on union types? Since we don't know which arm a given value satisfies, the operations supported on union types are those that are supported on ",
        },
        {
          text: 'every',
          italic: true,
        },
        {
          text: ' arm. For example, in the type',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "{ type: 'cartesian', x: number, y: number } |\n  { type: 'polar', angle: number, magnitude: number }",
          code: true,
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'we can look up the ',
        },
        {
          text: 'type',
          code: true,
        },
        {
          text: " property, because it's supported on every arm; but we can't look up the other properties. We can also use ",
        },
        {
          text: 'in',
          code: true,
        },
        {
          text: ' to test for the presence of properties (this is supported on all objects), test for truthiness (this is supported on all values), and so on.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Performing an operation on a value might yield information about which arm of the union the value satisfies; from that information we can deduce that additional operations are supported. For example, if the ',
        },
        {
          text: 'type',
          code: true,
        },
        {
          text: ' property is ',
        },
        {
          text: "'cartesian'",
          code: true,
        },
        {
          text: " we can deduce that the value satisfies the first arm of the union, so it's safe to look up the ",
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' property—we ',
        },
        {
          text: 'narrow',
          italic: true,
        },
        {
          text: " the union type by eliminating some arms. (We'll return to narrowing in part 6.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'A union with one arm contains the same values as the arm—every value of this type must satisfy the single arm.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'A union with no arms contains no values—a value of union type must satisfy one of the arms, but there are no arms to satisfy, so there can be no values. This type is called ',
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: "; it's useful to describe functions that always throw an exception (like ",
        },
        {
          text: 'bug',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'err',
          code: true,
        },
        {
          text: ' in our implementation), or empty collections (an empty array has type ',
        },
        {
          text: 'never[]',
          code: true,
        },
        {
          text: ').',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Equivalent union types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Union types give us lots of ways to describe the same collection of values:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "The order of the arms of a union doesn't matter; so for example",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "'red' | 'blue' | 'green'\n'blue' | 'red' | 'green'\n'green' | 'red' | 'blue'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'all contain the same values.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'If a union arm is a nested union, the arms of the inner union can be lifted up to the outer union (if a value satisfies the nested union, then it satisfies one of its arms); so for example',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "'red' | ('green' | 'blue')\n('red' | 'green') | 'blue'\n'red' | 'green' | 'blue'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'all contain the same values.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'If one arm of a union is a subtype of another, it can be removed (all values that satisfy it also satisfy the other arm); so for example',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "{ type: 'cartesian', x: number, y: number } | { x: number, y: number }\n{ x: number, y: number } | never\n{ x: number, y: number }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'all contain the same values. (We need to be careful about equivalent arms: in a union like ',
        },
        {
          text: 'number | number',
          code: true,
        },
        {
          text: " we don't want to remove both arms because each is a subtype of the other—instead we keep just one equivalent arm.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Finally, an object type with properties of union type supports the same operations as a union of object types; so for example',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: 1 | 2, bar: 3 | 4 }\n{ foo: 1 | 2, bar: 3 } | { foo: 1 | 2, bar: 4 }\n{ foo: 1, bar: 3 | 4 } | { foo: 2, bar: 3 | 4 }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'all contain the same values.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Representing union types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To represent union types, we add a ',
        },
        {
          text: 'Union',
          code: true,
        },
        {
          text: ' arm to the ',
        },
        {
          text: 'Type',
          code: true,
        },
        {
          text: ' union containing a list of arms, and a ',
        },
        {
          text: 'Never',
          code: true,
        },
        {
          text: ' arm to represent ',
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/type/types.ts#L49',
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
          text: "type Type = ... | Never | Union;\n\ntype Never = { type: 'Never'; }\n\ntype Union = { type: 'Union'; types: Type[]; }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'We add a constructor function for ',
        },
        {
          text: 'Never',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/type/constructors.ts#L3',
          children: [
            {
              text: 'constructors.ts',
            },
          ],
        },
        {
          text: ', and below for the ',
        },
        {
          text: 'Union',
          code: true,
        },
        {
          text: ' constructor):',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "const never: Never = { type: 'Never' };",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and validator functions (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/type/validators.ts#L35',
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
          text: "function isNever(type: Type): type is Never {\n  return type.type === 'Never';\n}\n\nfunction isUnion(type: Type): type is Union {\n  return type.type === 'Union';\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and cases for ',
        },
        {
          text: 'Union',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'Never',
          code: true,
        },
        {
          text: ' in ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/type/toString.ts#L31',
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/type/ofTSType.ts#L53',
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
          text: 'Normalizing union types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "We saw above that there are many ways union types can be equivalent. To simplify the type checker, and to make its output more readable, we normalize union types in the constructor: flatten nested unions and remove redundant arms. Here's the code (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/type/union.ts',
          children: [
            {
              text: 'union.ts',
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
          text: "function collapseSubtypes(ts: Type[]): Type[] {\n  return ts.filter((t1, i1) =>       // an arm is kept if\n    ts.every((t2, i2) =>             // for every arm\n      i1 === i2 ||                   // (except itself)\n      !isSubtype(t1, t2) ||          // it's not a subtype of the other arm\n      (isSubtype(t2, t1) && i1 < i2) // or it's equivalent to the other arm\n                                     // and this is the first equivalent arm\n    )\n  );\n}\n\nfunction flatten(ts: Type[]): Type[] {\n  return ([] as Type[]).concat(\n    ...ts.map(t => isUnion(t) ? t.types : t)\n  );\n}\n\nfunction union(...types: Type[]): Type {\n  types = flatten(types);\n  types = collapseSubtypes(types);\n\n  if (types.length === 0) return never;\n  if (types.length === 1) return types[0];\n  return { type: 'Union', types }\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "We don't normalize the ordering of arms, or distribute object types over unions; so it's still possible to write equivalent types in different ways. There are tradeoffs here among type checker performance, compact and readable types, and keeping types close to how they're written in the code. (That's not to say that I've explored these tradeoffs in any depth; I just did something straightforward that seems pretty close to what actual TypeScript does.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Actual TypeScript normalizes types in some situations but not others; in particular, if you write down a type explictly, redundant object types aren't removed. I don't know why not!",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Synthesizing with union types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'In our type checker so far, when synthesizing the type of an expression that operates on a subexpression—for example, a member expression like ',
        },
        {
          text: 'foo.bar',
          code: true,
        },
        {
          text: '—we synthesize the type of the subexpression, then check that it supports the operation and compute the result type, like:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function synthMember(env: Env, ast: AST.MemberExpression): Type {\n  const prop = ast.property;\n  ...\n  const object = synth(env, ast.object);\n  if (!Type.isObject(object)) err('. expects object', ast.object);\n  const type = Type.propType(object, prop.name);\n  if (!type) err(`no such property ${prop.name}`, prop);\n  return type;\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "Now we need to handle the case where the subexpression has union type. We saw above that an operation is supported on a union type when it's supported on every arm of the union. We don't know which arm a value satisfies, and each arm might return a different result type for the operation. So the result type of the operation on the union must be the union of the result types of the operation on each arm. For example, for an expression ",
        },
        {
          text: 'foo',
          code: true,
        },
        {
          text: ' of type',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ bar: boolean } | { bar: string }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'the result type of ',
        },
        {
          text: 'foo.bar',
          code: true,
        },
        {
          text: ' is',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'boolean | string',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Every operation follows this same pattern, so we implement it using a helper function (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/type/map.ts',
          children: [
            {
              text: 'map.ts',
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
          text: 'function map(t: Type, fn: (t: Type) => Type) {\n  if (isUnion(t)) return union(...t.types.map(fn));\n  else            return fn(t);\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'The idea is that computing the result type of an operation from its operand type is a ',
        },
        {
          text: 'Type => Type',
          code: true,
        },
        {
          text: ' function. We apply this function to a union type by applying it to each arm then taking the union of the results; for other types we just apply it. (Here ',
        },
        {
          text: 'map',
          code: true,
        },
        {
          text: ' depends on normalization—',
        },
        {
          text: 't.types',
          code: true,
        },
        {
          text: ' contains no unions.)',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now we synthesize a type from the subexpression as before, then map over it to compute the result type of the operation, like:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "function synthMember(env: Env, ast: AST.MemberExpression): Type {\n  const prop = ast.property;\n  ...\n  const object = synth(env, ast.object);\n  return Type.map(object, object => {\n    if (!Type.isObject(object)) err('. expects object', ast.object);\n    const type = Type.propType(object, prop.name);\n    if (!type) err(`no such property ${prop.name}`, prop);\n    return type;\n  });\n}",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'We change the rest of the operations the same way (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/typecheck/synth.ts#L106',
          children: [
            {
              text: 'synthCall',
              code: true,
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/typecheck/synth.ts#L106',
          children: [
            {
              text: 'synthBinary',
              code: true,
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/typecheck/synth.ts#L106',
          children: [
            {
              text: 'synthLogical',
              code: true,
            },
          ],
        },
        {
          text: ', ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/typecheck/synth.ts#L203',
          children: [
            {
              text: 'synthUnary',
              code: true,
            },
          ],
        },
        {
          text: "). But when a subexpression is used without operating on it—as a property value of an object expression, or passed as a function argument—then we don't need to ",
        },
        {
          text: 'map',
          code: true,
        },
        {
          text: ' over it, we just use the type directly. For example, in:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const value: string | boolean = ...\nconst obj = { foo: value }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'we use the type of ',
        },
        {
          text: 'value',
          code: true,
        },
        {
          text: ' directly as the property type, so the type of ',
        },
        {
          text: 'obj',
          code: true,
        },
        {
          text: ' is',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: string | boolean }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'We can now improve the result type of ',
        },
        {
          text: '&&',
          code: true,
        },
        {
          text: ' (and ',
        },
        {
          text: '||',
          code: true,
        },
        {
          text: "), since we can express the situation where we don't know whether the left or right side is returned (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part4/src/typecheck/synth.ts#L167',
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
          text: "case '&&':\n  if (Type.isFalsy(left))\n    return left;\n  else if (Type.isTruthy(left))\n    return right;\n  else\n    return Type.union(left, right);",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "This is still not completely precise: when the left side is returned, it must be falsy, so we can narrow its type to falsy values. We'll fix this in part 6.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Subtyping union types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'A union type is a subtype of another type if each of its arms is a subtype of the other type—so ',
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: ", having no arms, is a subtype of every type. A type is a subtype of a union type if it's a subtype of at least one of the arms. (To see why these rules are valid, the view from ",
        },
        {
          type: 'a',
          href: '/blog/2021-09-15-Reconstructing-TypeScript-part-1#subtyping',
          children: [
            {
              text: 'part 1',
            },
          ],
        },
        {
          text: " of subtyping as an adversarial game might be useful.) Here's the code:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function isSubtype(a: Type, b: Type): boolean {\n  if (Type.isNever(a)) return true;\n\n  if (Type.isUnion(a))\n    return a.types.every(a => isSubtype(a, b));\n\n  if (Type.isUnion(b))\n    return b.types.some(b => isSubtype(a, b));\n  ...',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Unfortunately, these straightforward rules are not ',
        },
        {
          text: 'complete',
          italic: true,
        },
        {
          text: '—there are pairs of types that contain the same values, but are not subtypes of one another according to this function. For example:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type a = { foo: 1 | 2 }\ntype b = { foo: 1 } | { foo: 2 }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'a',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'b',
          code: true,
        },
        {
          text: ' contain the same values, and ',
        },
        {
          text: 'b',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'a',
          code: true,
        },
        {
          text: ', but ',
        },
        {
          text: 'a',
          code: true,
        },
        {
          text: ' is not a subtype of ',
        },
        {
          text: 'b',
          code: true,
        },
        {
          text: ' according to our ',
        },
        {
          text: 'isSubtype',
          code: true,
        },
        {
          text: ' function. The problem is that we have to commit to a type of ',
        },
        {
          text: 'foo',
          code: true,
        },
        {
          text: ' too early by choosing one of the arms of ',
        },
        {
          text: 'b',
          code: true,
        },
        {
          text: ". One approach might be to distribute object expressions over unions before (or maybe simultaneously with) checking subtyping; but let's move on for now. (Actual TypeScript does better here—I don't know what algorithm it uses.)",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Checking against union types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Recall that we have two motivations for checking expressions against types:',
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
                  text: 'to produce more localized error messages (see ',
                },
                {
                  type: 'a',
                  href: '/blog/2021-09-07-Reconstructing-TypeScript-part-0#checking-an-expression-against-a-type',
                  children: [
                    {
                      text: 'part 0',
                    },
                  ],
                },
                {
                  text: ')',
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
                  text: 'to avoid needing type annotations on function arguments (see ',
                },
                {
                  type: 'a',
                  href: '/blog/2021-09-27-Reconstructing-TypeScript-part-2#checking-function-expressions-against-function-types',
                  children: [
                    {
                      text: 'part 2',
                    },
                  ],
                },
                {
                  text: ')',
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
          text: 'For union types, we could implement a checking rule like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function checkUnion(env: Env, ast: AST.Expression, type: Type.Union) {\n  let error: unknown = undefined;\n  for (const t of type.types) {\n    try {\n      check(env, ast, t);\n      return;\n    }\n    catch (e) {\n      if (!error) error = e;\n    }\n  }\n  throw error;\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'That is, try to check the expression against each arm of the union; if any arm succeeds, then the expression satisfies the union type. If no arm succeeds, throw the exception we got for the first arm.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "This might let us avoid type annotations on function arguments when the expression satisfies the union type. But when the expression doesn't satisfy the union type, the error message is much worse. For example, in",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "type vector =\n  { type: 'cartesian', x: number, y: number } |\n    { type: 'polar', angle: number, magnitude: number }\n\nconst v: vector = { type: 'polar', angle: ..., mangitude: ... }",
          code: true,
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "(where we're trying to make a ",
        },
        {
          text: "'polar'",
          code: true,
        },
        {
          text: ' vector but misspell the ',
        },
        {
          text: 'magnitude',
          code: true,
        },
        {
          text: " property) we'd get an error like ",
        },
        {
          text: "'polar' is not a subtype of 'cartesian'",
          code: true,
        },
        {
          text: ", because that's the exception we get when trying to check the expression against the first arm.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "We could come up with a fancier scheme here—maybe score the arms by how closely they match the expression?—but for now we'll just fall back as usual to the default: synthesize a type from the expression, then check that it's a subtype of the union type. That way we get a more useful error like:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "{ type: 'polar', angle: number, mangitude: number } is not a subtype of\n  { type: 'cartesian', x: number, y: number } |\n    { type: 'polar', angle: number, magnitude: number }",
          code: true,
        },
      ],
      language: 'typescript',
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
      type: 'p',
      children: [
        {
          text: 'Anonymous functions passed to ',
        },
        {
          text: 'Type.map',
          code: true,
        },
        {
          text: " are labelled to match the enclosing function; and since they usually close over the subexpression AST, they're annotated with the AST for context. So the anonymous function in ",
        },
        {
          text: 'synthBinary',
          code: true,
        },
        {
          text: ' for an addition is labelled ',
        },
        {
          text: '...synthBinary[_ + _]',
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
          text: 'The only way to create union types in the current language fragment is with type ascription.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Notice the quadratic blowup in the ',
        },
        {
          text: '+',
          code: true,
        },
        {
          text: " example—maybe this is why actual TypeScript doesn't synthesize singleton types for arithmetic operators?",
        },
      ],
    },
    {
      type: 'liveCode',
      children: [
        {
          text: '<iframe\n  src="https://jaked.org/reconstructing-typescript/part4/"\n  width={700}\n  height={500}\n  style={{ borderStyle: \'none\' }}\n/>',
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
          text: 'For the full code of part 4 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/tree/part4',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/tree/part4',
            },
          ],
        },
        {
          text: '. To view the changes between part 3 and part 4 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/compare/part3...part4',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/compare/part3...part4',
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
          text: 'intersection',
          italic: true,
        },
        {
          text: ' types, on the way to implementing narrowing.',
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
  ],
  meta: {
    publish: true,
    layout: '/layout',
    title: 'How to implement a TypeScript-style type checker (Reconstructing TypeScript), part 4: union types',
  },
}