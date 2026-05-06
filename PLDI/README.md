# PLDI – Programming Languages Lab

This repo contains OCaml lab work that walks through how a programming language is built from scratch — from reading characters, to understanding grammar, to actually running code. There are three main stages, each in its own folder.

---

## What's the big picture?

When a programming language runs your code, it does three things in order:

1. **Lexical Analysis (Lexing)** — Break the raw text into meaningful chunks called *tokens*. For example, `let x = 3` becomes `[LET, ID("x"), EQUALS, NUM(3)]`.
2. **Parsing** — Take those tokens and figure out the structure (the *grammar*). This produces a tree that represents the meaning of the expression.
3. **Semantics / Evaluation** — Walk the tree and compute an actual result.

The three folders — `la/`, `parsing/`, `semantics/` — each cover one of these stages.

---

## What you need installed

Before running anything, you need the OCaml toolchain:

| Tool | What it does |
|---|---|
| `ocamlopt` | Compiles OCaml to a native binary (fast) |
| `ocamlc` | Compiles OCaml to bytecode (used for `.mli` interface files) |
| `ocamllex` | Generates a lexer from a `.mll` rule file |
| `ocamlyacc` | Generates a parser from a `.mly` grammar file |
| `make` | Runs the build steps defined in `Makefile` |

