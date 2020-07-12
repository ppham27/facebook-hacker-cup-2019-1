func makeGraph(N: Int, distances: [(X: Int, Y: Int, Z: Int)]) -> [(A: Int, B: Int, W: Int)]? {
    var distancePairs = Array(repeating: Array(repeating: Int.max / 2, count: N), count: N)
    for distance in distances {
        distancePairs[distance.X][distance.Y] = distance.Z
        distancePairs[distance.Y][distance.X] = distance.Z
    }
    for i in 0..<N { distancePairs[i][i] = 0 }
    for k in 0..<N {
        for i in 0..<N {
            for j in 0..<N {
                distancePairs[i][j] = min(
                  distancePairs[i][k] + distancePairs[k][j], distancePairs[i][j])
            }
        }
    }
    for distance in distances {
        if distancePairs[distance.X][distance.Y] != distance.Z { return nil }
    }
    return distances.map { (A: $0.X + 1, B: $0.Y + 1, W: $0.Z) }
}

let T = Int(readLine()!)!
for t in 1...T {
    let args = readLine()!.split(separator: " ").map { Int($0)! }
    let (N, M) = (args[0], args[1])
    var distances: [(X: Int, Y: Int, Z: Int)] = []
    for _ in 0..<M {
        let distanceArgs = readLine()!.split(separator: " ").map { Int($0)! }
        distances.append(
          (X: distanceArgs[0] - 1, Y: distanceArgs[1] - 1, Z: distanceArgs[2]))
        
    }
    if let graph = makeGraph(N: N, distances: distances) {
        print("Case #\(t): \(graph.count)")
        for edge in graph {
            print("\(edge.A) \(edge.B) \(edge.W)")
        }
    } else {
        print("Case #\(t): Impossible")
    }
}
