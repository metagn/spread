import macros

macro spread*(call: untyped, args: varargs[untyped]): untyped =
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
