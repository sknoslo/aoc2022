import
  tables,
  strutils,
  sequtils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc parseStacks(initial: string): OrderedTable[string, seq[char]] =
  let
    lines = initial.splitLines
    labels = lines[^1]

  var stacks = initOrderedTable[string, seq[char]]()

  for i, c in labels:
    if c == ' ':
      continue
    
    stacks[$c] = newSeq[char]()
    for j in countdown(lines.len - 2, 0):
      if i < lines[j].len and lines[j][i] != ' ':
        stacks[$c].add(lines[j][i])
      else:
        continue
  stacks

proc parseInst(inst: string): tuple[c: int, a, b: string] =
  let parts = inst.replace("move ", "").replace(" from", "").replace(" to").split(' ')
  (parseInt(parts[0]), parts[1], parts[2])

proc partOne(input: string): string =
  let
    parts = input.split("\n\n")
    initial = parts[0]
    steps = parts[1].strip.splitLines

  var stacks = parseStacks(initial)

  for step in steps:
    let (c, a, b) = parseInst(step)
    for i in 1..c:
      stacks[b].add(stacks[a].pop())
  var code = ""
  for v in stacks.values:
    code &= v[^1]
  code

proc partTwo(input: string): string =
  let
    parts = input.split("\n\n")
    initial = parts[0]
    steps = parts[1].strip.splitLines

  var stacks = parseStacks(initial)

  for step in steps:
    let (c, a, b) = parseInst(step)
    stacks[b] = stacks[b].concat(stacks[a][^c..^1])
    stacks[a].delete(stacks[a].len-c..<stacks[a].len)
  var code = ""
  for v in stacks.values:
    code &= v[^1]
  code

when isMainModule:
  echo "### DAY 05 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input

