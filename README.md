# spread

`spread` macro for spreading blocks into call parameters/collections

```nim
import spread

proc foo(a, b, c: int) =
  echo "a: ", a
  echo "b: ", b
  echo "c: ", c

foo.spread:
  1
  c = 3
  b = 2

spread foo(1): # limitation: can't call with dot syntax for calls
  c = 3
  b = 2

const arr = [].spread:
  1
  2
  3

assert arr == [1, 2, 3]

let tab = {:}.spread:
  "a" = 1 # constructors convert = in a statement to :
  _("b": 2, "c": 3) # all arguments of _ are spread directly

assert tab == {"a": 1, "b": 2, "c": 3}

type Foo = object
  a, b, c: int

# to spread object or tuple constructors without any arguments, include a single _: _
let obj = spread Foo(_: _):
  a = 1
  c = 3
  b = 2

assert obj = Foo(a: 1, b: 2, c: 3)
```
