import
  std/math,
  std/sugar,
  std/deques,
  std/sequtils,
  std/strutils,
  std/algorithm,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils

type
  Monkey = ref object
    label: string
    inspections: int
    items: Deque[int]
    op: tuple[op, by: string]
    test: int
    if_true: int
    if_false: int

proc initMonkey(label: string, items: seq[int], op: tuple[op, by: string], test: int, if_true, if_false: int): Monkey =
  Monkey(label: label, inspections: 0, items: items.toDeque, op: op, test: test, if_true: if_true, if_false: if_false)

proc parseMonkey(text: string): Monkey =
  let
    lines = text.splitLines
    op_parts = lines[2].split(" ")
    label = lines[0]
    items = lines[1].strip.replace("Starting items: ", "").split(", ").map(parseInt)
    op = (op_parts[^2], op_parts[^1])
    test = parseInt(lines[3].split(" ")[^1])
    if_true = parseInt(lines[4].split(" ")[^1])
    if_false = parseInt(lines[5].split(" ")[^1])

  initMonkey(label, items, op, test, if_true, if_false)

proc partOne(monkeys: var seq[Monkey]): string =
  for round in 1..20:
    for monkey in monkeys:
      while monkey.items.len > 0:
        var item = monkey.items.popFirst
        let by = case monkey.op.by:
          of "old":
            item
          else:
            parseInt(monkey.op.by)
        item = case monkey.op.op:
          of "*":
            item * by
          of "+":
            item + by
          else:
            raise newException(Exception, "Ya dun goofed")

        inc(monkey.inspections)
        item = item div 3
        if item mod monkey.test == 0:
          monkeys[monkey.if_true].items.addLast(item)
        else:
          monkeys[monkey.if_false].items.addLast(item)
          
  let inspections = monkeys.map(m => m.inspections).sorted

  $(inspections[^1] * inspections[^2])

proc partTwo(monkeys: var seq[Monkey]): string =
  let mod_by = foldl(monkeys, a * b.test, 1)
  for round in 1..10_000:
    for monkey in monkeys:
      while monkey.items.len > 0:
        var item = monkey.items.popFirst
        let by = case monkey.op.by:
          of "old":
            item
          else:
            parseInt(monkey.op.by)
        item = case monkey.op.op:
          of "*":
            item * by
          of "+":
            item + by
          else:
            raise newException(Exception, "Ya dun goofed")

        inc(monkey.inspections)
        item = item mod mod_by
        if item mod monkey.test == 0:
          monkeys[monkey.if_true].items.addLast(item)
        else:
          monkeys[monkey.if_false].items.addLast(item)
          
  let inspections = monkeys.map(m => m.inspections).sorted

  $(inspections[^1] * inspections[^2])

when isMainModule:
  echo "### DAY 11 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed_one), partTwo(parsed_two)):
    var parsed_one = input.strip.split("\n\n").map(parseMonkey)
    var parsed_two = input.strip.split("\n\n").map(parseMonkey)

