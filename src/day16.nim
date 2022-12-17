import
  std/sets,
  std/deques,
  std/tables,
  std/strutils,
  std/sequtils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  Valve = object
    label: string
    flow: int
    tunnels: seq[string]
  ValveMap = ref Table[string, Valve]
  ToVisit = tuple[label: string, time, eventual: int, path: HashSet[string]]


proc toValveMap(valves: seq[Valve]): ValveMap =
  newTableFrom(valves, proc(v: Valve): string = v.label)

proc parseValve(input: string): Valve =
  let
    parts = input
      .replace("Valve ", "")
      .replace("has flow rate=", "")
      .replace("s", "") #lol, what is regex?
      .replace("; tunnel lead to valve", "")
      .replace(", ", ",")
      .split(" ")

  Valve(label: parts[0], flow: parseInt(parts[1]), tunnels: parts[2].split(","))

proc shortestPath(a, b: string, valveMap: ValveMap): int =
  var
    toVisit = [(a, 0)].toDeque
    visited = initHashSet[string]()

  while toVisit.len > 0:
    let (v, dist) = toVisit.popLast
    if v == b:
      return dist
    for t in valveMap[v].tunnels:
      if t notin visited:
        toVisit.addFirst((t, dist+1))
  -1

var distMemo = initTable[tuple[a, b: string], int]()

proc distTo(a, b: string, valveMap: ValveMap): int =
  let keys = [(a, b), (b, a)]
  for key in keys:
    if key in distMemo:
      return distMemo[key]
  let dist = shortestPath(a, b, valveMap)
  for key in keys:
    distMemo[key] = dist
  dist

proc partOne(input: ValveMap): string =
  var
    worthVisiting = newSeq[string]()
    toVisit = newSeq[ToVisit]()
    best = 0

  for v in input.values:
    if v.flow > 0:
      worthVisiting.add(v.label)

  toVisit.add(("AA", 0, 0, initHashSet[string]()))

  while toVisit.len > 0:
    let (v, time, eventual, path) = toVisit.pop()

    if eventual > best:
      best = eventual

    for vn in worthVisiting:
      if vn notin path:
        let
          ntime = distTo(v, vn, input) + 1 + time
        if ntime > 30:
          continue
        let neventual = eventual + (30 - ntime) * input[vn].flow
        var nPath = path
        nPath.incl(vn)
        toVisit.add((vn, ntime, neventual, nPath))

  $best

proc partTwo(input: ValveMap): string =
  var
    worthVisiting = newSeq[string]()
    possiblePaths = initTable[HashSet[string], int]()
    toVisit = newSeq[ToVisit]()

  for v in input.values:
    if v.flow > 0:
      worthVisiting.add(v.label)

  toVisit.add(("AA", 0, 0, initHashSet[string]()))

  while toVisit.len > 0:
    let (v, time, eventual, path) = toVisit.pop()

    if path notin possiblePaths or possiblePaths[path] < eventual:
      possiblePaths[path] = eventual

    for vn in worthVisiting:
      if vn notin path:
        let
          ntime = distTo(v, vn, input) + 1 + time
        if ntime > 26:
          continue
        let neventual = eventual + (26 - ntime) * input[vn].flow
        var nPath = path
        nPath.incl(vn)
        toVisit.add((vn, ntime, neventual, nPath))

  var best = 0
  for p1, score1 in possiblePaths.mpairs:
    for p2, score2 in possiblePaths.mpairs:
      if disjoint(p1, p2):
        if score1 + score2 > best:
          best = score1 + score2
  $best

when isMainModule:
  echo "### DAY 00 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines.map(parseValve).toValveMap

