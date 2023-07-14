import macros

macro spread*(call: untyped, args: varargs[untyped]): untyped =
  ## macro for providing call arguments or collection literal elements with
  ## block syntax
  runnableExamples:
    proc foo(a, b, c: int) =
      echo "a: ", a
      echo "b: ", b
      echo "c: ", c

    # regular call:
    foo.spread:
      1
      c = 3
      b = 2

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
    when false: # (nim doc renders badly)
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
  let colonKinds = {nnkBracket, nnkPar, nnkCurly,
    nnkTupleConstr, nnkTableConstr, nnkObjConstr}
  result =
    if call.kind in nnkCallKinds + colonKinds:
      copy(call)
    else:
      newCall(call)
  result.copyLineInfo(call)
  let useColon = result.kind in colonKinds
  if useColon and result.len == 2 and
    result[1].kind == nnkExprColonExpr and result[1][0].eqIdent"_" and
    result[1][1].eqIdent"_":
    result.del(1)
  for arg in (if args.len == 1 and args[0].kind == nnkStmtList: args[0] else: args):
    if arg.kind == nnkAsgn:
      let node = newNimNode(if useColon: nnkExprColonExpr else: nnkExprEqExpr, arg)
      node.add(arg[0])
      node.add(arg[1])
      result.add(node)
    elif arg.kind in nnkCallKinds + {nnkObjConstr} and arg[0].eqIdent"_":
      result.add(arg[1..^1])
    else:
      result.add(arg)

template `...`*(call: untyped, args: varargs[untyped]): untyped =
  ## operator version of `spread`
  runnableExamples:
    proc foo(a, b, c: int) =
      echo "a: ", a
      echo "b: ", b
      echo "c: ", c

    ...foo:
      1
      c = 3
      b = 2

    # allows inline version with `do`:
    let a = 1 + (...min do:
      2
      3)
    assert a == 3
  spread(call, args)
