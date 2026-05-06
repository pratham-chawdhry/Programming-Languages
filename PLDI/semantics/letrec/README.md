# Level 7 — `letrec` (Recursive Functions)

The final and most complete language. Extends `proc` with `let rec` for **recursive function definitions**.

## What You Can Write

```
let rec fact = fun n -> if (n = 0) then 1 else n * (fact (n - 1)) in (fact 5)

let rec fib = fun n -> if (n = 0) then 0
                       else if (n = 1) then 1
                       else (fib (n - 1)) + (fib (n - 2))
in (fib 10)
```

## What's New (vs `proc`)

| Addition | Description |
|----------|-------------|
| `let rec f = fun x -> body in ...` | Define a recursive function |
| `RecFunDef` | AST node for recursive function definitions |
| `RecClosure` | Special closure that re-injects itself into its own environment |
| Multiplication (`*`) | Added for convenience |

## Language Features

| Feature | Supported |
|---------|-----------|
| Integer literals, `+`, `-`, `*` | ✅ |
| `if-then-else`, `and`/`or`/`not`, `=` | ✅ |
| Variables, `let` bindings | ✅ |
| Functions, closures, application | ✅ |
| **Recursive functions** (`let rec`) | ✅ |

## How Recursion Works — The RecClosure Trick

The problem with recursion: when `fact` calls itself, the closure's captured environment doesn't contain `fact` yet (because `fact` wasn't fully defined when the closure was created).

The solution: **RecClosure**.

1. `let rec fact = fun n -> body` creates a `RecClosure(n, body, env)` instead of a regular `Closure`
2. When `fact` is looked up in the environment (inside `apply`), the runtime detects it's a `RecClosure`
3. It **re-injects** `fact` into the closure's own environment before returning it as a regular `Closure`
4. Now when the body calls `fact`, it can find itself

```
apply "fact" env
  → finds RecClosure("n", body, env')
  → creates env'' = addBinding "fact" (RecClosure(...)) env'
  → returns Closure("n", body, env'')    ← fact is now in its own env!
```

## Files

| File | Purpose |
|------|---------|
| `expression.ml` | Full AST with `RecFunDef`, `RecClosure`, environment, and the `apply` trick |
| `expression.mli` | Interface |
| `interpreter.ml` | Evaluator — handles all expression types including `RecFunDef` |
| `interpreter.mli` | Interface |
| `evaluate.ml` | Entry point |
| `lexer.mll` | Adds `rec`, `*` tokens |
| `parser.mly` | Adds `LET REC ID EQ recfundef IN expr` rule |
| `Makefile` | Build rules |

## Build & Run

```bash
make
echo "let rec fact = fun n -> if (n = 0) then 1 else n * (fact (n - 1)) in (fact 5)" | ./evaluate
# Output:
#   ...parsed expression...
#    = 120
```

From a file:
```bash
cat > factorial.txt << 'EOF'
let rec fact = fun n ->
  if (n = 0) then 1
  else n * (fact (n - 1))
in (fact 10)
EOF
./evaluate factorial.txt
#  = 3628800
```

## The Complete Language Progression

```
const      →  just integers and +, -
  ↓
if         →  + if-then-else (literal bool condition)
  ↓
if_bool    →  + compound boolean expressions (and, or, not)
  ↓
let        →  + variables and let bindings (introduces environments)
  ↓
let2       →  refactoring: unified types, separate interpreter module
  ↓
proc       →  + first-class functions and closures
  ↓
letrec     →  + recursive functions (RecClosure trick)
```
