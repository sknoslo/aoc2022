import
  std/sugar,
  std/strutils,
  std/sequtils,
  std/strformat,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  ListNode = object
    next, prev: int
    value: int
  CircleList = seq[ListNode]


proc toCircleList(input: openArray[int]): CircleList =
  result = newSeq[ListNode](input.len)
  for i, v in input.pairs:
    let
      prev = if i == 0: input.len - 1 else: i - 1
      next = if i == input.len - 1: 0 else: i + 1
    result[i] = ListNode(value: v, prev: prev, next: next)

proc `$`(node: ListNode): string =
  fmt"{node.value}, [{node.prev}, {node.next}]"

proc `$`(cl: CircleList): string = 
  result = ""
  var curr = 0
  for _ in 1..cl.len:
    if result.len > 0:
      result &= ", "
    result &= $cl[curr].value
    curr = cl[curr].next

proc partOne(input: seq[int]): string =
  var list = input.toCircleList

  for i, item in list.mpairs:
    if item.value mod (input.len - 1) == 0:
      continue
    var curr = i
    list[item.prev].next = item.next
    list[item.next].prev = item.prev
    if item.value > 0:
      for _ in countup(1, item.value mod (input.len - 1)):
        curr = list[curr].next
    else:
      for _ in countdown(-1, item.value mod (input.len - 1) - 1):
        curr = list[curr].prev
    let tmpNext = list[curr].next
    list[curr].next = i
    list[tmpNext].prev = i
    item.next = tmpNext
    item.prev = curr


  const positions = [1000, 2000, 3000]

  let start = input.find(0)
  var
    total = 0
    curr = start

  for p in positions:
    for _ in countup(1, p mod input.len):
      curr = list[curr].next
    total += list[curr].value
    curr = start

  $total

proc partTwo(input: seq[int]): string =
  const decryptionKey = 811589153
  var list = input.map(v => v * decryptionKey).toCircleList

  for _ in 1..10:
    for i, item in list.mpairs:
      if item.value mod (input.len - 1) == 0:
        continue
      var curr = i
      list[item.prev].next = item.next
      list[item.next].prev = item.prev
      if item.value > 0:
        for _ in countup(1, item.value mod (input.len - 1)):
          curr = list[curr].next
      else:
        for _ in countdown(-1, item.value mod (input.len - 1) - 1):
          curr = list[curr].prev
      let tmpNext = list[curr].next
      list[curr].next = i
      list[tmpNext].prev = i
      item.next = tmpNext
      item.prev = curr


  const positions = [1000, 2000, 3000]

  let start = input.find(0)
  var
    total = 0
    curr = start

  for p in positions:
    for _ in countup(1, p mod input.len):
      curr = list[curr].next
    total += list[curr].value
    curr = start

  $total

when isMainModule:
  echo "### DAY 20 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines.map(parseInt)

