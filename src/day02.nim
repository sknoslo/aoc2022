import
  strutils,
  tables,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc partOne(input: seq[string]): string =
  const lookup = {
    "A X": 1 + 3,
    "A Y": 2 + 6,
    "A Z": 3 + 0,
    "B X": 1 + 0,
    "B Y": 2 + 3,
    "B Z": 3 + 6,
    "C X": 1 + 6,
    "C Y": 2 + 0,
    "C Z": 3 + 3
  }.toTable

  var score = 0
  for round in input:
    score += lookup[round]
  $score

proc partTwo(input: seq[string]): string =
  const lookup = {
    "A X": 3 + 0,
    "A Y": 1 + 3,
    "A Z": 2 + 6,
    "B X": 1 + 0,
    "B Y": 2 + 3,
    "B Z": 3 + 6,
    "C X": 2 + 0,
    "C Y": 3 + 3,
    "C Z": 1 + 6
  }.toTable

  var score = 0
  for round in input:
    score += lookup[round]
  $score

when isMainModule:
  echo "### DAY 02 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines

