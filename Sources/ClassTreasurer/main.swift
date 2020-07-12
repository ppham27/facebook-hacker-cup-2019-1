enum Vote {
    case Amy
    case Betty
}

// The general strategy is to reduce the height of the random walk.
func payMinimally(N: Int, K: Int, votes: [Vote], mod: Int = 1000000007) -> Int {
    // Get the index and how much Amy is losing by at each Betty vote.
    let bettyVotes = votes.enumerated()
      .filter { $0.element == Vote.Betty }.enumerated()
      .map { (offset: $0.element.offset, score: 2 * $0.offset - $0.element.offset) }
    let cost =
      ({ (count: Int) -> [Int] in
           var cost: [Int] = []    
           while cost.count < count { cost.append((2 * (cost.last ?? 1)) % mod) }
           return cost
       })(votes.count)
    var (totalCost, maxScore) = (0, -N)
    for bettyVote in bettyVotes.reversed() {
        // Reset when a new peak is found. Flips no longer apply.
        if bettyVote.score >= maxScore { maxScore = bettyVote.score }
        if maxScore - bettyVote.score == K {  // Flip as soon as Amy loses.
            totalCost = (totalCost + cost[bettyVote.offset]) % mod
            maxScore -= 2  // We're changing a +1 to a -1.
        }
    }
    return totalCost
}

let T = Int(readLine()!)!
for t in 1...T {
    let args = readLine()!.split(separator: " ").compactMap { Int($0)! }
    let (N, K) = (args[0], args[1])
    let votes = readLine()!.map { $0 == "A" ? Vote.Amy : Vote.Betty }
    print("Case #\(t): \(payMinimally(N: N, K: K, votes: votes))")
}
