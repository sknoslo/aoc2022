import
  std/sequtils,
  std/strutils,
  std/algorithm,
  std/strformat,
  std/parseutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  OrderResult = enum
    correct,
    keepgoing,
    incorrect
  NodeKind = enum
    nkNum,
    nkList
  Node = ref object
    case kind: NodeKind
    of nkNum:
      numVal: BiggestInt
    of nkList:
      listVal: seq[Node]
  PacketPair = tuple[left, right: Node]

proc `$`(node: Node): string =
  case node.kind:
    of nkNum:
      $node.numVal
    of nkList:
      "[" & node.listVal.map(`$`).join(",") & "]"

proc parseNumNode(input: string, node: var Node, start = 0): int =
  var val: BiggestInt = 0
  result = parseBiggestInt(input, val, start)
  node = Node(kind: nkNum, numVal: val)

proc parseListNode(input: string, node: var Node, start = 0): int =
  var pos = start + skip(input, "[", start)
  node = Node(kind: nkList, listVal: @[])
  while pos < input.len and input[pos] != ']':
    if input[pos] == '[':
      var childNode: Node
      pos += parseListNode(input, childNode, pos)
      node.listVal.add(childNode)
    elif input[pos] == ',':
      pos += skip(input, ",", pos)
    elif input[pos] in {'0'..'9'}:
      var childNode: Node
      pos += parseNumNode(input, childNode, pos)
      node.listVal.add(childNode)

  pos + skip(input, "]", pos) - start


proc parseNode(input: string): Node =
  var node: Node
  discard parseListNode(input, node)
  node

proc correctOrder(left, right: Node): OrderResult =
  if left.kind == nkNum and right.kind == nkNum:
    if left.numVal < right.numVal:
      return correct
    elif left.numVal > right.numVal:
      return incorrect
    else:
      return keepgoing
  if left.kind == nkNum and right.kind == nkList:
    return correctOrder(Node(kind: nkList, listVal: @[left]), right)
  if left.kind == nkList and right.kind == nkNum:
    return correctOrder(left, Node(kind: nkList, listVal: @[right]))
  if left.kind == nkList and right.kind == nkList:
    for (l, r) in left.listVal.zip(right.listVal):
      let res = correctOrder(l, r)
      if res != keepgoing:
        return res
    if right.listVal.len < left.listVal.len:
      return incorrect
    elif left.listVal.len < right.listVal.len:
      return correct
    else:
      return keepgoing
  else:
    raise newException(Exception, "Ya dun goofed")

proc partOne(input: seq[PacketPair]): string =
  var
    total = 0
    index = 1
  for pair in input:
    var (left, right) = pair

    if correctOrder(left, right) == correct:
      total += index

    inc(index)

  $total

proc partTwo(input: var seq[Node]): string =
  let
    markerA = parseNode("[[2]]")
    markerB = parseNode("[[6]]")
  input.add(markerA);
  input.add(markerB);
  input.sort(proc (a, b: Node): int =
    if correctOrder(a, b) == incorrect:
      return 1
    return -1)

  let
    aPos = input.find(markerA) + 1
    bPos = input.find(markerB) + 1

  $(aPos * bPos)

when isMainModule:
  echo "### DAY 13 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"
  
  bench(partOne(parsedOne), partTwo(parsedTwo)):
    let parsedOne = input.strip.split("\n\n").map(proc (pair: string): PacketPair =
      let lines = pair.splitLines.map(parseNode)
      (lines[0], lines[1]))
    var parsedTwo = input.strip.replace("\n\n", "\n").splitLines.map(parseNode)

