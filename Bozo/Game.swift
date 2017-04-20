
import Foundation

final class Game {
    let id: String
    let title: String
    let yearPublished: String
    let imageURL: String
    let userRating: Int?
    let minimumPlayTime: Int
    let maximumPlayTime: Int
    let geekRating: Double
    let plays: Int
    var suggestedPlayerCounts: [Int]?
    var complexity: Complexity?
    
    init(id: String, title: String, yearPublished: String, imageURL: String, userRating: Int?, minimumPlayTime: Int, maximumPlayTime: Int, geekRating: Double, plays: Int, suggestedPlayerCounts: [Int]?, complexity: Complexity?) {
        self.id = id
        self.title = title
        self.yearPublished = yearPublished
        self.imageURL = imageURL
        self.userRating = userRating
        self.minimumPlayTime = minimumPlayTime
        self.maximumPlayTime = maximumPlayTime
        self.geekRating = geekRating
        self.plays = plays
        self.suggestedPlayerCounts = suggestedPlayerCounts
        self.complexity = complexity
    }
    
    func addSuggestedPlayerCounts(_ suggestedPlayerCounts: [Int]) {
        self.suggestedPlayerCounts = suggestedPlayerCounts
    }
    
    func addComplexity(_ complexity: Complexity) {
        self.complexity = complexity
    }
}

enum Complexity: String {
    case light = "Light", mediumLight = "Medium-Light", medium = "Medium", mediumHeavy = "Medium-Heavy", heavy = "Heavy"
}
