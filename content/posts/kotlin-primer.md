---
title: "Kotlin in a hurry (and Why You Might Actually Like It)"
date: 2025-10-18T20:14:10+02:00
draft: true
---

You’ve seen Kotlin mentioned in passing.

* “Modern Java,” they said.
* “Null-safe,” they promised.
* “Works on the JVM, Android, browser, fridge, whatever,” they muttered.

So here’s the deal: we’ll learn Kotlin quickly and swiftly (**did you see the pun
here? hahah so funny**). No corporate slides, no Android Studio screenshots, no
JetBrains marketing.  Just the language, the vibe, and a bit of sarcasm to keep
you awake.

## The quick pitch

Kotlin is:

* compiled, statically typed, **boring in a good way**,
* **plays nicely with Java** (you can literally call `.javaClass` on anything),
* and makes `NullPointerException` feel like a fever dream from 2004.

You can use it for Android, backend, CLI tools, or even write multiplatform code
that pretends to work on iOS.
(*pretends*.)

---

## The very basics

You’ve seen `var` and `val` before, but let’s be formal:

```kotlin
val immutable = 42      // can’t reassign
var mutable = 0         // can change
mutable += 1
```

Type inference? Yes. Explicit types? Also yes.
And you’ll end up mixing both like everyone else.

---

## Strings are smart-ish

```kotlin
val who = "world"
println("Hello, $who! 2 + 2 = ${2 + 2}")
```

See those `$` templates? That’s Kotlin being friendly — until you forget the `{}` and it just prints `$who}` like it’s mocking you.

---

## Null safety, the one real feature

```kotlin
val name: String? = getMaybe()
val len = name?.length ?: 0
```

That `?.` operator means “don’t explode if it’s null.”
The `?:` means “give me something else instead.”
And if you really want to crash:

```kotlin
val sure = name!!.length // yes, I *swear* it’s not null
```

Kotlin gives you rope, but it’s padded.

---

## Functions (short and sweet)

```kotlin
fun add(a: Int, b: Int) = a + b
fun greet(name: String = "world") { println("Hi $name") }
```

You can omit the return type if it’s obvious.
Or not. Kotlin won’t judge. It’ll just infer and move on.

---

## `if` is an expression (not just a statement)

```kotlin
val mood = if (hour < 12) "☕" else "🔥"
```

Everything’s an expression here. You’ll start writing `when` instead of `switch` and feel smug.

```kotlin
val response = when (status) {
    200 -> "OK"
    in 300..399 -> "Redirect"
    else -> "Nope"
}
```

Yes, `in` works on ranges. No, it’s not magic. It’s just operator overloading. We’ll get there.

---

## Loops, briefly

```kotlin
for (i in 0 until 10) println(i)
for (i in 10 downTo 1 step 2) println(i)
```

And for when you don’t care about indexes:

```kotlin
listOf("a", "b", "c").forEachIndexed { i, v -> println("$i -> $v") }
```

---

## Collections and friends

```kotlin
val nums = listOf(1, 2, 3, 4)
val evens = nums.filter { it % 2 == 0 }
val squares = nums.map { it * it }
val sum = nums.reduce { acc, n -> acc + n }
```

Everything is `immutable` by default. Want chaos?
Use `mutableListOf()`. Then question your decisions.

---

## Data classes: records that actually work

```kotlin
data class User(val id: Int, val name: String)
val u1 = User(1, "Sam")
val u2 = u1.copy(name = "Samuel")
```

They give you `equals`, `hashCode`, `toString`, `copy`, and destructuring.
All without writing 70 lines of boilerplate.
(*Java intensifies in the distance.*)

---

## Objects, companions, singletons — oh my

```kotlin
object Log { fun d(msg: String) = println(msg) }
class C { companion object { fun make() = C() } }
```

Kotlin’s `object` is a singleton.
`companion object` is a singleton *inside* your class, because why not.

---

## Extensions (monkey patching, but polite)

```kotlin
fun String.title(): String =
    split(" ").joinToString(" ") { it.replaceFirstChar(Char::titlecase) }

"hello kotlin".title() // "Hello Kotlin"
```

You didn’t subclass `String`. You just *extended* it.
Congratulations, you’ve made a DSL.

---

## Operator overloading (the tasteful kind)

```kotlin
data class Vec(val x: Int, val y: Int)
operator fun Vec.plus(o: Vec) = Vec(x + o.x, y + o.y)
val v = Vec(1,2) + Vec(3,4)
```

Readable math. Dangerous power. Use responsibly.

---

## Sealed hierarchies (for people who liked Rust enums)

```kotlin
sealed interface Result<out T>
data class Ok<T>(val value: T): Result<T>
data class Err(val error: Throwable): Result<Nothing>
```

When you `when`, the compiler forces you to handle all cases.
It’s Kotlin’s way of saying “don’t forget the sad path.”

---

## Coroutines (aka async for grownups)

They look like magic. They’re just `suspend` functions and structured concurrency done right.

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

It’s concurrency you can actually read.
(Unlike Java’s `Future` API, which was written by demons.)

---

## “Try or die” is dead. Meet `runCatching`.

```kotlin
val res = runCatching { risky() }
    .getOrElse { println("nope"); -1 }
```

Exceptions become values. You stop writing `try/catch/finally` pyramids.
Everyone wins, except StackOverflow copy/pasters.

---

## Builders, DSLs, and why Kotlin secretly loves HTML

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

See? You just built a templating language. Accidentally.

---

## Things Kotlin does better than Java

* Null safety that actually works.
* Default arguments.
* Smart casts (`if (x is String)` → `x.length` just works).
* Lambdas that don’t make you cry.
* Coroutines that don’t spawn 18 threads per task.
* 80% less `public static final void`.

---

## Things Kotlin does worse than Rust

* Memory safety (it has a GC, deal with it).
* Performance (JVM is fast, but not *that* fast).
* Compile times. Don’t ask.
* Tooling that doesn’t occasionally scream about Gradle caches.

---

## The full-circle example

Let’s end with something “realish”:

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

It fetches things, handles errors, runs concurrently, and still fits in a tweet-thread screenshot.
That’s Kotlin.

---

## Where to go next

Search for:

* “Kotlin coroutines structured concurrency”
* “Ktor client/server”
* “Kotlin sealed classes vs enums”
* “Arrow-kt” if you want the FP rabbit hole

Or just start writing. Kotlin rewards doing, not reading.
