# Level 1 — `const` (Integer Arithmetic)

The simplest possible language. Only integer constants and two operators.

## What You Can Write

```
3 + 4
10 - 2 + 1
```

## Language Features

| Feature | Supported |
|---------|-----------|
| Integer literals | ✅ |
| Addition (`+`) | ✅ |
| Subtraction (`-`) | ✅ |
| Booleans | ❌ |
| Variables | ❌ |
| Functions | ❌ |

## How It Works

There is no environment — the evaluator takes an expression and directly returns an `int`. This is the most straightforward recursive interpreter possible.

```
eval (Add(Const 3, Const 4))  →  7
```

## Files

| File | Purpose |
|------|---------|
| `expression.ml` | AST type (`Const`, `Add`, `Subtract`) + evaluator |
| `expression.mli` | Interface for the expression module |
| `evaluate.ml` | Entry point — reads input, parses, evaluates, prints |
| `lexer.mll` | ocamllex spec — tokenises integers and operators |
| `parser.mly` | ocamlyacc grammar — builds the AST |
| `Makefile` | Build rules |

## Build & Run

```bash
make
echo "3 + 4" | ./evaluate
# Output:  = 7
```

Or from a file:
```bash
echo "10 - 2 + 1" > test.txt
./evaluate test.txt
```

## What's Next → `if/`

Adds `if-then-else` with boolean literal conditions (`true`/`false`).
