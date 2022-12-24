import
  std/sets,
  std/deques,
  std/tables,
  std/strutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  Tile = enum tWall, tOpen
  Vec = tuple[x, y: int]
  Blizzard = object
    start: Vec
    dir: Vec

var
  WORLD_WIDTH = 0
  WORLD_HEIGHT = 0

proc parseInput(input: string): tuple[world: Table[Vec, Tile], blizzards: seq[Blizzard]] =
  var
    world = initTable[Vec, Tile]()
    blizzards = newSeq[Blizzard]()
    y = 0

  let lines = input.strip.splitLines

  WORLD_WIDTH = lines[0].len
  WORLD_HEIGHT = lines.len

  for line in lines:
    var x = 0
    for c in line:
      if c == '#':
        world[(x, y)] = tWall
      else:
        world[(x, y)] = tOpen
        case c:
          of '^':
            blizzards.add(Blizzard(start: (x, y), dir: (0, -1)))
          of '>':
            blizzards.add(Blizzard(start: (x, y), dir: (1, 0)))
          of 'v':
            blizzards.add(Blizzard(start: (x, y), dir: (0, 1)))
          of '<':
            blizzards.add(Blizzard(start: (x, y), dir: (-1, 0)))
          else:
            discard
      inc(x)
    inc(y)
  (world, blizzards)

proc `+`(a, b: Vec): Vec =
  (a.x + b.x, a.y + b.y)

proc `*`(scale: int, a: Vec): Vec =
  (a.x * scale, a.y * scale)

proc clampToWorld(a: Vec): Vec =
  result = a
  let
    width = WORLD_WIDTH - 2
    height = WORLD_HEIGHT - 2
  if a.x < 1:
    result.x = a.x mod width + width
  elif a.x > width:
    result.x = (a.x - 1 - width) mod width + 1
  elif a.y < 1:
    result.y = a.y mod height + height
  elif a.y > height:
    result.y = (a.y - 1 - height) mod height + 1

proc isBlizzardAt(blizzards: seq[Blizzard], pos: Vec, time: int): bool =
  for blizzard in blizzards:
    let currPos = clampToWorld(blizzard.start + time * blizzard.dir)
    if currPos == pos:
      return true
  false

proc partOne(world: Table[Vec, Tile], blizzards: seq[Blizzard]): string =
  let
    START = (1, 0)
    END = (WORLD_WIDTH - 2, WORLD_HEIGHT - 1)

  var
    toVisit = initDeque[tuple[pos: Vec, time: int]]()
    visited = initHashSet[tuple[pos: Vec, time: int]]()

  toVisit.addFirst((START, 0))

  while toVisit.len > 0:
    let
      v = toVisit.popLast
      (pos, time) = v

    if pos == END:
      return $time

    if v in visited:
      continue

    visited.incl(v)

    if isBlizzardAt(blizzards, pos, time):
      continue

    for dir in [(1, 0), (0, 1), (-1, 0), (0, -1)]:
      let nPos = pos + dir
      if nPos notin world or world[nPos] == tWall:
        continue
      toVisit.addFirst((nPos, time + 1))
    toVisit.addFirst((pos, time + 1))

proc partTwo(world: Table[Vec, Tile], blizzards: seq[Blizzard]): string =
  let
    START = (1, 0)
    END = (WORLD_WIDTH - 2, WORLD_HEIGHT - 1)

  proc shortestPath(startTime: int, startAt, endAt: Vec): int =
    var
      toVisit = initDeque[tuple[pos: Vec, time: int]]()
      visited = initHashSet[tuple[pos: Vec, time: int]]()

    toVisit.addFirst((startAt, startTime))

    while toVisit.len > 0:
      let
        v = toVisit.popLast
        (pos, time) = v

      if pos == endAt:
        return time

      if v in visited:
        continue

      visited.incl(v)

      if isBlizzardAt(blizzards, pos, time):
        continue

      for dir in [(1, 0), (0, 1), (-1, 0), (0, -1)]:
        let nPos = pos + dir
        if nPos notin world or world[nPos] == tWall:
          continue
        toVisit.addFirst((nPos, time + 1))
      toVisit.addFirst((pos, time + 1))

  $shortestPath(shortestPath(shortestPath(0, START, END), END, START), START, END) # ew lol

when isMainModule:
  echo "### DAY 24 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(world, blizzards), partTwo(world, blizzards)):
    let (world, blizzards) = input.parseInput

