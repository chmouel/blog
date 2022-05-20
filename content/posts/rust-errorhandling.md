---
title: "Error chaining with Rust and Go"
date: 2022-05-20T09:54:31+02:00
toc: true
---
I was talking with a [colleague](https://www.sebastien-han.fr/blog/) about Rust
and we were wondering (since we are both learning the language) how error
handling compares to Go.

## Chaining error in Go

Go's best practice when you want to chain multiple errors is to "wrap" them.

For example let's say you have this function returning an error:

```go
fn do_something() err {
 value := "value"
  if value != "expected" {
    return fmt.Errorf("this was not expected")
  }
}
```

when we call the function `do_something()` from another function, we want to
add context to it and to do so we will wrap it around it with the "%w"
directive:

```go
fn start_doing_something() err {
 err := do_something()
 if err != nil {
  return fmt.Errorf("I got an error while trying to do something: %w", err)
 }
}
```

## Error chaining in Rust

So now how do we do this in Rust?

It does not seems there is any built-in way to do this but you can use the
vastly popular crates called [`anyhow`](https://crates.io/crates/anyhow) for it.

In this case it's not called wrapping but context (which is a confusing overused
term imho) and here is an example :

```rust
use anyhow::Context;

#[derive(thiserror::Error, Debug)]
pub enum MyErr {
    #[error("This is the first error")]
    FirstError,

    #[error("This is the middle error")]
    MidError,

    #[error("This is the final error")]
    FinalError,
}
fn first() -> anyhow::Result<(), MyErr> {
    Err(MyErr::FirstError)
}

fn second() -> anyhow::Result<(), anyhow::Error> {
    first().context(MyErr::MidError)
}

fn finally() -> anyhow::Result<(), anyhow::Error> {
    second().context(MyErr::FinalError)
}

fn main() -> anyhow::Result<()> {
    finally()?;
    Ok(())
}
```

* We first make our own enum of custom errors.
  The enum has a derive on another crates called
  [`thiserror`](https://crates.io/crates/thiserror). This crates allows you to
  have human friendly error message without having to do too much work for it.

* starting from the bottom on the main function we return and "Box" all our
  errors with `anyhow::Results` this will get all error to it.

* We call the `finally` function with the "?" operator at the end. It's a
  shorthand to say :

  * if it's Ok, then yeah please go on and continue do your work.
  * if it's not then return the error.
  * from the finally function we call another function called second, they are both adding
    a context to the error to let the user know where this comes from. This only
    happen if we are erroring. If we were Ok() we would not get any error.

The final output will looks like this:

```text
% cargo run -q
Error: This is the final error

Caused by:
    0: This is the middle error
    1: This is the first error
```

with the help of anyhow and thiserror we are nicely showing the chain of errors and what caused it.

## My very humble comparaison between Go and Rust error chaining

The go way is definitely more idiomatic and much easier to write and understand
than the the rust way. However the Rust way is more elegant and I feel
in the long term will be more robust if we have to do some refactoring.
