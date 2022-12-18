import
  std/sets,
  std/sugar,
  std/strutils,
  std/sequtils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type Point = tuple[x, y, z: int]

const deltas: array[6, Point] = [
  ( 1,  0,  0),
  (-1,  0,  0),
  ( 0,  1,  0),
  ( 0, -1,  0),
  ( 0,  0,  1),
  ( 0,  0, -1)
]

proc pointFromSeq(input: seq[string]): Point =
  (parseInt(input[0]), parseInt(input[1]), parseInt(input[2]))

proc partOne(cubes: HashSet[Point]): string =
  var surfaceArea = 0

  for cube in cubes.items:
    for delta in deltas:
      if (cube.x + delta.x, cube.y + delta.y, cube.z + delta.z) notin cubes:
        inc(surfaceArea)

  $surfaceArea

proc getBounds(cubes: HashSet[Point]): tuple[minx, miny, minz, maxx, maxy, maxz: int] =
  var
    minx, miny, minz = high(int)
    maxx, maxy, maxz = low(int)
  for cube in cubes:
    minx = min(cube.x, minx)
    miny = min(cube.y, miny)
    minz = min(cube.z, minz)
    maxx = max(cube.x, maxx)
    maxy = max(cube.y, maxy)
    maxz = max(cube.z, maxz)
  (minx, miny, minz, maxx, maxy, maxz)

proc partTwo(cubes: HashSet[Point]): string =
  let (minx, miny, minz, maxx, maxy, maxz) = getBounds(cubes)
  var
    knownExposed = initHashSet[Point]()
    knownContained = initHashSet[Point]()

  proc isExposed(point: Point): bool =
    var
      visited = initHashSet[Point]()
      toVisit = @[point]

    while toVisit.len > 0:
      let p = toVisit.pop

      if p in knownExposed or p.x <= minx or p.x >= maxx or p.y <= miny or p.y >= maxy or p.z <= minz or p.z >= maxz:
        knownExposed.incl(visited)
        return true
      if p in knownContained:
        knownContained.incl(visited)
        return false
      visited.incl(p)
      for delta in deltas:
        let np = (p.x + delta.x, p.y + delta.y, p.z + delta.z)
        if np notin cubes and np notin visited:
          toVisit.add(np)
    knownContained.incl(visited)
    false

  var surfaceArea = 0
  for cube in cubes.items:
    for delta in deltas:
      let p = (cube.x + delta.x, cube.y + delta.y, cube.z + delta.z)
      if p notin cubes and isExposed(p):
        inc(surfaceArea)

  $surfaceArea

when isMainModule:
  echo "### DAY 18 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines.map(l => pointFromSeq(l.split(','))).toHashSet

