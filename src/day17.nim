import
  std/os,
  std/terminal,
  std/strutils,
  std/strformat,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  Point = tuple[x, y: int]
  Rock = seq[Point]

var nextRock = 0
var nextDir = 0
const rocks = [
  @[(0, 0), (1, 0), (2, 0), (3, 0)],
  @[(1, 0), (0, 1), (1, 1), (2, 1), (1, 2)],
  @[(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)],
  @[(0, 0), (0, 1), (0, 2), (0, 3)],
  @[(0, 0), (1, 0), (0, 1), (1, 1)]
]

proc getNextRock(): Rock =
  result = rocks[nextRock]
  nextRock = (nextRock + 1) mod rocks.len

proc getNextDir(input: string): char =
  result = input[nextDir]
  nextDir = (nextDir + 1) mod input.len

proc reset() =
  nextRock = 0
  nextDir = 0

proc colliding(rockPos: Point, rock: Rock, chamber: seq[string]): bool =
  for p in rock:
    let
      rx = p.x + rockPos.x
      ry = p.y + rockPos.y
    if rx < 0 or rx > 6:
      return true
    if ry < 0 or ry < chamber.len and chamber[ry][rx] == '#':
      return true
  false

proc settleRock(rockPos: Point, rock: Rock, chamber: var seq[string]) =
  for p in rock:
    var
      rx = p.x + rockPos.x
      ry = p.y + rockPos.y
    while ry >= chamber.len:
      chamber.add(".......")
    chamber[ry][rx] = '#'

var firstPaint = true

proc paintChamber(chamber: seq[string], rockNo: int, rockPos: Point, rock: Rock, lines = 20) =
  if firstPaint:
    firstPaint = false
  else:
    cursorUp(lines+1)

  stdout.writeLine(fmt"Rock: {rockNo}")
  let start = max(chamber.len + 3, lines)
  for y in countDown(start - 1, start-lines):
    var line = "......."
    if y < chamber.len:
      line = chamber[y]
    for p in rock:
      if p.y + rockPos.y == y:
        line[p.x + rockPos.x] = '@'

    stdout.writeLine(line)
  sleep 10

proc partOne(input: string): string =
  var
    chamber = newSeq[string]()

  reset()

  for rockNo in 1..2022:
    var
      rockPos: Point = (2, chamber.len + 3)
      rock = getNextRock()

    while true:
      var nextPos = rockPos
      paintChamber(chamber, rockNo, nextPos, rock)
      case getNextDir(input):
        of '<':
          if not colliding((pred(nextPos.x), nextPos.y), rock, chamber):
            dec(nextPos.x)
        of '>':
          if not colliding((succ(nextPos.x), nextPos.y), rock, chamber):
            inc(nextPos.x)
        else:
          raise newException(Exception, "uh....")

      paintChamber(chamber, rockNo, nextPos, rock)
      
      if colliding((nextPos.x, pred(nextPos.y)), rock, chamber):
        settleRock(nextPos, rock, chamber)
        break
      dec(nextPos.y)
      rockPos = nextPos

  $chamber.len

proc partTwo(input: string): string =
  const
    targetRocks = 1_000_000_000_000
    detectCycleAfter = 1000

  var
    chamber = newSeq[string]()
    match = "STARTVALUE"
    matchRockNo, matchHeight, matchDir, middlePart, rockNo = 0i64
    remainingRocks = targetRocks
    rockToCycleOn = rocks[0]

  reset()

  while remainingRocks > 0:
    dec(remainingRocks)
    inc(rockNo)
    var
      rockPos: Point = (2, chamber.len + 3)
      rock = getNextRock()

    while true:
      var nextPos = rockPos
      case getNextDir(input):
        of '<':
          if not colliding((pred(nextPos.x), nextPos.y), rock, chamber):
            dec(nextPos.x)
        of '>':
          if not colliding((succ(nextPos.x), nextPos.y), rock, chamber):
            inc(nextPos.x)
        else:
          raise newException(Exception, "uh....")

      if colliding((nextPos.x, pred(nextPos.y)), rock, chamber):
        settleRock(nextPos, rock, chamber)

        if match == "STARTVALUE" and rockNo == detectCycleAfter:
          match = chamber[^1]
          rockToCycleOn = rock
          matchRockNo = rockNo
          matchHeight = chamber.len
          matchDir = nextDir
        elif match != "STARTVALUE" and rock == rockToCycleOn and nextDir == matchDir:
          if match == chamber[^1]:
            let
              cycleLen = rockNo - matchRockNo
              cycleHeight = chamber.len - matchHeight
            remainingRocks = (targetRocks - rockNo) mod cycleLen
            middlePart = ((targetRocks - rockNo) div cycleLen) * cycleHeight
        break

      dec(nextPos.y)
      rockPos = nextPos

  $(chamber.len + middlePart)

when isMainModule:
  echo "### DAY 17 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip

