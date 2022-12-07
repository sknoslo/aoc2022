import
  strutils,
  std/setutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc partOne(input: string): string =
  var curr = 4

  while toSet(input[curr-4..<curr]).len < 4:
    inc(curr)

  $curr

proc partTwo(input: string): string =
  var curr = 14

  while toSet(input[curr-14..<curr]).len < 14:
    inc(curr)

  $curr

when isMainModule:
  echo "### DAY 06 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip

