import
  std/tables,
  std/strutils,
  std/sequtils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  RobotKind = enum rkOre, rkClay, rkObsidian, rkGeode
  Robot = object
    ore: int
    case kind: RobotKind
      of rkObsidian:
        clay: int
      of rkGeode:
        obsidian: int
      else:
        discard
  Blueprint = object
    id: int
    ore, clay, obsidian, geode: Robot
  Counts = tuple[ore, clay, obsidian, geode: int]

proc parseRobotKind(input: string): RobotKind =
  case input:
    of "ore":
      rkOre
    of "clay":
      rkClay
    of "obsidian":
      rkObsidian
    else:
      rkGeode

proc parseRobot(input: string): Robot =
  let
    parts = input.replace(".", "").split(" ")
    kind = parseRobotKind(parts[1])
  var robot = Robot(kind: kind)
  robot.ore = parseInt(parts[4])
  case kind:
    of rkObsidian:
      robot.clay = parseInt(parts[7])
    of rkGeode:
      robot.obsidian = parseInt(parts[7])
    else:
      discard
  robot

proc parseBlueprint(input: string): Blueprint =
  let
    parts = input.split(": ")
    id = parseInt(parts[0].split(" ")[1])
    robots = parts[1].split(". ").map(parseRobot)
  Blueprint(id: id, ore: robots[0], clay: robots[1], obsidian: robots[2], geode: robots[3])

proc `+`(a, b: Counts): Counts =
  (a.ore + b.ore, a.clay + b.clay, a.obsidian + b.obsidian, a.geode + b.geode)

proc `-`(a, b: Counts): Counts =
  (a.ore - b.ore, a.clay - b.clay, a.obsidian - b.obsidian, a.geode - b.geode)

proc bestCaseRemainingGeodes(timeLeft, bots: int): int {.inline.} =
  (timeLeft + bots) * (timeLeft + bots - 1) div 2

proc maximizeResults(bp: Blueprint, minutes: int): int =
  var
    best = 0
    toVisit = newSeq[tuple[timeLeft: int, resources, robots: Counts]]()
    visited = initTable[tuple[resources, robots: Counts], int]()
    numPops = 0

  let maxOreNeeded = [bp.ore.ore, bp.clay.ore, bp.obsidian.ore, bp.geode.ore].max

  toVisit.add((minutes, (0, 0, 0, 0), (1, 0, 0, 0)))

  while toVisit.len > 0:
    let (timeLeft, resources, robots) = toVisit.pop()
    inc(numPops)

    if timeLeft == 0:
      best = max(resources.geode, best)
      continue

    let bestCase = resources.geode + bestCaseRemainingGeodes(timeLeft, robots.geode)
    if bestCase < best:
      continue
    
    let key = (resources, robots)
    if key in visited and visited[key] >= timeLeft:
      continue
    visited[key] = timeLeft

    toVisit.add((timeLeft - 1, resources + robots, robots))

    if robots.ore < maxOreNeeded and resources.ore >= bp.ore.ore:
      toVisit.add((timeLeft - 1, resources + robots - (bp.ore.ore, 0, 0, 0), robots + (1, 0, 0, 0)))
    if robots.clay < bp.obsidian.clay and resources.ore >= bp.clay.ore:
      toVisit.add((timeLeft - 1, resources + robots - (bp.clay.ore, 0, 0, 0), robots + (0, 1, 0, 0)))
    if robots.obsidian < bp.geode.obsidian and resources.ore >= bp.obsidian.ore and resources.clay >= bp.obsidian.clay:
      toVisit.add((timeLeft - 1, resources + robots - (bp.obsidian.ore, bp.obsidian.clay, 0, 0), robots + (0, 0, 1, 0)))
    if resources.ore >= bp.geode.ore and resources.obsidian >= bp.geode.obsidian:
      toVisit.add((timeLeft - 1, resources + robots - (bp.geode.ore, 0, bp.geode.obsidian, 0), robots + (0, 0, 0, 1)))

  best

proc partOne(input: seq[Blueprint]): string =
  var total = 0
  for bp in input:
    total += bp.id * maximizeResults(bp, 24)
    
  $total

proc partTwo(input: seq[Blueprint]): string =
  var total = 1
  for bp in input[0..2]:
    total *= maximizeResults(bp, 32)
    
  $total

when isMainModule:
  echo "### DAY 19 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines.map(parseBlueprint)

