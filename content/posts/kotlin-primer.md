---
title: "Kotlin in a hurry (and why you might actually like it)"
date: 2025-10-18T20:14:10+02:00
---

> *Note:* This article was partly generated with AI while I was learning Kotlin.
> It started as personal notes but turned into something readable enough to share.
> Also, Hugo renders it better than my text editor.

You’ve seen Kotlin mentioned in passing.

* “Modern Java,” they said.
* “Null-safe,” they promised.
* “Works on the JVM, Android, browser, fridge, whatever,” they muttered.

Here’s the deal: we’ll learn Kotlin quickly and directly. No corporate slides, no Android Studio screenshots, no JetBrains marketing.  Just the language, the essentials, and a bit of personality to keep you interested.

## The quick pitch

Kotlin is:

* compiled, statically typed, **boring in a good way**,
* **plays nicely with Java** (you can literally call `.javaClass` on anything),
* and makes `NullPointerException` feel like a relic from 2004.

You can use it for Android, backend, CLI tools, or even write multiplatform code
that also runs on iOS.

**Interesting fact:** Kotlin was created at JetBrains in 2011 and named after *Kotlin Island* near St. Petersburg, following the same naming style as Java (from *Java Island*). It officially became a first-class language for Android development in 2017.

---

## The very basics

You’ve seen `var` and `val` before, but let’s be formal:

```kotlin
val immutable = 42      // can’t reassign
var mutable = 0         // can change
mutable += 1
```

Type inference? Yes. Explicit types? Also yes.
You’ll end up mixing both like everyone else.

**Tip:** Prefer `val` unless you really need `var`. Immutability makes your code safer and easier to reason about.

---

## Strings

```kotlin
val who = "world"
println("Hello, $who! 2 + 2 = ${2 + 2}")
```

String templates make interpolation simple. Just don’t forget the `{}` when mixing expressions, or Kotlin will print them literally.

**Did you know?** Kotlin strings are immutable, but you can use `StringBuilder` for efficient concatenation in loops.

---

## Null safety

```kotlin
val name: String? = getMaybe()
val len = name?.length ?: 0
```

That `?.` operator means “don’t fail if it’s null.”
The `?:` means “use something else instead.”
And if you really want to crash:

```kotlin
val sure = name!!.length // not recommended
```

Kotlin makes null handling explicit. It’s a habit worth learning.

**Tip:** Use nullable types sparingly. If a value can be null, question why before adding `?`.

---

## Functions

```kotlin
fun add(a: Int, b: Int) = a + b
fun greet(name: String = "world") { println("Hi $name") }
```

You can omit the return type if it’s obvious. Kotlin will infer it.

**Interesting fact:** Kotlin supports *top-level functions*—you don’t need a class to wrap everything like in Java.

---

## `if` and `when`

```kotlin
val mood = if (hour < 12) "☕" else "🔥"
```

`if` is an expression that returns a value. You’ll also find yourself using `when` instead of `switch`:

```kotlin
val response = when (status) {
    200 -> "OK"
    in 300..399 -> "Redirect"
    else -> "Error"
}
```

**Tip:** `when` can match types, ranges, or even multiple conditions per branch.

---

## Loops

```kotlin
for (i in 0 until 10) println(i)
for (i in 10 downTo 1 step 2) println(i)
```

And if you need both index and value:

```kotlin
listOf("a", "b", "c").forEachIndexed { i, v -> println("$i -> $v") }
```

**Fun fact:** Kotlin doesn’t have a traditional `while(true)` + `break` pattern as often as Java—most looping is handled through functional operators like `map`, `filter`, or `forEach`.

---

## Collections

```kotlin
val nums = listOf(1, 2, 3, 4)
val evens = nums.filter { it % 2 == 0 }
val squares = nums.map { it * it }
val sum = nums.reduce { acc, n -> acc + n }
```

Immutable by default. Mutable versions exist (`mutableListOf`, `mutableMapOf`), but use them when needed.

**Tip:** Prefer functional operations (`map`, `filter`, `fold`) instead of manual loops whenever possible. They’re concise and expressive.

---

## Data classes

```kotlin
data class User(val id: Int, val name: String)
val u1 = User(1, "Sam")
val u2 = u1.copy(name = "Samuel")
```

Data classes give you `equals`, `hashCode`, `toString`, `copy`, and destructuring—all generated automatically.

**Did you know?** You can use `componentN()` functions for destructuring: `val (id, name) = user`.

---

## Objects and companions

```kotlin
object Log { fun d(msg: String) = println(msg) }
class C { companion object { fun make() = C() } }
```

`object` creates a singleton. `companion object` is a singleton inside a class.

**Tip:** You can annotate companion methods with `@JvmStatic` for Java interop.

---

## Extensions

```kotlin
fun String.title(): String =
    split(" ").joinToString(" ") { it.replaceFirstChar(Char::titlecase) }

"hello kotlin".title() // "Hello Kotlin"
```

