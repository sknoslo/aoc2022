import
  algorithm,
  strutils,
  sequtils,
  sugar,
  math,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc partOne(input: seq[seq[int]]): string =
  $input.map(cals => cals.sum).max

proc partTwo(input: seq[seq[int]]): string =
  $input.map(cals => cals.sum).sorted[^3..^1].sum

when isMainModule:
  echo "### DAY 01 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.split("\n\n").map(g => g.splitLines.map(parseInt))
