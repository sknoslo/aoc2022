import
  strutils,
  aoc2022pkg/benchmark

proc solve(input: string): tuple[p1: string, p2: string] =
  let p1 = "INCOMPLETE"
  let p2 = "INCOMPLETE"

  (p1, p2)

proc partOne(input: string): string =
  "INCOMPLETE"

proc partTwo(input: string): string =
  "INCOMPLETE"

when isMainModule:
  echo "### DAY 00 ###"

  # strip is convenient for splitting lines, but can be harmful for parsers
  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  # do parsing here
  let parsed = input

  bench(partOne(parsed), partTwo(parsed))
