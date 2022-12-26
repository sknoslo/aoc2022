import
  std/math,
  std/strutils,
  std/algorithm,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc snafuToInt(snafu: string): int =
  result = 0
  for digit in 0..<snafu.len:
    let v = case snafu[snafu.len - digit - 1]:
      of '-':
        -1
      of '=':
        -2
      else:
        parseInt($snafu[snafu.len - digit - 1])
    result += v * 5 ^ digit

proc intToSnafu(num: int): string =
  var
    revDigits = newSeq[char]()
    remainder = num
  while remainder != 0:
    let
      v = remainder mod 5
      (digit, carry) = case v:
        of 4: ('-', 1)
        of 3: ('=', 1)
        else: (($v)[0], 0)
    remainder = remainder div 5 + carry
    revDigits.add(digit)

  revDigits.reversed.join

proc partOne(input: seq[string]): string =
  var total = 0
  for line in input:
    total += snafuToInt(line)
  intToSnafu(total)

proc partTwo(input: seq[string]): string =
  "Merry Christmas"

when isMainModule:
  echo "### DAY 25 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines

