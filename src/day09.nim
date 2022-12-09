import
  std/math,
  std/sets,
  std/strutils,
  std/strformat,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type Point = tuple[x, y: int]

proc `+`(a, b: Point): Point =
  (a.x + b.x, a.y + b.y)

proc `-`(a, b: Point): Point =
  (a.x - b.x, a.y - b.y)

proc normalize(a: Point): Point =
  var nx, ny = 0
  if a.x != 0:
    nx = a.x div abs(a.x)
  if a.y != 0:
    ny = a.y div abs(a.y)
  (nx, ny)

proc should_move(d: Point): bool =
  abs(d.x) > 1 or abs(d.y) > 1

proc partOne(input: seq[string]): string =
  var
    h: Point = (0, 0)
    t = h
    visited = initHashSet[Point]()

  visited.incl(t)

  for line in input:
    let
      p = line.split(" ")
      dir = p[0]
      dist = parseInt(p[1])
      step = case dir:
        of "L":
          (-1, 0)
        of "R":
          (1, 0)
        of "U":
          (0, -1)
        of "D":
          (0, 1)
        else:
          raise newException(Exception, "ya dun goofed")
    for _ in 1..dist:
      h = h + step
      let delta = h - t
      if should_move(delta):
        t = t + normalize(delta)
        visited.incl(t)

  $visited.len

proc partTwo(input: seq[string]): string =
  var
    h: Point = (0, 0)
    knots = [h, h, h, h, h, h, h, h, h]
    visited = initHashSet[Point]()

  visited.incl(knots[8])

  for line in input:
    let
      p = line.split(" ")
      dir = p[0]
      dist = parseInt(p[1])
      step = case dir:
        of "L":
          (-1, 0)
        of "R":
          (1, 0)
        of "U":
          (0, -1)
        of "D":
          (0, 1)
        else:
          raise newException(Exception, "ya dun goofed")
    for _ in 1..dist:
      h = h + step
      var curr = h
      for k in 0..<knots.len:
        let knot = knots[k]
        let delta = curr - knot
        if should_move(delta):
          knots[k] = knot + normalize(delta)
        curr = knots[k]
      visited.incl(knots[8])

  $visited.len

when isMainModule:
  echo "### DAY 00 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines

