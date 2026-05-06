# Level 5 — `let2` (Unified Types & Separate Interpreter)

Same language features as `let`, but **restructured** to prepare for adding functions in the next level.

## What You Can Write

```
let x = 5 in x + 3
let x = 10 in let y = 20 in x + y
if true then 1 = 1 else 2 = 3
```

## What Changed (vs `let`)

This is a **refactoring step**, not a new language feature. Key structural changes:

| Change | Why |
|--------|-----|
| Booleans and integers share **one `expr` type** | Preparing for closures (which are also `expr` values) |
| Environment stores `Expression.expr` instead of `int` | So variables can later hold closures, not just numbers |
| Evaluator moved to `Interpreter` module | Cleaner separation of concerns |
| `eval` returns `Expression.expr` instead of `int` | Values are now `IntConst(n)` or `BoolConst(b)` |
| Added `Equals` (`=`) | Compare two values of the same type |

## Language Features

| Feature | Supported |
|---------|-----------|
| Integer literals, `+`, `-` | ✅ |
| `if-then-else`, `and`/`or`/`not` | ✅ |
| Variables, `let` bindings | ✅ |
| Equality (`=`) | ✅ (new!) |
| Functions | ❌ |

## How It Works

The evaluator now returns `Expression.expr` instead of `int`:
```
eval (IntConst 5)  →  IntConst(5)     (* not just 5 *)
eval (Add(...))    →  IntConst(7)
eval (BoolConst b) →  BoolConst(b)
```

This means the entry point (`evaluate.ml`) must pattern-match on the result to print it correctly.

## Files

| File | Purpose |
|------|---------|
| `expression.ml` | AST only — no evaluator here |
| `expression.mli` | Interface |
| `interpreter.ml` | Evaluator + pretty-printer + type extractors |
| `interpreter.mli` | Interface |
| `env.ml` | Environment — stores `Expression.expr` values |
| `env.mli` | Interface |
| `evaluate.ml` | Entry point |
| `lexer.mll` | Same as `let/lexer.mll` |
| `parser.mly` | Same as `let/parser.mly` (with unified types) |
| `Makefile` | Build rules |

## Build & Run

```bash
make
echo "let x = 5 in x + 3" | ./evaluate
# Output: let x = (5) in (x + 3)
#          = 8
```

## What's Next → `proc/`

Adds **first-class functions**: `fun x -> body` and function application `(f arg)`.
