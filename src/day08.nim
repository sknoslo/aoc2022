import
  std/strformat,
  std/strutils,
  std/sequtils,
  std/sets,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc partOne(input: seq[seq[int]], visible: var HashSet[tuple[x, y: int]]): string =
  let
    height = input.len
    width = input[0].len
    edge_trees = height * 2 + width * 2 - 4

  for y in countup(1, height-2):
    var tallest = input[y][0]
    for x in countup(1, width-2):
      let h = input[y][x]
      if h > tallest:
        visible.incl((x, y))
        tallest = h

    tallest = input[y][width-1]
    for x in countdown(width-2, 1):
      let h = input[y][x]
      if h > tallest:
        visible.incl((x, y))
        tallest = h

  for x in countup(1, width-2):
    var tallest = input[0][x]
    for y in countup(1, height-2):
      let h = input[y][x]
      if h > tallest:
        visible.incl((x, y))
        tallest = h

    tallest = input[height-1][x]
    for y in countdown(height-2, 1):
      let h = input[y][x]
      if h > tallest:
        visible.incl((x, y))
        tallest = h

  $(visible.len + edge_trees)

# must run part one first with same set
proc partTwo(input: seq[seq[int]], candidates: HashSet[tuple[x, y: int]]): string =
  let
    height = input.len
    width = input[0].len
  var best = 0
  for (cx, cy) in candidates.items:
    var l, r, t, b = 1
    let h = input[cy][cx]
    while cx-l > 0 and h > input[cy][cx-l]:
      inc(l)
    while cx+r < width - 1 and h > input[cy][cx+r]:
      inc(r)
    while cy-t > 0 and h > input[cy-t][cx]:
      inc(t)
    while cy+b < height - 1 and h > input[cy+b][cx]:
      inc(b)
    let score = l * r * t * b
    if score > best:
      best = score

  $best

when isMainModule:
  echo "### DAY 00 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed, visible), partTwo(parsed, visible)):
    var visible = initHashSet[tuple[x, y: int]]()
    let lines = input.strip.splitLines
    let parsed = lines.map(proc (l: string): seq[int] =
      l.map(proc (c: char): int =
        parseInt($c)))

