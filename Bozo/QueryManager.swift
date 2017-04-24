
import Foundation
import GameKit

final class QueryManager {
    
    let manager = APIManager.singleton
    
    var playerCount: Int? = nil
    var gameLength: Int? = nil
    var minRating: Int? = nil
    var maxPlays: Int? = nil
    var bestRanked: Bool = false
    
    func filterGames(games: [Game], completion: @escaping ([Game]) -> ()) {
        var filteredGames = games
        
        if let playerCount = playerCount {
            if playerCount < 8 {
                filteredGames = filteredGames.filter({ (game) -> Bool in
                    return playerCount >= game.minPlayerCount && playerCount <= game.maxPlayerCount
                })
            }
            if playerCount == 8 {
                filteredGames = filteredGames.filter({ (game) -> Bool in
                    return game.maxPlayerCount >= 8
                })
            }
        }
        
        if let gameLength = gameLength {
            if gameLength < 180 {
                let lengthRange = (gameLength - 15)...(gameLength + 15)
                filteredGames = filteredGames.filter({ (game) -> Bool in
                    if game.minimumPlayTime == game.maximumPlayTime {
                        return lengthRange.contains(game.maximumPlayTime)
                    }
                    else {
                        var calculatedPlayTime = game.minimumPlayTime * playerCount!
                        if calculatedPlayTime > game.maximumPlayTime {
                            calculatedPlayTime = game.maximumPlayTime
                        }
                        return lengthRange.contains(calculatedPlayTime)
                    }
                })
            }
            if gameLength == 180 {
                filteredGames = filteredGames.filter({ (game) -> Bool in
                    return game.maximumPlayTime >= 180
                })
            }
        }
        
        if let minRating = minRating {
            filteredGames = filteredGames.filter({ (game) -> Bool in
                if let rating = game.userRating {
                    return rating >= minRating
                }
                return false
            })
        }
        
        if maxPlays != nil {
            filteredGames = filteredGames.filter({ (game) -> Bool in
                return game.plays <= maxPlays!
            })
        }
        
        if self.bestRanked == true {
            filteredGames.sort { $0.geekRating > $1.geekRating}
            completion(filteredGames)
        }
        
        if self.bestRanked == false {
            filteredGames = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: filteredGames) as! [Game]
            completion(filteredGames)
        }
    }
}
