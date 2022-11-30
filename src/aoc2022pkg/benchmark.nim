import
  times

template bench*(p1, p2: typed) =
  block:
    let p1start = getTime()
    let p1result = p1
    echo "\nP1: " & p1Result
    let p1elapsed = getTime() - p1start
    echo "in: " & $p1elapsed
    let p2start = getTime()
    let p2result = p2
    echo "\nP2: " & p2result
    let p2elapsed = getTime() - p2start
    echo "in: " & $p2elapsed

    echo "\ntotal: " & $(p1elapsed + p2elapsed)
