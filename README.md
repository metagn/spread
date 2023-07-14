# spread

`spread` macro for spreading blocks into call parameters/collections

```nim
import spread

proc foo(a, b, c: int) =
  echo "a: ", a
  echo "b: ", b
  echo "c: ", c

# regular call:
foo.spread:
  1
  c = 3
  b = 2

# operator version:
...foo:
  1
  c = 3
  b = 2

# operator allows inline version with `do`:
let a = 1 + (...min do:
  2
  3)

assert a == 3

# method call syntax:
spread 1.foo:
  c = 3
  b = 2

spread 1.foo(2):
  c = 3

# arrays:
const arr = [].spread:
  1
  2
  3

assert arr == [1, 2, 3]

# table constructors:
let tab = {:}.spread:
  "a" = 1 # constructors convert = in a statement to :
  _("b": 2, "c": 3) # all arguments of _ are spread directly

assert tab == {"a": 1, "b": 2, "c": 3}

# object or tuple constructors need a single `_: _``:
type Foo = object
  a, b, c: int

let obj = spread Foo(_: _):
  a = 1
  c = 3
  b = 2

assert obj == Foo(a: 1, b: 2, c: 3)
```
