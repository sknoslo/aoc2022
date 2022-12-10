import
  std/strutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc partOne(input: seq[string]): string =
  var
    x = 1
    cycles = 1
    sum = 0

  proc maybe_report() =
    if (cycles - 20) mod 40 == 0 and cycles <= 220:
      sum += x * cycles

  for line in input:
    let
      parts = line.split(" ")


    case parts[0]:
      of "noop":
        maybe_report()
        inc(cycles)
      of "addx":
        maybe_report()
        inc(cycles)
        maybe_report()
        inc(cycles)
        x += parseInt(parts[1])
      else:
        discard
  $sum

proc partTwo(input: seq[string]): string =
  var
    x = 1
    cycles = 1
    crt_pos = 0
    crt = ""

  proc print() =
    if crt_pos == 0:
      crt &= "\n"
    if crt_pos >= x - 1 and crt_pos <= x + 1:
      crt &= "#"
    else:
      crt &= "."
    inc(crt_pos)
    if crt_pos == 40:
      crt_pos = 0

  for line in input:
    let
      parts = line.split(" ")

    case parts[0]:
      of "noop":
        print()
        inc(cycles)
      of "addx":
        print()
        inc(cycles)
        print()
        inc(cycles)
        x += parseInt(parts[1])
      else:
        discard
  crt

when isMainModule:
  echo "### DAY 00 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines

