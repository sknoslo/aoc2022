import
  strutils,
  aoc2022pkg/benchmark

proc partOne(input: string): string =
  "INCOMPLETE"

proc partTwo(input: string): string =
  "INCOMPLETE"

when isMainModule:
  echo "### DAY 01 ###"

  # strip is convenient for splitting lines, but can be harmful for parsers
  let input = stdin.readAll.strip

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  # do parsing here
  let parsed = input

  bench(partOne(parsed), partTwo(parsed))
