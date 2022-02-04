import spread

block:
  proc foo(a, b, c: int): string = $(a, b, c)

  let x = foo.spread:
    a = 1
    c = 3
    b = 2
  
  doAssert x == "(1, 2, 3)"

  const arr = [].spread:
    1
    2
    3

  doAssert arr == [1, 2, 3]

  let tab = spread {:}:
    "a" = 1 # constructors convert = in a statement to :
    _("b": 2, "c": 3) # all arguments of _ are spread directly

  doAssert tab == {"a": 1, "b": 2, "c": 3}

  type Foo = object
    a, b, c: int

  # to spread object or tuple constructors without any arguments, include a single _: _
  let obj = spread Foo(_: _):
    a = 1
    c = 3
    b = 2

  doAssert obj == Foo(a: 1, b: 2, c: 3)
  
