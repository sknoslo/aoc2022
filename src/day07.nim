import
  std/tables,
  std/strutils,
  aoc2022pkg/benchmark,
  aoc2022pkg/utils



type
  NodeType = enum
    fFile,
    fDir
  FileNode = ref object
    parent: FileNode
    size: int
    name: string
    case kind: NodeType
    of fFile:
      discard
    of fDir:
      nodes: Table[string, FileNode]


proc `$`(fileNode: FileNode): string =
  case fileNode.kind:
    of fFile:
      $fileNode.size & " " & fileNode.name
    of fDir:
      "dir " & fileNode.name

proc buildFileTree(input: seq[string]): FileNode =
  var
    lineno = 0
    root = FileNode(parent: nil, kind: fDir, size: -1, name: "/", nodes: initTable[string, FileNode]())
    curr = root
  while lineno < input.len:
    let line = input[lineno].split
    case line[1]:
      of "cd":
        case line[2]:
          of "/":
            curr = root
          of "..":
            curr = curr.parent
          else:
            curr = curr.nodes[line[2]]
      of "ls":
        while lineno+1 < input.len and not input[lineno+1].startsWith("$"):
          inc(lineno)
          let output = input[lineno].split
          if output[0] == "dir":
            curr.nodes[output[1]] = FileNode(parent: curr, kind: fDir, size: -1, name: output[1], nodes: initTable[string, FileNode]())
          else:
            curr.nodes[output[1]] = FileNode(parent: curr, kind: fFile, size: parseInt(output[0]), name: output[1])
      else:
        discard
    inc(lineno)
  root

proc partOne(root: FileNode): string =
  var sum = 0

  proc traverse(node: FileNode): int =
    case node.kind:
      of fFile:
        return node.size
      of fDir:
        var size = 0
        for n in node.nodes.values:
          size += traverse(n)
        if size < 100_000:
          sum += size
        node.size = size
        return size

  discard traverse(root)
  $sum

# requires partOne to be executed first
proc partTwo(root: FileNode): string =
  let
    current_free = 70_000_000 - root.size
    space_needed = 30_000_000 - current_free
  var curr_best = 70_000_000

  proc traverse(node: FileNode) =
    if node.size > space_needed and node.size < curr_best:
      curr_best = node.size
    if node.kind == fDir:
      for n in node.nodes.values:
        traverse(n)

  traverse(root)

  $curr_best

when isMainModule:
  echo "### DAY 07 ###"

  let input = stdin.readInput

  echo "### INPUT ###"
  echo input
  echo "### END ###"

  bench(partOne(parsed), partTwo(parsed)):
    let parsed = buildFileTree(input.strip.splitLines)

