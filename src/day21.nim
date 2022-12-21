import
  std/sugar,
  std/tables,
  std/strutils,
  std/sequtils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

proc partOne(input: Table[string, string]): string =
  proc doMonkeyThings(monkey: string): int =
    let action = input[monkey].split(" ")
    if action.len == 1:
      return parseInt(action[0])

    case action[1]:
      of "+":
        return doMonkeyThings(action[0]) + doMonkeyThings(action[2])
      of "-":
        return doMonkeyThings(action[0]) - doMonkeyThings(action[2])
      of "/":
        return doMonkeyThings(action[0]) div doMonkeyThings(action[2])
      of "*":
        return doMonkeyThings(action[0]) * doMonkeyThings(action[2])
      else:
        raise newException(Exception, "ya dun goofed")
  $doMonkeyThings("root")

proc partTwo(input: Table[string, string]): string =
  proc hasHumn(monkey: string): bool =
    if (monkey == "humn"):
      return true
    let action = input[monkey].split(" ")
    if action.len == 1:
      return false
    hasHumn(action[0]) or hasHumn(action[2])

  proc doMonkeyThings(monkey: string): int =
    let action = input[monkey].split(" ")
    if action.len == 1:
      return parseInt(action[0])

    case action[1]:
      of "+":
        return doMonkeyThings(action[0]) + doMonkeyThings(action[2])
      of "-":
        return doMonkeyThings(action[0]) - doMonkeyThings(action[2])
      of "/":
        return doMonkeyThings(action[0]) div doMonkeyThings(action[2])
      of "*":
        return doMonkeyThings(action[0]) * doMonkeyThings(action[2])
      else:
        raise newException(Exception, "ya dun goofed")

  let
    root = input["root"].split(" ")

  var leftSideMonkey, rightSideMonkey: string

  if hasHumn(root[0]):
    leftSideMonkey = root[2]
    rightSideMonkey = root[0]
  else:
    leftSideMonkey = root[0]
    rightSideMonkey = root[2]

  proc equalize(leftSide: int, monkeyName: string): int =
    if monkeyName == "humn":
      return leftSide

    let
      action = input[monkeyName].split(" ")

    
    if hasHumn(action[0]):
      let nextLeftSide = case action[1]:
        of "+":
          leftSide - doMonkeyThings(action[2])
        of "-":
          leftSide + doMonkeyThings(action[2])
        of "*":
          leftSide div doMonkeyThings(action[2])
        of "/":
          leftSide * doMonkeyThings(action[2])
        else:
          raise newException(Exception, "ya dun goofed")
      equalize(nextLeftSide, action[0])
    else:
      let nextLeftSide = case action[1]:
        of "+":
          leftSide - doMonkeyThings(action[0])
        of "-":
          -(leftSide - doMonkeyThings(action[0]))
        of "*":
          leftSide div doMonkeyThings(action[0])
        of "/":
          # this case never happens in my input, but _should_ work???
          doMonkeyThings(action[0]) div leftSide
        else:
          raise newException(Exception, "ya dun goofed")
      equalize(nextLeftSide, action[2])

  $equalize(doMonkeyThings(leftSideMonkey), rightSideMonkey)

when isMainModule:
  echo "### DAY 21 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = input.strip.splitLines.map(l => (l.split(": ")[0], l.split(": ")[1])).toTable()

