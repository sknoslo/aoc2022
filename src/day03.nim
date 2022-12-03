import
  sets,
  strutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc priority(c: char): int =
  const distupper = int('A') - 1 - 26
  const distlower = int('a') - 1
  if c in {'A'..'Z'}:
    return int(c) - distupper

  int(c) - distlower

proc halve(input: string): tuple[a, b: string] =
  let half = input.len div 2
  (input[0..<half], input[half..^1])

proc partOne(input: seq[string]): string =
  var total = 0
  for line in input:
    let (a, b) = line.halve
    var common = a.toHashSet * b.toHashSet
    total += priority(common.pop)
  $total

proc partTwo(input: seq[string]): string =
  var
    curr = 0
    total = 0

  while curr < input.len:
    var common = input[curr].toHashSet * input[curr+1].toHashSet * input[curr+2].toHashSet
    curr += 3
    total += priority(common.pop)

  $total

when isMainModule:
  echo "### DAY 03 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines

