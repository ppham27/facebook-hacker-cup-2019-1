enum Vote {
    case Amy
    case Betty
}

// Strategy is to reduce the height of the random walk until it is at most K.
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
    let (totalCost, _) = bettyVotes.reversed().reduce(
      (totalCost: 0, maxScore: -N),
      { (state: (totalCost: Int, maxScore: Int), bettyVote: (offset: Int, score: Int)) in
          // Reset when a new peak is found. Flips no longer apply.
          let maxScore = max(bettyVote.score, state.maxScore)
          // Flip as soon as Amy loses. We're changing a +1 to a -1 so minus 2.
          return maxScore - bettyVote.score == K ?
            ((state.totalCost + cost[bettyVote.offset]) % mod, maxScore - 2) :
            (state.totalCost, maxScore)
      })
    return totalCost
}

let T = Int(readLine()!)!
for t in 1...T {
    let args = readLine()!.split(separator: " ").compactMap { Int($0)! }
    let (N, K) = (args[0], args[1])
    let votes = readLine()!.map { $0 == "A" ? Vote.Amy : Vote.Betty }
    print("Case #\(t): \(payMinimally(N: N, K: K, votes: votes))")
}
