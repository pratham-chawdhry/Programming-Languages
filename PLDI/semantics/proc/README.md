# Level 6 — `proc` (First-Class Functions)

Extends `let2` with **functions as values**. You can define functions, pass them around, and apply them. This is where **closures** appear.

## What You Can Write

```
let f = fun x -> x + 1 in (f 5)
let add = fun x -> fun y -> x + y in ((add 3) 4)
let apply = fun f -> fun x -> (f x) in (apply (fun x -> x + 1) 10)
```

## What's New (vs `let2`)

| Addition | Description |
|----------|-------------|
| `fun x -> body` | Define an anonymous function |
| `(f arg)` | Apply function `f` to argument `arg` |
| Closures | Functions "remember" the environment where they were defined |
| `( ... )` | Parentheses for grouping |

## Language Features

| Feature | Supported |
|---------|-----------|
| Integer literals, `+`, `-` | ✅ |
| `if-then-else`, `and`/`or`/`not` | ✅ |
| Variables, `let` bindings | ✅ |
| Functions (`fun x -> ...`) | ✅ |
| Function application | ✅ |
| Closures | ✅ |
| **Recursion** (`let rec`) | ❌ |

## How It Works

### What is a Closure?

When you write `fun x -> x + y`, the function needs to know the value of `y`. A **closure** bundles together:
1. The parameter name (`x`)
2. The body expression (`x + y`)
3. A **snapshot of the current environment** (which contains `y`'s value)

```
eval (FunDef("x", Add(Id "x", Id "y"))) env
  →  Closure("x", Add(Id "x", Id "y"), env)
```

### Function Application

When you call `(f 5)`:
1. Evaluate `f` → get `Closure(param, body, captured_env)`
2. Evaluate `5` → get `IntConst(5)`
3. Add `(param → 5)` to the **closure's** captured environment
4. Evaluate `body` in that extended environment

The key insight: the body runs in the **closure's** environment, not the caller's environment. This is called **lexical scoping**.

## Files

| File | Purpose |
|------|---------|
| `expression.ml` | AST + environment + pretty-printer (all in one module) |
| `expression.mli` | Interface |
| `interpreter.ml` | Evaluator — adds `FunDef → Closure` and `FunApp` cases |
| `interpreter.mli` | Interface |
| `evaluate.ml` | Entry point — handles `Closure` results too |
| `lexer.mll` | Adds `fun`, `->` tokens |
| `parser.mly` | Adds `FUN ID RTARROW expr` and `expr expr` (application) rules |
| `Makefile` | Build rules |

## Build & Run

```bash
make
echo "let f = fun x -> x + 1 in (f 5)" | ./evaluate
# Output:
#   let f = (fun x -> x + 1) in ((f) (5))
#    = 6
```

## Limitation

You **cannot** write recursive functions here. This fails:
```
let fact = fun n -> if (n = 0) then 1 else n * (fact (n - 1)) in (fact 5)
```
Because when `fact`'s body runs, `fact` is not in the closure's environment.

## What's Next → `letrec/`

Adds `let rec` to support recursive functions.
