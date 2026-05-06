# Level 4 — `let` (Variables & Environments)

Extends `if_bool` with **variables** and `let` bindings. This is the first version that uses an **environment** — a mapping from variable names to values.

## What You Can Write

```
let x = 5 in x + 3
let x = 10 in let y = 20 in x + y
let x = 3 in if true then x + 1 else x - 1
```

## What's New (vs `if_bool`)

| Addition | Description |
|----------|-------------|
| `x` | Variable reference — looks up value in the environment |
| `let x = E1 in E2` | Evaluate `E1`, bind the result to `x`, then evaluate `E2` |

## Language Features

| Feature | Supported |
|---------|-----------|
| Integer literals, `+`, `-` | ✅ |
| `if-then-else`, `and`/`or`/`not` | ✅ |
| Variables | ✅ |
| `let` bindings | ✅ |
| Equality (`=`) | ❌ |
| Functions | ❌ |

## How It Works

The evaluator now takes **two arguments**: `eval expr env`.

The environment is a linked list of `(name, value)` pairs:
```
EmptyEnv
NonEmptyEnv(("x", 5), NonEmptyEnv(("y", 10), EmptyEnv))
```

- `let x = 3 in ...` → adds `("x", 3)` to the front of the environment
- `x` → searches the environment front-to-back for `"x"`
- Newer bindings shadow older ones (lexical scoping)

**Important:** The environment here stores `int` values. In `let2` it will be upgraded to store `expr` values (preparing for closures).

## Files

| File | Purpose |
|------|---------|
| `expression.ml` | AST + evaluator — adds `Id` and `LetExpr` |
| `expression.mli` | Interface |
| `env.ml` | Environment module — linked list of (name, int) pairs |
| `env.mli` | Environment interface |
| `evaluate.ml` | Entry point — starts with `EmptyEnv` |
| `lexer.mll` | Adds `let`, `in`, `=` tokens |
| `parser.mly` | Adds `ID` and `LET ID EQ expr IN expr` rules |
| `Makefile` | Build rules |

## Build & Run

```bash
make
echo "let x = 5 in x + 3" | ./evaluate
# Output:  = 8
```

## What's Next → `let2/`

Restructures the code: separates the evaluator into its own `Interpreter` module, and upgrades the environment to store `expr` values instead of just `int`.
