import
  std/sets,
  std/tables,
  std/strutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type Elf = tuple[x, y: int]

proc `+`(a, b: tuple[x, y: int]): tuple[x, y: int] =
  (a.x + b.x, a.y + b.y)

proc buildMap(input: string): HashSet[Elf] =
  result = initHashSet[Elf]()

  var y = 0
  for line in input.splitLines:
    var x = 0
    for c in line:
      if c == '#':
        result.incl((x, y))
      inc(x)
    inc(y)

const
  N = (0, -1)
  NE = (1, -1)
  E = (1, 0)
  SE = (1, 1)
  S = (0, 1)
  SW = (-1, 1)
  W = (-1, 0)
  NW = (-1, -1)
  DIRS = [
    N, NE, NW,
    S, SE, SW,
    W, SW, NW,
    E, NE, SE
  ]

proc partOne(input: HashSet[Elf]): string =
  var
    proposedMoves = initTable[Elf, Elf](input.len)
    proposedMovesCountTable = initCountTable[Elf](input.len)
    nextElves = initHashSet[Elf](input.len)
    elves = input
    startDir = 0

  for _ in 1..10:
    proposedMoves.clear
    proposedMovesCountTable.clear
    nextElves.clear

    # phase 1
    for elf in elves.items:
      var
        dirToCheck = startDir
        needsToMove = false
      for d in DIRS:
        if elf + d in elves:
          needsToMove = true
          break
      if not needsToMove:
        proposedMoves[elf] = elf
        proposedMovesCountTable.inc(elf)
        continue
      for _ in 1..4: # four cardinal dirs
        var canMove = true
        for i in 0..<3: # three dirs in that cardinal dir
          if elf + DIRS[dirToCheck + i] in elves:
            canMove = false
            break
        if canMove:
          let nextElf = elf + DIRS[dirToCheck]
          proposedMoves[elf] = nextElf
          proposedMovesCountTable.inc(nextElf)
          break
        dirToCheck = (dirToCheck + 3) mod DIRS.len
      if elf notin proposedMoves:
        proposedMoves[elf] = elf
        proposedMovesCountTable.inc(elf)

    # phase 2
    for elf in elves.items:
      let proposedMove = proposedMoves[elf]
      if proposedMovesCountTable[proposedMove] > 1:
        nextElves.incl(elf)
      else:
        nextElves.incl(proposedMove)

    # phase 3
    startDir = (startDir + 3) mod DIRS.len
    let tmp = elves
    elves = nextElves
    nextElves = tmp

  var
    maxx, maxy = int.low
    minx, miny = int.high
  for elf in elves.items:
    maxx = max(elf.x, maxx)
    maxy = max(elf.y, maxy)
    minx = min(elf.x, minx)
    miny = min(elf.y, miny)

  let
    width = maxx - minx + 1
    height = maxy - miny + 1
    area = width * height

  for y in miny..maxy:
    var line = ""
    for x in minx..maxx:
      if (x, y) in elves:
        line &= "#"
      else:
        line &= "."

  $(area - elves.len)

proc partTwo(input: HashSet[Elf]): string =
  var
    proposedMoves = initTable[Elf, Elf](input.len)
    proposedMovesCountTable = initCountTable[Elf](input.len)
    nextElves = initHashSet[Elf](input.len)
    elves = input
    startDir = 0
    round = 0

  while true:
    inc(round)
    proposedMoves.clear
    proposedMovesCountTable.clear
    nextElves.clear

    # phase 1
    for elf in elves.items:
      var
        dirToCheck = startDir
        needsToMove = false
      for d in DIRS:
        if elf + d in elves:
          needsToMove = true
          break
      if not needsToMove:
        proposedMoves[elf] = elf
        proposedMovesCountTable.inc(elf)
        continue
      for _ in 1..4: # four cardinal dirs
        var canMove = true
        for i in 0..<3: # three dirs in that cardinal dir
          if elf + DIRS[dirToCheck + i] in elves:
            canMove = false
            break
        if canMove:
          let nextElf = elf + DIRS[dirToCheck]
          proposedMoves[elf] = nextElf
          proposedMovesCountTable.inc(nextElf)
          break
        dirToCheck = (dirToCheck + 3) mod DIRS.len
      if elf notin proposedMoves:
        proposedMoves[elf] = elf
        proposedMovesCountTable.inc(elf)

    # phase 2
    var elfMoved = false
    for elf in elves.items:
      let proposedMove = proposedMoves[elf]
      if proposedMovesCountTable[proposedMove] > 1:
        nextElves.incl(elf)
      else:
        if elf != proposedMove:
          elfMoved = true
        nextElves.incl(proposedMove)
    if not elfMoved:
      return $round

    # phase 3
    startDir = (startDir + 3) mod DIRS.len
    let tmp = elves
    elves = nextElves
    nextElves = tmp

when isMainModule:
  echo "### DAY 23 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.buildMap

