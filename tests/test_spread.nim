import spread

block:
  proc foo(a, b, c: int): string = $(a, b, c)

  block:
    # regular call:
    let x = foo.spread:
      a = 1
      c = 3
      b = 2
    doAssert x == "(1, 2, 3)"

    # method call syntax:
    let y = spread 1.foo:
      c = 3
      b = 2
    let z = spread 1.foo(2):
      c = 3
    doAssert x == y and y == z
  
  block:
    # operator version:
    let a = ...foo:
      1
      c = 3
      b = 2
    doAssert a == "(1, 2, 3)"

    # operator allows inline version with `do`:
    let b = 1 + (...min do:
      2
      3)
    doAssert b == 3

  block:
    # array constructor:
    const arr = [].spread:
      1
      2
      3
    doAssert arr == [1, 2, 3]

    # table constructor
    let tab = spread {:}:
      "a" = 1 # constructors convert = in a statement to :
      _("b": 2, "c": 3) # all arguments of _ are spread directly
    doAssert tab == {"a": 1, "b": 2, "c": 3}

  block:
    # object or tuple constructors
    type Foo = object
      a, b, c: int
    let obj = spread Foo(_: _):
      a = 1
      c = 3
      b = 2
    doAssert obj == Foo(a: 1, b: 2, c: 3)
  