> **Windows users:** The easiest way is to install [opam](https://opam.ocaml.org/) inside WSL (Windows Subsystem for Linux), or use Git Bash / MSYS2. All commands below are run in a terminal.

---

## Folder structure at a glance

```
PLDI/
├── la/                 ← Stage 1: Lexical Analysis (turning text into tokens)
│   ├── fsm/            ← Demos of finite-state machines written as OCaml functions
│   ├── manual/         ← A lexer built by hand, module by module
│   └── auto/           ← A lexer generated automatically from a pattern file (.mll)
│
├── parsing/            ← Stage 2: Parsing (understanding the structure/grammar)
│   ├── prefix.ml       ← Standalone parser for prefix-notation math like "+ 1 2"
│   ├── parse-lambda.ml ← Standalone parser for lambda calculus expressions
│   ├── manual/         ← Hand-written recursive-descent parser for arithmetic
│   └── auto/           ← Parser generated automatically from a grammar file (.mly)
│
└── semantics/          ← Stage 3: Semantics (actually evaluating/running expressions)
    ├── const/          ← Simplest interpreter: only integers and +, -, *
    ├── if/             ← Adds: if-then-else
    ├── if_bool/        ← Adds: true/false, &&, ||, not, =
    ├── let/            ← Adds: let x = 3 in ...  (variables)
    ├── let2/           ← Variant of let/ with two simultaneous bindings
    ├── letrec/         ← Adds: let rec f = fun x -> ...  (recursive functions)
    └── proc/           ← Adds: first-class functions (functions as values/closures)
```

---

---

# Stage 1 — Lexical Analysis (`la/`)

A **lexer** reads raw text character by character and groups them into tokens. Think of it like splitting a sentence into individual words and punctuation marks before you try to understand its meaning.

---

## `la/fsm/` — Finite-State Machines

**What it is:** Two OCaml files that show how a finite-state machine (FSM) can be written directly as a set of OCaml functions that call each other. No build or `make` needed.

**Files:**

| File | What it contains |
|---|---|
| `fsm.ml` | Two FSM examples: `one_zero` (accepts strings where 1s come before any 0s) and `id` (accepts valid identifiers like `x`, `myVar`, `foo42`) |
| `tree.ml` | Helper types for building FSM trees |

**How to run:**
```bash
cd la/fsm

# Load in the interactive OCaml REPL
ocaml

# Then inside the REPL, type:
#use "fsm.ml";;
one_zero [1; 1; 0; 0];;    (* true *)
one_zero [0; 1];;           (* false *)
id "hello";;                (* true *)
id "123abc";;               (* false *)
```

---

## `la/manual/` — Hand-written Modular Lexer

**What it is:** A complete lexer built as several small, separately-testable OCaml modules. Each module handles one kind of token. This shows how real software is split into parts with clearly defined interfaces.

**The modules, in dependency order:**

| Module | Files | What it does |
|---|---|---|
| `Mystream` | `mystream.ml`, `mystream.mli` | Wraps a string into a stream you can read character by character |
| `State` | `state.ml`, `state.mli` | Defines the return type that every scanner uses |
| `Id` | `id.ml`, `id.mli` | Scans and recognises identifier tokens like `foo`, `myVar` |
| `Num` | `num.ml`, `num.mli` | Scans and recognises number tokens like `42`, `3.14` |
| `In` | `in.ml`, `in.mli` | Scans and recognises the keyword `in` |
| `Lexer` | `lexer.ml`, `lexer.mli` | The top-level lexer — combines all scanners above into one |

Each important module `<mod>.ml` also has a corresponding `test_<mod>.ml` file that runs unit tests.

**How to build and run:**
```bash
cd la/manual

# Build and test each scanner individually:
make id            # builds the 'id' test binary
./id               # runs the identifier scanner tests

make num           # builds the 'num' test binary
./num              # runs the number scanner tests

make in            # builds the 'in' test binary
./in               # runs the keyword 'in' scanner tests

make string_stream # builds the stream test binary
./string_stream    # runs the stream tests

# Build and test the full combined lexer:
make lexer
./lexer

# Remove all compiled files and start fresh:
make clean
```

> See `la/manual/README.txt` for step-by-step instructions on how to add a new token type (e.g. a scanner for `+` or `while`) to this lexer.

---

## `la/auto/` — Auto-generated Lexer (Word Frequency Counter)

**What it is:** Instead of writing the lexer by hand, here you write a *specification* file (`.mll`) that describes patterns using regular expressions, and `ocamllex` generates the OCaml code for you. The application built here reads text from stdin and counts how often each non-trivial word appears, then prints the results sorted by frequency.

**Files:**

| File | What it is |
|---|---|
| `conv_lexer.mll` | The source specification — edit this to change the lexer |
| `conv_lexer.ml` | Auto-generated by `ocamllex` — do not edit by hand |

The `.mll` file has three parts:
1. **Header** — OCaml code pasted at the top of the generated file (token type definition)
2. **Rules** — Regular expression patterns mapped to actions
3. **Footer** — Additional OCaml code (the word-counting and sorting logic)

**How to build and run:**
```bash
cd la/auto

# Step 1: generate conv_lexer.ml from conv_lexer.mll
ocamllex conv_lexer.mll

# Step 2: compile it
ocamlopt -o conv_lexer conv_lexer.ml

# Step 3: run it — pipe any text in via stdin
echo "the cat sat on the mat the cat" | ./conv_lexer

# Or pass a text file:
cat myfile.txt | ./conv_lexer
```

Common stop-words like `the`, `is`, `in`, `for`, `a`, `an` are automatically filtered out before counting.

---

---

# Stage 2 — Parsing (`parsing/`)

A **parser** takes the flat list of tokens produced by the lexer and builds a tree (called a *parse tree* or *AST — Abstract Syntax Tree*) that represents the grammatical structure. For example, `1 + 2 * 3` should produce a tree where `*` is computed before `+`.

---

## `parsing/prefix.ml` — Prefix Notation Parser (standalone)

**What it is:** A recursive-descent parser for arithmetic written in *prefix notation* — the operator comes before its operands, like `+ 1 2` means `1 + 2`. No build step needed.

The file contains:
- `parse_prefix` — parses a list of tokens into an expression tree
- `infix_of_exp` — converts the tree back to normal infix notation like `(1+2)`
- `evaluate` — computes the integer result
- Test case `t1`: parses `[Op(PLUS); NUM(1); NUM(2)]` and prints the result

```bash
cd parsing
ocaml prefix.ml
# Output: infix = (1+2)
#         value = 3
```

---

## `parsing/parse-lambda.ml` — Lambda Calculus Parser (standalone)

**What it is:** A recursive-descent parser for lambda calculus expressions (the theoretical foundation of functional programming). No build step needed.

The three constructs it parses:
- **Identifier:** `x`
- **Abstraction (function definition):** `lambda x (body)`
- **Application (function call):** `(e1 e2)`

The file includes test cases `t1` through `t6` (including intentional error cases). You can call them in the REPL:
```bash
cd parsing
ocaml

#use "parse-lambda.ml";;
t2 ();;   (* parses "x" *)
t3 ();;   (* parses "(x y)" — applying x to y *)
t4 ();;   (* parses "lambda x (x y)" *)
t6 ();;   (* error: missing closing ) *)
```

---

## `parsing/manual/` — Hand-written Recursive-Descent Parser

**What it is:** A single-file hand-written parser for arithmetic expressions — it parses and evaluates simple infix expressions like `1 + 2 * 3`.

```bash
cd parsing/manual
ocaml rdparser.ml
```

---

## `parsing/auto/` — Auto-generated Parser (ocamllex + ocamlyacc)

**What it is:** A parser for arithmetic expressions built using the standard toolchain — `ocamllex` generates the lexer, `ocamlyacc` generates the parser. This is how most real-world language tools are built. The program evaluates a set of built-in test expressions.

**Files:**

| File | What it is |
|---|---|
| `lexer.mll` | Token rules (source → tokens) |
| `parser.mly` | Grammar rules (tokens → AST) |
| `expr_type.ml/mli` | Defines the expression AST type and an evaluator |
| `main.ml` | Test harness — runs a list of test strings and prints results |

**How to build and run:**
```bash
cd parsing/auto

# Build everything (generates lexer.ml and parser.ml automatically, then compiles)
make

# Run the test cases
./parser
# Example output:
#   1 -> 1
#   1 + 2 -> 3
#   1 + 2 + 3 -> 6
#   1 + 2 + -> false   (parse error)
#   1 * 2 -> 2
#   1 + 2 * 3 -> 7     (correct precedence: * before +)

# Clean all generated and compiled files
make clean
```

---

---

# Stage 3 — Semantics (`semantics/`)

Each sub-folder is a **complete working interpreter** for a small programming language. They are built on top of each other — each one adds one new feature to the previous language. Every interpreter reads an expression (from a file or stdin), parses it, evaluates it, and prints the result.

All of them use the same build command (`make`) and produce the same output binary (`evaluate`).

---

## How to build and run any semantics interpreter

```bash
cd semantics/<folder-name>

make                          # compiles everything → produces ./evaluate
./evaluate                    # interactive mode: type an expression, press Ctrl+D
./evaluate examples/3.txt     # run a specific example file
make clean                    # delete all compiled files
```

---

## `semantics/const/` — Integers and Arithmetic

**Language features:** Integer numbers, `+`, `-`, `*`

**Example input:**
```
3 + 4 * 2
```
**Output:** `= 14`

**Files:**
- `expression.ml/mli` — defines the AST types (`IntConst`, `Add`, `Sub`, `Multiply`)
- `evaluate.ml` — entry point (reads input, calls the evaluator, prints result)
- `lexer.mll`, `parser.mly` — token/grammar rules

---

## `semantics/if/` — Adding Conditionals

**New feature:** `if condition then value1 else value2`

**Example input:**
```
if 3 = 3 then 42 else 0
```
**Output:** `= 42`

---

## `semantics/if_bool/` — Adding Booleans

**New features:** `true`, `false`, `not`, `&&`, `||`, `=`

**Example input:**
```
if true && not false then 1 else 2
```
**Output:** `= 1`

> `if_bool/` also has a `multiplication-instruction.txt` file that explains how multiplication was added to the grammar — useful if you're extending the language yourself.

---

## `semantics/let/` — Adding Variables

**New feature:** `let x = expression in body` — binds a name to a value inside a scope.

**Example input:**
```
let x = 3 in
let y = 4 in
x + y
```
**Output:** `= 7`

The file `let-semantics.txt` shows the formal inference rules for how `let` is evaluated.

---

## `semantics/let2/` — Let with an Environment

**What it is:** A variant of `let/` that makes the *environment* (the mapping from variable names to values) an explicit, passed-around data structure. It's the same language, but the internals are restructured to prepare for `letrec`. Adds a separate `env.ml/mli` module.

---

## `semantics/letrec/` — Adding Recursive Functions

**New feature:** `let rec f = fun x -> body in ...` — defines a function that can call itself by name.

**Example input** (`examples/14.txt`):
```
let rec fact =
  fun n ->
    if n = 1 then 1
    else ((fact (n - 1)) * n)
in
(fact 11)
```
**Output:** `= 39916800`

**How recursion works here:** When you look up `fact` in the environment, you get back a *RecClosure* — a special closure that carries a reference back to itself, so the recursive call works correctly.

**Extra files in this folder:**
| File | Purpose |
|---|---|
| `letrec-semantics.txt` | Formal inference rules (FunDef, FunApp, LetRec, ApplyFound) |
| `reduction-14.txt` | Step-by-step hand-traced evaluation of `fact 3` — shows exactly what the interpreter does at each step |
| `examples/` | 15 numbered test expressions (`1.txt` through `15.txt`) |

**Files and what they do:**
| File | Purpose |
|---|---|
| `expression.ml/mli` | All AST types: `IntConst`, `BoolConst`, `Add`, `If`, `Let`, `FunDef`, `FunApp`, `Closure`, `RecClosure`, etc. Also defines `env` (the variable environment) |
| `interpreter.ml/mli` | The `eval` function — the big-step evaluator that walks the AST |
| `evaluate.ml` | Entry point: parses input, calls `eval`, prints result |
| `lexer.mll` | Tokenises the input text |
| `parser.mly` | Parses tokens into an AST |

---

## `semantics/proc/` — First-class Functions (Closures)

**New feature:** Functions are values. You can pass a function to another function, return a function from a function, and store functions in variables.

**Example input:**
```
let add = fun x -> fun y -> x + y in
((add 3) 4)
```
**Output:** `= 7`

When `fun x -> body` is evaluated, it creates a **closure** — a bundle containing the function parameter, the body, and a snapshot of the current environment. This snapshot is what lets the function remember variables from the scope where it was defined.

The file `proc-semantics.txt` shows the formal inference rules for `FunDef` and `FunApp`.

---

---

## Quick-start command sheet

```bash
# --- FSM demos (no build needed) ---
cd la/fsm && ocaml

# --- Hand-written lexer (full modular build) ---
cd la/manual && make lexer && ./lexer

# --- Auto-generated word-frequency lexer ---
cd la/auto
ocamllex conv_lexer.mll && ocamlopt -o conv_lexer conv_lexer.ml
echo "the cat sat on the mat" | ./conv_lexer

# --- Standalone prefix parser ---
cd parsing && ocaml prefix.ml

# --- Auto-generated arithmetic parser ---
cd parsing/auto && make && ./parser

# --- Run the simplest interpreter (integers only) ---
cd semantics/const && make && ./evaluate

# --- Run the most complete interpreter (with recursion) ---
cd semantics/letrec && make && ./evaluate examples/14.txt

# --- Run the interpreter with first-class functions ---
cd semantics/proc && make && ./evaluate

# --- Clean up any sub-project ---
make clean
```

---

## Common gotchas

- **`make clean` deletes generated files.** Running `make clean` removes `lexer.ml`, `parser.ml`, `parser.mli`, and all `.cmx`/`.cmi`/`.o` files. Just run `make` again to regenerate everything.
- **Don't edit `conv_lexer.ml` or `lexer.ml` or `parser.ml` directly.** These are auto-generated from the `.mll`/`.mly` source files. Your changes will be overwritten next time you run `make`.
- **Build order matters.** The Makefiles handle this for you — always use `make` rather than compiling files manually.
- **Interactive mode:** When you run `./evaluate` without a filename, it waits for you to type an expression. Press **Ctrl+D** (end-of-file) when done to trigger evaluation.
