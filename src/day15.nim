import
  std/sugar,
  std/sequtils,
  std/strutils,
  std/algorithm,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  Area = tuple[x, y, r: int]

proc parseArea(input: string): Area =
  let
    nums = input
      .replace("Sensor at x=", "")
      .replace(" y=", "")
      .replace(": closest beacon is at x=", ",")
      .split(",")
      .map(parseInt)
    sx = nums[0]
    sy = nums[1]
    bx = nums[2]
    by = nums[3]
    r = abs(sx - bx) + abs(sy - by)
  (sx, sy, r)

proc minxAtY(area: Area, y: int): int =
  let dy = abs(area.y - y)
  if dy <= area.r:
    area.x - area.r + dy
  else:
    high(int)

proc partOne(input: seq[Area]): string =
  let
    # target = 10 # uncomment for example input
    target = 2_000_000 # uncomment for real input
    sortedInput = input.sortedByIt(minxAtY(it, target))
  var
    total = 0
    x = sortedInput[0].x - sortedInput[0].r
  for area in sortedInput:
    let dy = abs(area.y - target)
    if dy <= area.r:
      let
        minx = area.x - area.r + dy
        maxx = area.x + area.r - dy
      if maxx > x:
        total += maxx - max(x, minx)
        x = maxx # the new furthest right
  $total

proc partTwo(input: seq[Area]): string =
  let
    # tRange = (0, 20) # uncomment for example input
    tRange = (0, 4_000_000) # uncomment for real input
  var sortedInput = input
  for target in tRange[0]..tRange[1]:
    # TODO(optimization): how do without sorting? Gotta be a way.
    sortedInput.sort((a, b: Area) => cmp(minxAtY(a, target), minxAtY(b, target)))
    var
      x = tRange[0]
    for area in sortedInput:
      let dy = abs(area.y - target)
      if dy <= area.r:
        let
          minx = area.x - area.r + dy
          maxx = area.x + area.r - dy
        if minx > x:
          return $((x + 1) * 4_000_000 + target)
        if maxx > x:
          x = maxx # the new furthest right
        if x > tRange[1]:
          break
  "well, shucks"

when isMainModule:
  echo "### DAY 15 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines.map(parseArea)

