import
  std/sets,
  std/strutils,
  std/sequtils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type Point = tuple[x, y: int]

proc parseLine(line: string): HashSet[Point] =
  result = initHashSet[Point]()
  let parts = line.split(" -> ").map(proc (p: string): Point =
    let s = p.split(",")
    (parseInt(s[0]), parseInt(s[1])))

  for i in 1..<parts.len:
    let
      a = parts[i-1]
      b = parts[i]

    
    for x in min(a.x, b.x)..max(a.x, b.x):
      for y in min(a.y, b.y)..max(a.y, b.y):
        result.incl((x, y))

proc getBounds(input: HashSet[Point]): tuple[minx, miny, maxx, maxy: int] =
  var
    minx, miny = 10000000
    maxx, maxy = 0
  for (x, y) in input.items:
    if x < minx:
      minx = x
    if y < miny:
      miny = y
    if x > maxx:
      maxx = x
    if y > maxy:
      maxy = y
  (minx, miny, maxx, maxy)

proc printMap(input: HashSet[Point], sim: HashSet[Point]) =
  var
    (minx, miny, maxx, maxy) = getBounds(sim)
    toprint = ""

  for y in miny..maxy:
    var line = ""
    for x in minx..maxx:
      if (x, y) in input:
        line &= "#"
      elif (x, y) in sim:
        line &= "o"
      else:
        line &= "."
    toprint &= line & "\n"
  
  echo toprint


proc partOne(input: HashSet[Point]): string =
  let
    start: Point = (500, 0)
    maxy = getBounds(input).maxy
  var
    sim = input
    units = 0

  while true:
    var sand = start
    while sand notin sim:
      if (sand.x, succ(sand.y)) notin sim:
        inc(sand.y)
      elif (pred(sand.x), succ(sand.y)) notin sim:
        dec(sand.x)
        inc(sand.y)
      elif (succ(sand.x), succ(sand.y)) notin sim:
        inc(sand.x)
        inc(sand.y)
      else:
        inc(units)
        sim.incl(sand)
      if sand.y > maxy:
        return $units

proc partTwo(input: HashSet[Point]): string =
  let
    start: Point = (500, 0)
    maxy = getBounds(input).maxy
    floor = maxy + 2
  var
    sim = input
    units = 0

  while true:
    var sand = start
    while sand notin sim:
      let ny = succ(sand.y)
      if ny < floor and (sand.x, ny) notin sim:
        inc(sand.y)
      elif ny < floor and (pred(sand.x), ny) notin sim:
        dec(sand.x)
        inc(sand.y)
      elif ny < floor and (succ(sand.x), ny) notin sim:
        inc(sand.x)
        inc(sand.y)
      else:
        inc(units)
        sim.incl(sand)
      if sand == start:
        return $units

when isMainModule:
  echo "### DAY 00 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(rock), partTwo(rock)):
    var rock = initHashSet[Point]()
    for line in input.strip.splitLines:
      rock.incl(parseLine(line))

