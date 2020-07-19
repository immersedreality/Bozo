
import Foundation

struct Game {
    
    let id: String
    let title: String
    let yearPublished: String
    let imageURL: String
    let userRating: Int?
    let minimumPlayTime: Int
    let maximumPlayTime: Int
    let minPlayerCount: Int
    let maxPlayerCount: Int
    let geekRating: Double
    let plays: Int

    init(
        id: String,
        title: String,
        yearPublished: String,
        imageURL: String,
        userRating: Int?,
        minimumPlayTime: Int,
        maximumPlayTime: Int,
        geekRating: Double,
        plays: Int,
        suggestedPlayerCounts: [Int]?,
        minPlayerCount: Int,
        maxPlayerCount: Int
    ) {
        self.id = id
        self.title = title
        self.yearPublished = yearPublished
        self.imageURL = imageURL
        self.userRating = userRating
        self.minimumPlayTime = minimumPlayTime
        self.maximumPlayTime = maximumPlayTime
        self.geekRating = geekRating
        self.plays = plays
        self.minPlayerCount = minPlayerCount
        self.maxPlayerCount = maxPlayerCount
    }

}
