# Level 2 — `if` (Conditional Expressions)

Extends `const` with `if-then-else`. The condition is a **boolean literal** — you can only write `true` or `false`, not a computed boolean.

## What You Can Write

```
if true then 3 + 4 else 10 - 2
if false then 100 else 0
```

## What's New (vs `const`)

| Addition | Description |
|----------|-------------|
| `if B then E1 else E2` | Conditional — picks a branch based on `B` |
| `true`, `false` | Boolean literals (used only as conditions) |

## Language Features

| Feature | Supported |
|---------|-----------|
| Integer literals | ✅ |
| `+`, `-` | ✅ |
| `if-then-else` | ✅ (literal bool condition) |
| Boolean operators (`and`, `or`, `not`) | ❌ |
| Variables | ❌ |
| Functions | ❌ |

## How It Works

The condition `b` in `IfExpr(b, e1, e2)` is a plain OCaml `bool`, not an expression. The evaluator just checks `if b = true then ...`. This will be upgraded in `if_bool`.

## Files

| File | Purpose |
|------|---------|
| `expression.ml` | AST + evaluator — adds `IfExpr of bool * expr * expr` |
| `expression.mli` | Interface |
| `evaluate.ml` | Entry point |
| `lexer.mll` | Adds `if`, `then`, `else`, `true`, `false` keywords |
| `parser.mly` | Adds `if_expr` grammar rule |
| `Makefile` | Build rules |

## Build & Run

```bash
make
echo "if true then 3 + 4 else 10" | ./evaluate
# Output:  = 7
```

## What's Next → `if_bool/`

Makes the condition a full boolean **expression** (`and`, `or`, `not`), not just a literal.
