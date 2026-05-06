# Level 3 — `if_bool` (Boolean Expressions)

Extends `if` so the condition can be a **compound boolean expression**, not just `true`/`false`.

## What You Can Write

```
if true and false then 1 else 2
if not false then 42 else 0
if true or false then 10 + 5 else 0
```

## What's New (vs `if`)

| Addition | Description |
|----------|-------------|
| `B1 and B2` | Logical AND of two boolean expressions |
| `B1 or B2` | Logical OR |
| `not B` | Logical NOT |

## Language Features

| Feature | Supported |
|---------|-----------|
| Integer literals, `+`, `-` | ✅ |
| `if-then-else` | ✅ (compound bool condition) |
| `and`, `or`, `not` | ✅ |
| Variables | ❌ |
| Functions | ❌ |

## How It Works

There are now **two separate types**: `bool_expr` and `expr`. The evaluator has two functions:
- `bool_eval : bool_expr -> bool` — evaluates boolean expressions
- `eval : expr -> int` — evaluates integer expressions

The `if` condition is a `bool_expr`, and the branches are `expr`.

## Files

| File | Purpose |
|------|---------|
| `expression.ml` | Two AST types (`bool_expr` + `expr`) and both evaluators |
| `expression.mli` | Interface |
| `evaluate.ml` | Entry point |
| `lexer.mll` | Adds `and`, `or`, `not` keywords |
| `parser.mly` | Adds `bool_expr` grammar rules |
| `Makefile` | Build rules |

## Build & Run

```bash
make
echo "if true and not false then 42 else 0" | ./evaluate
# Output:  = 42
```

## What's Next → `let/`

Adds **variables** and `let x = ... in ...` bindings, introducing the concept of an environment.
