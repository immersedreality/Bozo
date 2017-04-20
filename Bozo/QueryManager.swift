
import Foundation
import GameKit

final class QueryManager {
    
    let manager = APIManager.singleton
    
    var playerCount: Int? = nil
    var gameLength: Int? = nil
    var complexity: Complexity? = nil
    var minRating: Int? = nil
    var maxPlays: Int? = nil
    var bestRanked: Bool = false
    
    func filterGames(games: [Game]) -> [Game] {
        var filteredGames = games
        
        if gameLength != nil {
            if gameLength! < 180 {
                let lengthRange = (gameLength! - 15)...(gameLength! + 15)
                filteredGames = filteredGames.filter({ (game) -> Bool in
                    return lengthRange.contains(game.minimumPlayTime) || lengthRange.contains(game.maximumPlayTime)
                })
            }
            if gameLength! == 180 {
                filteredGames = filteredGames.filter({ (game) -> Bool in
                    return game.minimumPlayTime >= 180 || game.maximumPlayTime >= 180
                })
            }
        }
        
        if minRating != nil {
            filteredGames = filteredGames.filter({ (game) -> Bool in
                return game.userRating! >= minRating!
            })
        }
        
        if maxPlays != nil {
            filteredGames = filteredGames.filter({ (game) -> Bool in
                return game.plays <= maxPlays!
            })
        }
        
        manager.getGameDetails(for: filteredGames) { 
            if self.complexity != nil {
                filteredGames = filteredGames.filter({ (game) -> Bool in
                    return game.complexity == self.complexity!
                })
            }
            
            if self.playerCount != nil {
                if self.playerCount! < 8 {
                    filteredGames = filteredGames.filter({ (game) -> Bool in
                        return game.suggestedPlayerCounts!.contains(self.playerCount!)
                    })
                }
                if self.playerCount! == 8 {
                    filteredGames = filteredGames.filter({ (game) -> Bool in
                        return game.suggestedPlayerCounts!.last! >= 8
                    })
                }
            }

        }
        
        if bestRanked == true {
            filteredGames.sort { $0.geekRating > $1.geekRating}
        }
        
        if bestRanked == false {
            filteredGames = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: filteredGames) as! [Game]
        }
        
        return filteredGames
    }
    
}
