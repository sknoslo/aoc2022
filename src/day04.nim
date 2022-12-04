import
  sugar,
  strutils,
  sequtils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils


proc partOne(input: seq[string]): string =
  var overlaps = 0

  for line in input:
    let
      parts = line.split(',').map(x => x.split('-').map(parseInt))
      a0 = parts[0][0]
      a1 = parts[0][1]
      b0 = parts[1][0]
      b1 = parts[1][1]
    if (a0 >= b0 and a1 <= b1) or (b0 >= a0 and b1 <= a1):
      inc(overlaps)

  $overlaps

proc partTwo(input: seq[string]): string =
  var overlaps = 0

  for line in input:
    let
      parts = line.split(',').map(x => x.split('-').map(parseInt))
      a0 = parts[0][0]
      a1 = parts[0][1]
      b0 = parts[1][0]
      b1 = parts[1][1]
    if (a0 >= b0 and a0 <= b1) or (b0 >= a0 and b0 <= a1):
      inc(overlaps)

  $overlaps

when isMainModule:
  echo "### DAY 04 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitlines

