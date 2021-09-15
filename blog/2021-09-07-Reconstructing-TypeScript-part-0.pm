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
          text: ' > Reconstructing TypeScript, part 0',
        },
      ],
    },
    {
      type: 'h1',
      children: [
        {
          text: 'Reconstructing TypeScript, part 0: intro and background',
        },
      ],
    },
    {
      type: 'h3',
      children: [
        {
          text: '2021-09-07',
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
          text: "I want to dig into what's cool and unusual about TypeScript by presenting a type checker for a fragment of this language (written in actual TypeScript). I'll start with a tiny fragment and build it up over several posts. In this first post I'll give some background to help make sense of the code.",
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
          text: 'I\'m going to assume that you\'ve used a type checker, and have an idea what "type" and "type checking" mean. But I want to unpack these concepts a little:',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "In JavaScript, a variable can hold values of different types. Suppose we don't know what type of value ",
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
          text: "Our human reasoning can be arbitrarily creative and complex, but a type checker is just a program, so its \"reasoning\" is limited. A type checker can't reason that a program correctly sorts a list, for example; but it can check that it doesn't attempt any unsupported operations on values (such as accessing a property that doesn't exist).",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Since a type checker runs at development time, it can't know the actual values flowing through a program at run time. Instead, for each expression in the program, it lumps together the values that might be computed by the expression, and gives the expression a ",
        },
        {
          text: 'type',
          italic: true,
        },
        {
          text: ' that describes attributes shared by all the values: what operations are supported; and, for some operations, what result they return.',
        },
      ],
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
          text: 'As the program runs, ',
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
          text: ' may take on many different values, so ',
        },
        {
          text: 'vec',
          code: true,
        },
        {
          text: ' may also take on many values. But all values of ',
        },
        {
          text: 'vec',
          code: true,
        },
        {
          text: ' support accessing the ',
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
          text: ' properties; and for all such values the result of calling ',
        },
        {
          text: 'typeof',
          code: true,
        },
        {
          text: ' on them is ',
        },
        {
          text: '"object"',
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
          text: 'Now, if the program contains an expression ',
        },
        {
          text: 'vec.z',
          code: true,
        },
        {
          text: ', the type checker sees from the type of ',
        },
        {
          text: 'vec',
          code: true,
        },
        {
          text: ' that accessing the ',
        },
        {
          text: 'z',
          code: true,
        },
        {
          text: " property isn't a supported operation, so it flags an error. A type checker ensures that a program doesn't attempt any unsupported operations on ",
        },
        {
          text: 'concrete values at run time',
          italic: true,
        },
        {
          text: ", by checking that it doesn't attempt any unsupported operations on ",
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
          text: ' (or some equivalent). Or in a language with variants (aka sums or tagged unions), a variable of type ',
        },
        {
          text: 'tree',
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
          text: '.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'This idea goes pretty far—for example, we can define a variant-like tree type as a union of leaf and node object types:',
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
          text: 'with values like:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'const tree = {\n  left: {\n    left: { value: 7 },\n    right: { value: 9 }\n  },\n  right: { value: 11 }\n}',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'If we check the presence of the ',
        },
        {
          text: 'value',
          code: true,
        },
        {
          text: " property, TypeScript narrows the type in each branch, and reasons that it's safe to use the ",
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
          text: ' properties in the false branch:',
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
          text: 'Aside: unions vs. variants',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "If you're familiar with variants, as found in Haskell or OCaml, you might wonder how union types are different. When we define a variant (in OCaml):",
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'type tree =\n  Leaf of { value: int } |\n  Node of { left: tree; right: tree }',
        },
      ],
      language: 'ocaml',
    },
    {
      type: 'p',
      children: [
        {
          text: 'we get several things:',
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
                  text: 'a type ',
                },
                {
                  text: 'tree',
                  code: true,
                },
                {
                  text: '—a value of this type is a ',
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
                  text: " but we don't know which one;",
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
                  text: 'a constructor to make values of each arm—the constructors wrap underlying values with a tag, so the implementation can tell which arm it is; and',
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
                  text: 'support for pattern-matching on values of the type—the implementation uses the tag on a value to tell which arm it is.',
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
          text: 'We write ',
        },
        {
          text: 'tree',
          code: true,
        },
        {
          text: ' values with explicit constructors:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'let tree = Node {\n  left = Node {\n    left = Leaf { value = 7 };\n    right = Leaf { value = 9 }\n  };\n  right = Leaf { value = 11 }\n}',
        },
      ],
      language: 'ocaml',
    },
    {
      type: 'p',
      children: [
        {
          text: 'and discriminate the arms with pattern-matching:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: 'let rec height (tree: tree) =\n  match tree with\n    | Leaf { value } -> 1\n    | Node { left; right } -> 1 + max (height left) (height right)',
        },
      ],
      language: 'ocaml',
    },
    {
      type: 'p',
      children: [
        {
          text: 'In TypeScript, when we define a union type we get just the type. As in the example in the previous section, to construct values of the union we write down ordinary values that satisfy the type of one of the arms, rather than using type-specific constructors. To discriminate the arms we use ordinary test operators and narrowing, rather than type-specific pattern-matching.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Because union types require no new expression syntax, they're flexible and light-weight: for example, if we want a function argument that's either ",
        },
        {
          text: 'boolean',
          code: true,
        },
        {
          text: ' or ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ', we can write ',
        },
        {
          text: 'boolean | string',
          code: true,
        },
        {
          text: ' directly in the argument type, without declaring a type outside the function or requiring callers to wrap the argument in a constructor.',
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
      type: 'p',
      children: [
        {
          text: "In the rest of the post I want to explain at a high level how the type checker works. Next time I'll dig into the actual code.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Aside: Hindley-Milner type inference',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'You might have heard of ',
        },
        {
          text: 'Hindley-Milner type inference',
          italic: true,
        },
        {
          text: ", an approach to type checking that's used in Haskell, OCaml, and others. What I'll cover here is ",
        },
        {
          text: 'not',
          bold: true,
        },
        {
          text: ' Hindley-Milner, but a different approach called ',
        },
        {
          text: 'bidirectional type checking',
          italic: true,
        },
        {
          text: ', which is used in TypeScript, Scala, and others.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Why not Hindley-Milner? Actual TypeScript implements bidirectional type checking; bidirectional type checking is simpler to implement; and Hindley-Milner doesn't combine easily with subtyping and union types, so it isn't a good fit for TypeScript.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Synthesizing a type from an expression',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "A type checker needs to know the type of every expression in the program, so it can ensure that a program doesn't attempt any unsupported operations on expression types. How does it compute these types?",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'We can view a program as a tree (called an ',
        },
        {
          text: 'abstract syntax tree',
          italic: true,
        },
        {
          text: ', or ',
        },
        {
          text: 'AST',
          italic: true,
        },
        {
          text: '), where each expression is a node in the tree, with its subexpressions as children; the leaves are atomic expressions like literal values.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'With this view in mind, we can compute the type of each expression bottom up, from the leaves of the tree to the root:',
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
                  text: 'for an atomic expression, return the corresponding type: ',
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
                  text: ', and so on; and',
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
                  text: 'for a compound expression, find the types of its subexpressions, then combine them according to the top-level operation of the expression.',
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
          text: 'For example, to compute the type of an expression',
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
          text: 'we see that the subexpressions ',
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
          text: ' both have type ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: '; so the overall object expression has type',
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
          text: 'This process is called ',
        },
        {
          text: 'synthesizing',
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
          text: ' an expression.',
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
          text: 'For some kinds of expression, we need to check that the types of the subexpressions agree in some sense. For example, in a function call we need to check that the type of the argument passed to the function is compatible with the argument type expected by the function. What does "compatible" mean?',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'The type of a function argument amounts to a claim (verified by the type checker) that the function will attempt only the operations described by the type on its argument. So the type of an expression passed to a function is compatible with the argument type when the passed type supports ',
        },
        {
          text: 'at least',
          italic: true,
        },
        {
          text: ' the operations described by the function argument type—it can also support other operations. For example, given a function type',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '(vec: { x: number, y: number }) => number',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'the argument type requires that values passed to it support accessing the ',
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
          text: ' properties (and further that the properties are ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: 's). So these types are compatible since they support those at least those operations:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: number, y: number }\n{ x: number, y: number, z: number }\n{ x: number, y: number, foo: string }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'but these types are not compatible:',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: number, y: string }\n{ x: number }\nboolean',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'This idea of compatibility is called ',
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
          text: ' is a ',
        },
        {
          text: 'subtype',
          italic: true,
        },
        {
          text: ' of a type ',
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
          text: '. Given this understanding in terms of supported operations, it makes sense that subtyping is ',
        },
        {
          text: 'reflexive',
          italic: true,
        },
        {
          text: ' (',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ', for any type ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ') and ',
        },
        {
          text: 'transitive',
          italic: true,
        },
        {
          text: ' (if ',
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
          text: ' and ',
        },
        {
          text: 'B',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'C',
          code: true,
        },
        {
          text: ' then ',
        },
        {
          text: 'A',
          code: true,
        },
        {
          text: ' is a subtype of ',
        },
        {
          text: 'C',
          code: true,
        },
        {
          text: ', for any types ',
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
          text: 'So to synthesize the type of a function call, we synthesize the type of the function; synthesize the type of the passed argument; check that the the passed type is a subtype of the function argument type; and finally return the result type of the function.',
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Checking an expression against a type',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "A type checker that uses only synthesis and subtyping does the job: it ensures that a program doesn't attempt any unsupported operations. But there is an alternative that makes the type checker more usable: when we know the type we expect an expression to have (say, when it appears as the argument to a function and we know the function argument type), then we can ",
        },
        {
          text: 'check',
          italic: true,
        },
        {
          text: ' the expression ',
        },
        {
          text: 'against',
          italic: true,
        },
        {
          text: ' the type.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "The idea is that when an expression and type have the same structure, we can break them both down and check each expression part against the corresponding type part. When we can't break them down any further, we fall back to synthesis and subtyping.",
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'For example, to check an object expression',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: 7, y: "nine" }',
        },
      ],
      language: 'typescript',
    },
    {
      type: 'p',
      children: [
        {
          text: 'against an object type',
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
          text: 'we break down the expression and type into properties, then check each property value expression against the corresponding property type: for ',
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' we check ',
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
          text: '; and for ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ' we check ',
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
          text: ". We can't break these down further, so we fall back to synthesis and subtyping: for ",
        },
        {
          text: 'x',
          code: true,
        },
        {
          text: ' we synthesize ',
        },
        {
          text: 'number',
          code: true,
        },
        {
          text: ' from ',
        },
        {
          text: '7',
          code: true,
        },
        {
          text: ' then check that ',
        },
        {
          text: 'number',
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
          text: ' (it is); and for ',
        },
        {
          text: 'y',
          code: true,
        },
        {
          text: ' we synthesize ',
        },
        {
          text: 'string',
          code: true,
        },
        {
          text: ' from ',
        },
        {
          text: '"nine"',
          code: true,
        },
        {
          text: ' then check that ',
        },
        {
          text: 'string',
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
          text: ' (it is not, so we detect a type error).',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'One way this makes the type checker more usable is by localizing errors. In the example above, if we synthesize a type for the whole expression then check subtyping we get an error message like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: 7, y: "nine" }\n^^^^^^^^^^^^^^^^^^^\n\n{ x: number, y: string } is not a subtype of { x: number, y: number }',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'But if we check the expression against the expected type, we get a message like',
        },
      ],
    },
    {
      type: 'code',
      children: [
        {
          text: '{ x: 7, y: "nine" }\n           ^^^^^^\nstring is not a subtype of number',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: 'because the type checker breaks down the expression and type as far as it can, and reports the error at the precise subexpression. When expressions and types are large, this makes errors much easier to read and understand.',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "Another way this makes the type checker more usable is by reducing necessary type annotations, but I'm going to hold off explaining that until we get into the code.",
        },
      ],
    },
    {
      type: 'h2',
      children: [
        {
          text: 'Checking + synthesis = bidirectional type checking',
        },
      ],
    },
    {
      type: 'p',
      children: [
        {
          text: "This approach—check an expression against a type when we know what type to expect, synthesize a type from an expression when we don't—is called ",
        },
        {
          text: 'bidirectional type checking',
          italic: true,
        },
        {
          text: ', so named because type information flows in two directions in the abstract syntax tree: from leaves to root when synthesizing, from root to leaves when checking.',
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
          text: 'OK! I hope that is enough background to make sense of the code. Here is my plan for the series:',
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
    title: 'Reconstructing TypeScript, part 0: intro and background',
    layout: '/layout',
    publish: true,
  },
}