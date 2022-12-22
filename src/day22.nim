import
  std/tables,
  std/strutils,
  std/parseutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  Point = tuple[x, y: int]
  CellKind = enum ckWall, ckTile
  StepKind = enum skTurn, skMove
  TurnDir = enum tdLeft, tdRight
  Step = object
    case kind: StepKind
      of skTurn:
        dir: TurnDir
      of skMove:
        dist: int

proc `+`(a, b: Point): Point =
  (a.x + b.x, a.y + b.y)

proc parseMap(input: string): Table[Point, CellKind] =
  var y = 1
  result = initTable[Point, CellKind]()
  for line in input.splitLines:
    var x = 1
    for c in line:
      if c == '.':
        result[(x, y)] = ckTile
      elif c == '#':
        result[(x, y)] = ckWall
      inc(x)
    inc(y)
  discard

proc parseDir(input: string, dir: var TurnDir, start: int): int =
  var c: char
  let l = parseChar(input, c, start)
  dir = case c:
    of 'L': tdLeft
    of 'R': tdRight
    else: raise newException(Exception, "ya dun goofed")
  l

proc parseInstructions(input: string): seq[Step] =
  result = newSeq[Step]()
  var
    dist: int
    cursor = parseInt(input, dist, 0)
  result.add(Step(kind: skMove, dist: dist))

  while cursor < input.len:
    var dir: TurnDir
    cursor += parseDir(input, dir, cursor)
    result.add(Step(kind: skTurn, dir: dir))
    cursor += parseInt(input, dist, cursor)
    result.add(Step(kind: skMove, dist: dist))

const
  E = 0
  S = 1
  W = 2
  N = 3
  deltas: array[4, Point] = [(1, 0), (0, 1), (-1, 0), (0, -1)]

proc partOne(map: Table[Point, CellKind], instructions: seq[Step]): string =
  var
    delta = 0
    pos: Point = (1, 1)

  while pos notin map: inc(pos.x)

  for step in instructions:
    case step.kind:
      of skMove:
        for d in 1..step.dist:
          var nextPos = pos + deltas[delta]
          if nextPos notin map:
            let oppoDelta = (delta + 2) mod 4
            while nextPos + deltas[oppoDelta] in map:
              nextPos = nextPos + deltas[oppoDelta]
          if map[nextPos] == ckWall:
            break
          pos = nextPos
      of skTurn:
        case step.dir:
          of tdLeft:
            delta = if delta == E: N else: delta - 1
          of tdRight:
            delta = if delta == N: E else: delta + 1

  $(1000 * pos.y + 4 * pos.x + delta)

# | AB|
# | C |
# |DE |
# |F  |

# Ever heard of a dictionary bro?
proc rotateAboutCube(loc: Point, delta: int): tuple[loc: Point, delta: int] =
  let f = ((loc.x - 1) div 50, (loc.y - 1) div 50)

  if f == (1, 0):
    # A
    if delta == E:
      # GOTO B
      return ((loc.x + 1, loc.y), E)
    elif delta == S:
      # GOTO C
      return ((loc.x, loc.y + 1), S)
    elif delta == W:
      # GOTO D
      return ((1, 151 - loc.y), E)
    else:
      # GOTO F
      return ((1, loc.x + 100), E)
  elif f == (2, 0):
    # B
    if delta == E:
      # GOTO E
      return ((100, 151 - loc.y), W)
    elif delta == S:
      # GOTO C
      return ((100, loc.x - 50), W)
    elif delta == W:
      # GOTO A
      return ((loc.x - 1, loc.y), W)
    else:
      # GOTO F
      return ((loc.x - 100, 200), N)
  elif f == (1, 1):
    # C
    if delta == E:
      # GOTO B
      return ((loc.y + 50, 50), N)
    elif delta == S:
      # GOTO E
      return ((loc.x, loc.y + 1), S)
    elif delta == W:
      # GOTO D
      return ((loc.y - 50, 101), S)
    else:
      # GOTO A
      return ((loc.x, loc.y - 1), N)
  elif f == (1, 2):
    # E
    if delta == E:
      # GOTO B
      return ((150, 151 - loc.y), W)
    elif delta == S:
      # GOTO F
      return ((50, loc.x + 100), W)
    elif delta == W:
      # GOTO D
      return ((loc.x - 1, loc.y), W)
    else:
      # GOTO: C
      return ((loc.x, loc.y - 1), N)
  elif f == (0, 2):
    # D
    if delta == E:
      # GOTO E
      return ((loc.x + 1, loc.y), E)
    elif delta == S:
      # GOTO F
      return ((loc.x, loc.y + 1), S)
    elif delta == W:
      # GOTO A
      return ((51, 151 - loc.y), E)
    else:
      # GOTO C
      return ((51, loc.x + 50), E)
  elif f == (0, 3):
    # F
    if delta == E:
      # GOTO E
      return ((loc.y - 100, 150), N)
    elif delta == S:
      # GOTO B
      return ((loc.x + 100, 1), S)
    elif delta == W:
      # GOTO A
      return ((loc.y - 100, 1), S)
    else:
      # GOTO D
      return ((loc.x, loc.y - 1), N)
  else:
    raise newException(Exception, "ya dun goofed")

proc partTwo(map: Table[Point, CellKind], instructions: seq[Step]): string =
  var
    delta = 0
    pos: Point = (1, 1)

  while pos notin map: inc(pos.x)

  for step in instructions:
    case step.kind:
      of skMove:
        for d in 1..step.dist:
          var
            nextPos = pos + deltas[delta]
            nextDelta = delta
          if nextPos notin map:
            let res = rotateAboutCube(pos, delta)
            nextPos = res.loc
            nextDelta = res.delta
          if map[nextPos] == ckWall:
            break
          pos = nextPos
          delta = nextDelta
      of skTurn:
        case step.dir:
          of tdLeft:
            delta = if delta == E: N else: delta - 1
          of tdRight:
            delta = if delta == N: E else: delta + 1

  $(1000 * pos.y + 4 * pos.x + delta)

when isMainModule:
  echo "### DAY 22 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(map, instructions), partTwo(map, instructions)):
    let
      parts = input.split("\n\n")
      map = parts[0].parseMap
      instructions = parts[1].strip.parseInstructions

