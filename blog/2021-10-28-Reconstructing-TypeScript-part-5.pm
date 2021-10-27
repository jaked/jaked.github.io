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
          text: ' > Reconstructing TypeScript, part 5',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Reconstructing TypeScript, part 5: intersection types',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-10-28',
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
          text: ' for the implementation so far.',
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
          text: 'intersection',
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
          text: '{ x: number } & { y: number } & { z: number }\n\n((n: number) => string) & ((s: string) => number)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'to describe collections of values that satisfy all the parts (separated by ',
        },
        {
          text: '&',
          code: true,
        },
        {
          text: ") of the intersection. We haven't talked about intersection types yet, but they'll be important when we cover narrowing in the next part. They can also be useful in ordinary programming (I'll give some examples below).",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Intersection types are unusual, although some other languages support them in a limited form—for example, implementing multiple interfaces in Java or Scala is a kind of intersection, as is function overloading.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: "What's an intersection type?",
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
          href: '/blog/2021-10-14-Reconstructing-TypeScript-part-4#whats-a-union-type',
          children: [
            {
              text: 'part 4',
            },
          ],
        },
        {
          text: ' I explained a type as a description of what\'s known about a collection of values (at a certain point in a program). Some types describe concrete attributes (like "supports the ',
        },
        {
          text: 'bar',
          code: true,
        },
        {
          text: ' property"); others describe logical operations on pieces of knowledge:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'A union type ',
        },
        {
          text: 'A | B',
          code: true,
        },
        {
          text: ' is a logical OR of its arms: for any value satisfying the type, we know that either the value satisfies ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ', or the value satisfies ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ', or the value satisfies both ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: "; but we don't know which one.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'An intersection type ',
        },
        {
          text: 'A & B',
          code: true,
        },
        {
          text: ' is a logical AND of its parts: for any value satisfying ',
        },
        {
          text: 'A & B',
          code: true,
        },
        {
          text: ' we know the value satisfies both ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: '. For example, the type',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: number } & { y: number } & { z: number }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'has properties ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ', ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ', and ',
        },
        {
          text: 'z',
          code: true,
        },
        {
          text: ', all of type ',
        },
        {
          text: 'number',
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
          text: "One use for intersections is to add fields to an existing type. For example: a hassle that comes up with ORM systems is that IDs are issued by the database; when you create an object it doesn't have an ID, but when you look it up it does; so you can't use the same type for both purposes. Usually you get around this by making the ID an optional property, but that's not quite right. In TypeScript you can define the core object type without the ID property:",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type Obj = { ... }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'then augment it with an ',
        },
        {
          text: 'id',
          code: true,
        },
        {
          text: ' property using an intersection',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type ObjWithID = Obj & { id: number }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'to get a type that supports all the same operations as ',
        },
        {
          text: 'Obj',
          code: true,
        },
        {
          text: ' and also the ',
        },
        {
          text: 'id',
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
          text: 'Another use is to give types to overloaded functions. For example, the browser ',
        },
        {
          text: 'getElementsByTagName',
          code: true,
        },
        {
          text: ' function returns different types based on its argument, so we can give it an intersection type:',
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
      type: 'p',
      children: [
        {
          text: '(In actual TypeScript you can declare overloaded functions with ',
        },
        {
          type: 'a',
          href: 'https://www.typescriptlang.org/docs/handbook/2/functions.html#function-overloads',
          children: [
            {
              text: 'overload signatures',
            },
          ],
        },
        {
          text: ", and as we'll see its type checker doesn't handle function intersections very well.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "An intersection with only one part contains the same values as the single part. (There's no way to write this type in TypeScript's concrete syntax, but it comes up in the code.)",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'An intersection with no parts contains all values! This type is called ',
        },
        {
          text: 'unknown',
          code: true,
        },
        {
          text: '. It supports only operations supported on every value, like calling ',
        },
        {
          text: 'typeof',
          code: true,
        },
        {
          text: ' or testing for truthiness.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '(In the same way that logical AND is ',
        },
        {
          text: 'dual',
          italic: true,
        },
        {
          text: " to logical OR, intersection is dual to union. So a lot of the code we'll need for intersections looks like the code for unions, but flipped somehow.)",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Equivalent intersection types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Like union types, intersection types give us lots of ways to describe the same collection of values:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "The order of the parts of an intersection doesn't matter; so for example",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: number } & { y: number } & { z: number }\n{ y: number } & { x: number } & { z: number }\n{ z: number } & { x: number } & { y: number }',
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
          text: 'If a part of an intersection is a nested intersection, the parts of the inner intersection can be lifted up to the outer intersection; so for example',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: number } & ({ y: number } & { z: number })\n({ x: number } & { y: number }) & { z: number }\n{ x: number } & { y: number } & { z: number }',
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
          text: 'If one part of an intersection is a supertype of another, it can be removed; so for example',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "{ type: 'cartesian', x: number, y: number } & { x: number, y: number }\n{ type: 'cartesian', x: number, y: number } & unknown\n{ type: 'cartesian', x: number, y: number }",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "all contain the same values. (Here's an example of duality between union and intersection: For unions we remove the ",
        },
        {
          text: 'sub',
          italic: true,
        },
        {
          text: 'types—a value satisfying a union must satisfy one of the arms; if it satisfies an arm it also satisfies all subtypes of the arm; so subtypes are redundant. For intersections we remove the ',
        },
        {
          text: 'super',
          italic: true,
        },
        {
          text: 'types—a value satisfying an intersection must satisfy all the parts; if it satisfies any supertype of a part it also satisfies the part; so supertypes are redundant.)',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Intersections distribute over object types, so for example',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: { bar: number } } & { foo: { baz: string } }\n{ foo: { bar: number } & { baz: string } }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'contain the same values; and also',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: number } & { y: number } & { z: number }\n{ x: number, y: number, z: number }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'contain the same values.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Intersections also distribute over unions (just as multiplication distributes over addition) so',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(1 | 2) & (2 | 3)\n(1 & (2 | 3)) | (2 & (2 | 3))\n(1 & 2) | (1 & 3) | (2 & 2) | (2 & 3)',
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
          text: "Some types have empty intersection: for example, a value can't be both a ",
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' and a ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ', or satisfy both singleton types ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: '9',
          code: true,
        },
        {
          text: ". An empty intersection contains no values, so it's equivalent to ",
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: '. In the previous example, all but one of the intersections in the 3rd line are empty, so the type is equivalent to',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '2',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now that we have intersections, we can distribute functions over unions—for example',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(x: number | string) => boolean\n((x: number) => boolean) & ((x: string) => boolean',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'contain the same values.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Representing intersection types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'To represent intersection types, we add an ',
        },
        {
          text: 'Intersection',
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
          text: ' union containing a list of parts, and an ',
        },
        {
          text: 'Unknown',
          code: true,
        },
        {
          text: ' arm to represent ',
        },
        {
          text: 'unknown',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/types.ts#L60',
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
          text: "type Type = ... | Unknown | Intersection;\n\ntype Unknown = { type: 'Unknown'; }\n\ntype Intersection = { type: 'Intersection'; types: Type[]; }",
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
          text: 'Unknown',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/constructors.ts#L4',
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
          text: 'Intersection',
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
          text: "const unknown: Types.Unknown = { type: 'Unknown' };",
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/validators.ts#L43',
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
          text: "function isUnknown(type: Type): type is Unknown {\n  return type.type === 'Unknown';\n}\n\nfunction isIntersection(type: Type): type is Intersection {\n  return type.type === 'Intersection';\n}",
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
          text: 'Intersection',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'Unknown',
          code: true,
        },
        {
          text: ' in ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/toString.ts#L43',
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/ofTSType.ts#L58',
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
          text: 'Normalizing intersection types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'As we do for unions (see ',
        },
        {
          type: 'a',
          href: '/blog/2021-10-14-Reconstructing-TypeScript-part-4#normalizing-union-types',
          children: [
            {
              text: 'part 4',
            },
          ],
        },
        {
          text: '), we normalize intersection types in the constructor, to simplify the type checker and make its output more readable.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Normalizing intersections is more complicated than normalizing unions. We want to detect and eliminate empty intersections (this will be important for narrowing), but unions make it more difficult. For example, in',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(1 | 2) & (2 | 3)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "it's not obvious that we can eliminate most of the union cases. But if we distribute the intersection over the unions",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(1 & 2) | (1 & 3) | (2 & 2) | (2 & 3)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "then it's easy to check each intersection for emptiness",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'never | never | 2 | never',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and eliminate the empty intersections',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '2',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "So that's what we do: in addition to flattening nested intersections and removing redundant parts (as we do for unions), we also distribute intersections over unions and eliminate empty intersections. As with unions, we don't distribute intersections over object or function types (or objects / functions over intersections).",
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Distributing intersections over unions',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's a helper function for distributing over unions (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/union.ts#L28',
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
          text: 'function distributeUnion(ts: Type[]): Type[][] {\n  const accum: Type[][] = [];\n\n  function dist(ts: Type[], i: number): void {\n    if (i === ts.length) {\n      accum.push(ts);\n    } else {\n      const ti = ts[i];\n      if (isUnion(ti)) {\n        for (const t of ti.types) {\n          const ts2 = ts.slice(0, i).concat(t, ts.slice(i + 1));\n          dist(ts2, i + 1);\n        }\n      } else {\n        dist(ts, i + 1);\n      }\n    }\n  }\n\n  dist(ts, 0);\n  return accum;\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'This function takes a list of types (which may contain unions) and returns the Cartesian product (roughly speaking) over the unions. So if you call',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'distributeUnion([ 1 | 2, 3, 4 | 5 ])',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'you get back',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '[\n  [ 1, 3, 4 ],\n  [ 1, 3, 5 ],\n  [ 2, 3, 4 ],\n  [ 2, 3, 5 ]\n]',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Detecting empty intersections',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Here's a function to check if two types overlap—that is, their intersection is not empty (see ",
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/intersection.ts#L30',
          children: [
            {
              text: 'intersection.ts',
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
          text: 'function overlaps(x: Type, y: Type): boolean {\n  if (isNever(x) || isNever(y)) return false;\n  if (isUnknown(x) || isUnknown(y)) return true;\n\n  if (isUnion(x))\n    return x.types.some(x => overlaps(x, y));\n  if (isUnion(y))\n    return y.types.some(y => overlaps(x, y));\n\n  if (isIntersection(x))\n    return x.types.every(x => overlaps(x, y));\n  if (isIntersection(y))\n    return y.types.every(y => overlaps(x, y));\n\n  if (isSingleton(x) && isSingleton(y)) return x.value === y.value;\n  if (isSingleton(x)) return x.base.type === y.type;\n  if (isSingleton(y)) return y.base.type === x.type;\n\n  if (isObject(x) && isObject(y)) {\n    return x.properties.every(({ name, type: xType }) => {\n      const yType = propType(y, name);\n      if (!yType) return true;\n      else return overlaps(xType, yType);\n    });\n  }\n\n  return x.type === y.type;\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "It's interesting to compare ",
        },
        {
          text: 'overlaps',
          code: true,
        },
        {
          text: ' with ',
        },
        {
          text: 'isSubtype',
          code: true,
        },
        {
          text: ': ',
        },
        {
          code: true,
          text: 'isSubtype(a, b)',
        },
        {
          text: ' is true when all of ',
        },
        {
          text: 'a',
          code: true,
        },
        {
          text: ' is contained in ',
        },
        {
          text: 'b',
          code: true,
        },
        {
          text: '; ',
        },
        {
          text: 'overlaps(a, b)',
          code: true,
        },
        {
          text: ' is true when part of ',
        },
        {
          text: 'a',
          code: true,
        },
        {
          text: ' is contained in ',
        },
        {
          text: 'b',
          code: true,
        },
        {
          text: ' (or, equivalently, part of ',
        },
        {
          text: 'b',
          code: true,
        },
        {
          text: ' is contained in ',
        },
        {
          text: 'a',
          code: true,
        },
        {
          text: ').',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Empty intersections of object types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          code: true,
          text: 'overlaps',
        },
        {
          text: ' recurses inside object types, so it detects that',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: 1 } & { foo: 2 }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "is empty. Object properties may contain unions and intersections (since we don't distribute objects over unions and intersections) so ",
        },
        {
          text: 'overlaps',
          code: true,
        },
        {
          text: ' must handle those cases. So ',
        },
        {
          text: 'overlaps',
          code: true,
        },
        {
          text: ' detects that',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: 1 | 2 } & { foo: 3 | 4 }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "is empty, but we don't normalize",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: 1 | 2 } & { foo: 2 | 3 }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'to the equivalent',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: 2 }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Empty intersections of function types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "I'm not sure what to do about functions here. Clearly there are non-overlapping functions—for example",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '((x: number) => string) & ((x: number) => boolean))',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'is empty; there is no function that returns both ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: " for the same input. But when the argument types don't overlap it's OK to return different types, for example",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '((x: number) => string) & ((x: string) => boolean))',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'so maybe there is a way to compute this precisely by checking for argument type overlap. In the meantime we just say that all functions overlap.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Actual TypeScript doesn't seem to be precise here either: it detects empty intersections in objects",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type x = { foo: 7 }\ntype y = { foo: 9 }\ntype z = x & y // z has type never',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'but not in functions',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type f = (x: number) => string\ntype g = (x: number) => boolean\ntype h = f & g // h has type f & g',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Normalizing intersections',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now we can put the pieces together. To normalize an intersection:',
        },
      ],
    },
    {
      type: 'ol',
      children: [
        {
          type: 'li',
          children: [
            {
              type: 'p',
              children: [
                {
                  text: 'flatten nested intersections',
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
                  text: 'distribute the intersection over unions to get a union of intersections',
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
                  text: 'for each intersection, check for emptiness and remove redundant parts',
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/intersection.ts#L75',
          children: [
            {
              text: 'intersection.ts',
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
          text: "function collapseSupertypes(ts: Type[]): Type[] {\n  return ts.filter((t1, i1) =>       // a part is kept if\n    ts.every((t2, i2) =>             // for every part\n      i1 === i2 ||                   // (except itself)\n      !isSubtype(t2, t1) ||          // it's not a supertype of the other part\n      (isSubtype(t1, t2) && i1 < i2) // or it's equivalent to the other part\n                                     // and this is the first equivalent part\n    )\n  );\n}\n\nfunction flatten(ts: Type[]): Type[] {\n  return ([] as Type[]).concat(\n    ...ts.map(t => isIntersection(t) ? t.types : t)\n  );\n}\n\nfunction intersectionNoUnion(ts: Type[]): Type {\n  if (ts.some((t1, i1) => ts.some((t2, i2) =>\n    i1 < i2 && emptyIntersection(t1, t2)\n  )))\n    return never;\n  ts = collapseSupertypes(ts);\n\n  if (ts.length === 0) return unknown;\n  if (ts.length === 1) return ts[0];\n  return { type: 'Intersection', types: ts }\n}\n\nfunction intersection(...ts: Type[]): Type {\n  ts = flatten(ts);\n  ts = distributeUnion(ts).map(intersectionNoUnion);\n  return union(...ts);\n}",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Synthesizing with intersection types',
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
          href: '/blog/2021-10-14-Reconstructing-TypeScript-part-4#synthesizing-with-union-types',
          children: [
            {
              text: 'part 4',
            },
          ],
        },
        {
          text: ' that when we synthesize the type of an expression that operates on a subexpression (like a member expression ',
        },
        {
          text: 'foo.bar',
          code: true,
        },
        {
          text: '), we',
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
                  text: 'synthesize the type of the subexpression (',
                },
                {
                  text: 'foo',
                  code: true,
                },
                {
                  text: ' in the example); then',
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
                  text: 'Type.map',
                  code: true,
                },
                {
                  text: ' over the subexpression type with a callback that',
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
                          text: 'checks that a type supports the operation (accessing the ',
                        },
                        {
                          text: 'bar',
                          code: true,
                        },
                        {
                          text: ' property)',
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
                          text: 'computes the result type (the type of ',
                        },
                        {
                          text: 'bar',
                          code: true,
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
          ],
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'like',
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
          text: 'For non-union types, ',
        },
        {
          text: 'Type.map',
          code: true,
        },
        {
          text: ' calls the callback directly on the type; for union types it calls the callback on each arm of the union and returns the union of the results.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Now that we have intersection types we need to handle them in a similar way. For unions, we need every arm to support the operation (since the subexpression may satisfy any of the arms). For intersections, we need only one part to support the operation (since the subexpression satisfies all the parts); when more than one part supports it, we return the intersection of the results. Here's the new ",
        },
        {
          text: 'map',
          code: true,
        },
        {
          text: ' (see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/map.ts#L74',
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
          text: 'function map(t: Type, fn: (t: Type) => Type) {\n  if (isUnion(t)) {\n    return union(...t.types.map(t => map(t, fn)));\n\n  } else if (isIntersection(t)) {\n    const ts: Type[] = [];\n    let error: unknown = undefined;\n    for (const tt of t.types) {\n      try {\n        ts.push(fn(tt));\n      } catch (e) {\n        if (!error) error = e;\n      }\n    }\n    if (ts.length === 0) {\n      throw error;\n    } else {\n      return intersection(...ts);\n\n  } else {\n    return fn(t);\n  }\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'For example, in',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '// foo has type { baz: string } & { bar: 1 | 2 } & { bar: 2 | 3 }\nfoo.bar',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'calling the ',
        },
        {
          text: 'synthMember',
          code: true,
        },
        {
          text: ' callback on the first part of the intersection throws an exception because ',
        },
        {
          text: 'bar',
          code: true,
        },
        {
          text: ' is not supported; the other parts succeed with result types ',
        },
        {
          text: '1|2',
          code: true,
        },
        {
          text: ' and ',
        },
        {
          text: '2|3',
          code: true,
        },
        {
          text: '; so the overall result type is the intersection',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(1 | 2) & (2 | 3)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'which normalizes to',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '2',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'If the callback fails on all the parts, ',
        },
        {
          text: 'map',
          code: true,
        },
        {
          text: ' throws an exception; the error message is the one from the first part. (Actual TypeScript gives a more helpful error here, referencing the whole intersection type, not just a part.)',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: 'Synthesizing function types with intersections',
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
          href: '/blog/2021-09-27-Reconstructing-TypeScript-part-2#function-expressions',
          children: [
            {
              text: 'part 2',
            },
          ],
        },
        {
          text: ' that to synthesize a type from a function, we bind the argument types in the environment and synthesize a result type from the function body:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function synthFunction(env: Env, ast: AST.ArrowFunctionExpression): Type {\n  ...\n  const bindings = ast.params.map(param => {\n    ...\n    return {\n      name: param.name,\n      type: Type.ofTSType(param.typeAnnotation.typeAnnotation),\n    };\n  });\n  const args = bindings.map(({ type }) => type);\n  const bodyEnv =\n    bindings.reduce(\n      (env, { name, type }) => env.set(name, type),\n      env\n    );\n  const ret = synth(bodyEnv, ast.body);\n  return Type.functionType(args, ret);\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'So for a function expression',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(x: number | string) => x',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'we synthesize the type',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(number | string) => (number | string)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "This type is not very precise—it doesn't capture the fact that you always get back a value of the same type you put in.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now that we have intersections, we can split the argument cases to get a more precise type:',
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
                  text: 'distribute unions in the function arguments;',
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
                  text: 'for each resulting argument list',
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
                          text: 'bind the argument types in the environment;',
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
                          text: 'synthesize a result type from the function body; and',
                        },
                      ],
                    },
                  ],
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
                  text: 'intersect the resulting function types.',
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/typecheck/synth.ts#L83',
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
          text: 'function synthFunction(env: Env, ast: AST.ArrowFunctionExpression): Type {\n  ... // same as before up to `const bodyEnv = `\n  const argsLists = Type.distributeUnion(args);\n  const funcTypes = argsLists.map(args => {\n    const bodyEnv =\n      bindings.reduce(\n        (env, { name }, i) => env.set(name, args[i]),\n        env\n      );\n    const ret = synth(bodyEnv, ast.body);\n    return Type.functionType(args, ret);\n  })\n  return Type.intersection(...funcTypes);\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now for the example above, we synthesize a type from the body in the case where ',
        },
        {
          text: 'x: number',
          code: true,
        },
        {
          text: ' and in the case where ',
        },
        {
          text: 'x: string',
          code: true,
        },
        {
          text: ', then intersect the results to get',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(number => number) & (string => string)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'This type is more precise than the original—it captures the fact that you always get back a value of the same type that you put in.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Actual TypeScript does not split cases like this. My guess is that this is for performance reasons: for most functions the result type doesn't vary according to the arguments, so it's a waste of effort to synthesize the body for each arm of union args. Maybe it's better not to split cases in synthesis, but only in checking, so you can get it if you need it with a type ascription. (But actual TypeScript doesn't do this either, see below.)",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Subtyping intersection types',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'Since a value of intersection type must satisfy all the parts of the intersection',
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
                  text: 'an intersection type is a subtype of another type when at least one of its parts is a subtype of the other type;',
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
                  text: "a type is a subtype of an intersection type when it's a subtype of all the parts of the intersection; and",
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
                  text: 'every type is a subtype of ',
                },
                {
                  text: 'unknown',
                  code: true,
                },
                {
                  text: ' (an intersection of no parts).',
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
          href: 'https://github.com/jaked/reconstructing-typescript/blob/part5/src/type/isSubtype.ts#L14',
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
          text: 'function isSubtype(a: Type, b: Type): boolean {\n  if (Type.isNever(a)) return true;\n  if (Type.isUnknown(b)) return true;\n\n  if (Type.isUnion(a))        return a.types.every(a => isSubtype(a, b));\n  if (Type.isUnion(b))        return b.types.some(b => isSubtype(a, b));\n\n  if (Type.isIntersection(a)) return a.types.some(a => isSubtype(a, b));\n  if (Type.isIntersection(b)) return b.types.every(b => isSubtype(a, b));\n  ...',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "(I've left in the cases for unions and ",
        },
        {
          text: 'never',
          code: true,
        },
        {
          text: ' because they show the duality between union and intersection.)',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We saw in ',
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
          text: ' that these straightforward subtyping rules for unions are incomplete. A similar issue comes up for intersections—for example',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ foo: { bar: 7 } & { baz: 9 } }\n{ foo: { bar: 7 } } & { foo: { baz: 9 } }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'contain the same values, and the first is a subtype of the second, but the second is not a subtype of the first according to these rules. Again, actual TypeScript does better here; it detects that each is a subtype of the other. I need to find out how it works!',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: '(By the way, you can check subtyping in the ',
        },
        {
          type: 'a',
          href: 'https://www.typescriptlang.org/play',
          children: [
            {
              text: 'TypeScript playground',
            },
          ],
        },
        {
          text: ' like so',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type IsSubtype<T1, T2> = T1 extends T2 ? true : false\n\nconst t: IsSubtype<\n  { foo: { bar: 7 } & { baz: 9 } },\n  { foo: { bar: 7 } } & { foo: { baz: 9 } }\n> = true',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'If ',
        },
        {
          text: 'T1',
          code: true,
        },
        {
          text: ' is not a subtype of ',
        },
        {
          text: 'T2',
          code: true,
        },
        {
          text: ', TypeScript will flag an error that type ',
        },
        {
          text: 'true',
          code: true,
        },
        {
          text: ' is not assignable to type ',
        },
        {
          text: 'false',
          code: true,
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
          text: 'Checking against intersection types',
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
          href: '/blog/2021-10-14-Reconstructing-TypeScript-part-4#checking-against-union-types',
          children: [
            {
              text: 'part 4',
            },
          ],
        },
        {
          text: " that checking against union types isn't very useful because it doesn't produce good error messages. It works better for intersection types: since an expression of intersection type must satisfy all the parts, we can just check them all (see check.ts):",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'function check(env: Env, ast: AST.Expression, type: Type): void {\n  if (Type.isIntersection(type))\n    return type.types.forEach(type => check(env, ast, type));\n  ...',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'Now we can check overloaded function types, like:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(x => x) as ((x: number) => number) & ((x: string) => string)\n(x => x) as ((x: number) => number) & ((x: string) => boolean)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'When checking fails we get an error mentioning the part that failed.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Actual TypeScript doesn't handle this kind of example; for",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const f: ((x: 7) => 7) & ((x: 9) => 9) = (x => x)',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'it produces',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: "Type '(x: 7 | 9) => 7 | 9' is not assignable to type '((x: 7) => 7) & ((x: 9) => 9)'.\n  Type '(x: 7 | 9) => 7 | 9' is not assignable to type '(x: 7) => 7'.\n    Type '7 | 9' is not assignable to type '7'.\n      Type '9' is not assignable to type '7'",
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: "It seems like TypeScript doesn't check the function against the type in this case, but instead synthesizes a type for the function under the assumption that ",
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' has type ',
        },
        {
          text: '7|9',
          code: true,
        },
        {
          text: ' (it undoes the rewrite we do in synthesis), then checks subtyping (or ',
        },
        {
          text: 'assignability',
          italic: true,
        },
        {
          text: " in TypeScript terms). I don't know why!",
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
      type: 'p',
      children: [
        {
          text: 'Callbacks passed to ',
        },
        {
          text: 'Type.map',
          code: true,
        },
        {
          text: " are labelled to match the enclosing function; and since they usually close over the subexpression AST, they're annotated with the AST for context. So the callback in ",
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
      type: 'liveCode',
      children: [
        {
          text: '<iframe\n  src="https://jaked.org/reconstructing-typescript/part5/"\n  width={700}\n  height={500}\n  style={{ borderStyle: \'none\' }}\n/>',
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
          text: 'For the full code of part 5 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/tree/part5',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/tree/part5',
            },
          ],
        },
        {
          text: '. To view the changes between part 4 and part 5 see ',
        },
        {
          type: 'a',
          href: 'https://github.com/jaked/reconstructing-typescript/compare/part4...part5',
          children: [
            {
              text: 'https://github.com/jaked/reconstructing-typescript/compare/part4...part5',
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
          text: "Next time we'll finally implement ",
        },
        {
          text: 'narrowing',
          italic: true,
        },
        {
          text: '!',
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
    title: 'How to implement a TypeScript-style type checker (Reconstructing TypeScript), part 5: intersection types',
  },
}