Extension functions let you add functionality without modifying classes.

**Fact:** Extensions are *statically resolved*. They don’t actually modify the class—they’re just syntactic sugar.

---

## Operator overloading

```kotlin
data class Vec(val x: Int, val y: Int)
operator fun Vec.plus(o: Vec) = Vec(x + o.x, y + o.y)
val v = Vec(1,2) + Vec(3,4)
```

Readable and controlled operator behavior.

**Tip:** Only overload operators when they make sense semantically.

---

## Sealed hierarchies

```kotlin
sealed interface Result<out T>
data class Ok<T>(val value: T): Result<T>
data class Err(val error: Throwable): Result<Nothing>
```

Sealed types give you exhaustive `when` statements. Handle all cases explicitly.

**Fact:** Kotlin’s sealed types are a great way to model state machines or error handling without exceptions.

---

## Coroutines

Coroutines bring structured concurrency and suspendable functions to Kotlin.

```kotlin
import kotlinx.coroutines.*

suspend fun fetch(id: Int): String = withContext(Dispatchers.IO) {
    delay(100)
    "item-$id"
}

suspend fun parallel(): List<String> = coroutineScope {
    (1..3).map { async { fetch(it) } }.awaitAll()
}

fun main() = runBlocking {
    println(parallel())
}
```

Readable concurrency with proper cancellation and scope management.

**Tip:** Prefer `withContext` for switching threads, not for every suspend call.

**Interesting fact:** Coroutines compile into state machines under the hood—lightweight and efficient.

---

## `runCatching`

```kotlin
val res = runCatching { risky() }
    .getOrElse { println("nope"); -1 }
```

Kotlin treats exceptions as values, allowing cleaner error handling.

**Tip:** Combine `runCatching` with extension functions like `.onFailure {}` for clearer recovery flows.

---

## Builders and DSLs

```kotlin
fun html(init: Html.() -> Unit) = Html().apply(init)
class Html {
    private val out = StringBuilder()
    fun div(init: Html.() -> Unit) { out.append("<div>"); init(); out.append("</div>") }
    fun text(s: String) { out.append(s) }
    override fun toString() = out.toString()
}
val h = html { div { text("Hello DSL") } }
```

Kotlin’s syntax makes small domain-specific languages easy to build.

**Example:** Gradle’s Kotlin DSL and Jetpack Compose both rely heavily on this pattern.

---

## Things Kotlin does better than Java

* Null safety.
* Default arguments.
* Smart casts (`if (x is String)` → `x.length`).
* Simpler lambdas.
* Coroutines instead of callback pyramids.
* Less boilerplate.

**Extra tip:** Kotlin’s `data class` + `copy()` pattern is an excellent substitute for builders.

---

## Things Kotlin does worse than Rust

* No manual memory control (GC only).
* Slower at times due to JVM overhead.
* Longer compile times.
* Gradle still has its moods.

**Fact:** Kotlin Native compiles to native binaries, but interoperability and performance still trail Rust.

---

## Example: pulling it together

```kotlin
import kotlinx.coroutines.*
import kotlinx.coroutines.Dispatchers.IO

sealed interface Fetch<out T> {
    data class Ok<T>(val v: T): Fetch<T>
    data class Err(val msg: String): Fetch<Nothing>
}

data class Post(val id: Int, val title: String)

suspend fun fetchPost(id: Int): Fetch<Post> = withContext(IO) {
    runCatching {
        delay(50)
        Post(id, "Hello Kotlin")
    }.fold(
        onSuccess = { Fetch.Ok(it) },
        onFailure = { Fetch.Err(it.message ?: "unknown") }
    )
}

suspend fun fetchAll(ids: List<Int>): List<Post> = coroutineScope {
    ids.map { async { fetchPost(it) } }.awaitAll().mapNotNull {
        when (it) {
            is Fetch.Ok -> it.v
            is Fetch.Err -> null
        }
    }
}

fun main() = runBlocking {
    println(fetchAll((1..3).toList()))
}
```

A concise, real-world pattern: parallel fetching with safe error handling.

---

## Extra Kotlin tips

* Use `apply` for configuration, `let` for transformation, `also` for side effects, `run` for scoping.
* Avoid overusing extension functions—they’re best for domain helpers, not full APIs.
* Prefer `sealed class` over enums when variants hold data.
* When writing libraries, expose interfaces instead of classes for easier testing.
* Remember: Kotlin compiles down to JVM bytecode, so any performance tips for Java often apply.
* Inline functions with `reified` types let you keep generic type info at runtime.

---

## Where to go next

Search for:

* “Kotlin coroutines structured concurrency”
* “Ktor client/server”
* “Kotlin sealed classes vs enums”
* “Arrow-kt” for FP-style programming

Or simply start coding. Kotlin rewards experimentation and practical use.

---

*Thanks for reading.* If this helped you or made Kotlin a bit clearer, feel free to share it or reuse parts of it for your own notes.
