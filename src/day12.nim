import
  std/sets,
  std/deques,
  std/strutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

iterator adjacent(width, height, pos: int): int =
  let
    y = pos div width
    x = pos mod width

  if x > 0:
    yield pos - 1
  if x < width - 1:
    yield pos + 1
  if y > 0:
    yield pos - width
  if y < height - 1:
    yield pos + width


proc partOne(input: string): string =
  let
    lines = input.splitLines
    initial_grid = lines.join("")
    width = lines[0].len
    height = lines.len
    start = initial_grid.find('S')
    stop = initial_grid.find('E')
    grid = initial_grid.replace('S', 'a').replace('E', 'z')

  var
    visited = initHashSet[int]()
    to_visit = [(start, 0)].toDeque

  while to_visit.len > 0:
    let (pos, steps) = to_visit.popLast
    if pos in visited:
      continue
    if pos == stop:
      return $steps
    let elevation = grid[pos]
    visited.incl(pos)
    for n_pos in adjacent(width, height, pos):
      if ord(grid[n_pos]) - ord(elevation) <= 1:
        to_visit.addFirst((n_pos, steps + 1))
  "Never made it"


proc partTwo(input: string): string =
  let
    lines = input.splitLines
    initial_grid = lines.join("")
    width = lines[0].len
    height = lines.len
    start = initial_grid.find('S')
    stop = initial_grid.find('E')
    grid = initial_grid.replace('S', 'a').replace('E', 'z')

  var
    visited = initHashSet[int]()
    to_visit = initDeque[tuple[pos, steps: int]]()

  for i in 0..<grid.len:
    if grid[i] == 'a':
      to_visit.addFirst((i, 0))

  while to_visit.len > 0:
    let (pos, steps) = to_visit.popLast
    if pos in visited:
      continue
    if pos == stop:
      return $steps
    let elevation = grid[pos]
    visited.incl(pos)
    for n_pos in adjacent(width, height, pos):
      if ord(grid[n_pos]) - ord(elevation) <= 1:
        to_visit.addFirst((n_pos, steps + 1))
  "Never made it"

when isMainModule:
  echo "### DAY 12 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip

