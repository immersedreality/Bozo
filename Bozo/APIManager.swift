
import Foundation
import UIKit

final class APIManager: NSObject, XMLParserDelegate {
    static let singleton = APIManager()
    
    var username: String?
    let baseURL = "https://www.boardgamegeek.com/xmlapi2/"
    var gameCollection: [Game] = []
    
    var currentElement: String = ""
    var currentPlayerCount: Int = 0
    var currentBestVotes: Int = 0
    var currentRecommendedVotes: Int = 0
    var currentNotRecommendedVotes: Int = 0
    
    var ids: [String] = []
    var titles: [String] = []
    var yearsPublished: [String] = []
    var imageURLs: [String] = []
    var userRatings: [Int?] = []
    var minimumPlayTimes: [Int] = []
    var maximumPlayTimes: [Int] = []
    var geekRatings: [Double] = []
    var plays: [Int] = []
    
    var suggestedPlayerCounts: [Int] = []
    var complexity: Complexity = .medium
    
    var currentlyGettingGames = false
    var currentlyGettingDetails = false
    
    override private init(){}
    
    func getGames() {
        gameCollection.removeAll()
        
        guard let username = username else { return }
        let urlString = URL(string: baseURL + "collection?username=\(username)&own=1&stats=1")
        guard let url = urlString else { return }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let responseStatus = response as? HTTPURLResponse else { return }
            print(responseStatus.statusCode)
            switch responseStatus.statusCode {
            case 200:
                guard let responseData = data else { return }
                self.currentlyGettingGames = true
                let xmlParser = XMLParser(data: responseData)
                xmlParser.delegate = self
                xmlParser.parse()
            default:
                break
            }
        }
        dataTask.resume()
    }
    
    func getGameDetails(for game: Game, completion: @escaping () -> ()) {
        let urlString = URL(string: baseURL + "thing?id=\(game.id)&stats=1")
        guard let url = urlString else { return }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let responseData = data else { return }
            self.currentlyGettingDetails = true
            let xmlParser = XMLParser(data: responseData)
            xmlParser.delegate = self
            xmlParser.parse()
            completion()
        }
        dataTask.resume()
        
    }

    
    func getGameDetails(for games: [Game], completion: @escaping () -> ()) {
        for game in games {
            let urlString = URL(string: baseURL + "thing?id=\(game.id)&stats=1")
            guard let url = urlString else { return }
            let urlRequest = URLRequest(url: url)
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                guard let responseData = data else { return }
                self.currentlyGettingDetails = true
                let xmlParser = XMLParser(data: responseData)
                xmlParser.delegate = self
                xmlParser.parse()
            }
            dataTask.resume()
        }
        completion()
    }
    
    func getImageAt(url: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: "https:" + url) else { return }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let responseData = data else { return }
            guard let gameImage = UIImage(data: responseData) else { return }
            completion(gameImage)
        }
        dataTask.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case "item":
            if currentlyGettingGames {
                if let id = attributeDict["objectid"] {
                    ids.append(id)
                }
            }
        case "rating":
            if currentlyGettingGames {
                if let rating = attributeDict["value"] {
                    if rating == "N/A" {
                        userRatings.append(nil)
                    }
                    if let rating = Int(rating) {
                        userRatings.append(rating)
                    }
                }
            }
        case "stats":
            if currentlyGettingGames {
                if let minimumPlayTime = attributeDict["minplaytime"] {
                    if let minimumPlayTime = Int(minimumPlayTime) {
                        minimumPlayTimes.append(minimumPlayTime)
                    }
                }
                if let maximumPlayTime = attributeDict["maxplaytime"] {
                    if let maximumPlayTime = Int(maximumPlayTime) {
                        maximumPlayTimes.append(maximumPlayTime)
                    }
                }
            }
        case "bayesaverage":
            if currentlyGettingGames {
                if let geekRating = attributeDict["value"] {
                    if let geekRating = Double(geekRating) {
                        geekRatings.append(geekRating)
                    }
                }
            }
        case "averageweight":
            if currentlyGettingDetails {
                if let averageWeight = attributeDict["value"] {
                    if let averageWeight = Double(averageWeight) {
                        switch averageWeight {
                        case 1.0...1.74:
                            complexity = .light
                        case 1.75...2.49:
                            complexity = .mediumLight
                        case 2.5...3.24:
                            complexity = .medium
                        case 3.25...3.99:
                            complexity = .mediumHeavy
                        case 4.0...5.0:
                            complexity = .heavy
                        default:
                            return
                        }
                    }
                }
            }

        case "results":
            if currentlyGettingDetails {
                if let currentPlayerCountString = attributeDict["numplayers"] {
                    if let currentPlayerCount = Int(currentPlayerCountString) {
                        if (currentBestVotes + currentRecommendedVotes) > currentNotRecommendedVotes {
                            suggestedPlayerCounts.append(currentPlayerCount)
                        }
                    }
                }
            }
        case "result":
            if currentlyGettingDetails {
                if attributeDict["value"] == "Best" {
                    let currentBestVotesString = attributeDict["numvotes"] ?? "N/A"
                    currentBestVotes = Int(currentBestVotesString) ?? 0
                }
                if attributeDict["value"] == "Recommended" {
                    let currentRecommendedVotesString = attributeDict["numvotes"] ?? "N/A"
                    currentRecommendedVotes = Int(currentRecommendedVotesString) ?? 0
                }
                if attributeDict["value"] == "Not Recommended" {
                    let currentNotRecommendedVotesString = attributeDict["numvotes"] ?? "N/A"
                    currentNotRecommendedVotes = Int(currentNotRecommendedVotesString) ?? 0
                }
            }
        default:
            currentElement = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentElement += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "name":
            if currentlyGettingGames {
                titles.append(currentElement)
            }
        case "yearpublished":
            if currentlyGettingGames {
                yearsPublished.append(currentElement)
            }
        case "image":
            if currentlyGettingGames {
                imageURLs.append(currentElement)
            }
        case "numplays":
            if currentlyGettingGames {
                if let numPlays = Int(currentElement) {
                    plays.append(numPlays)
                }
            }
        default:
            return
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if currentlyGettingGames {
            currentlyGettingGames = false
            
            for (index, id) in ids.enumerated() {
                
                let title = titles[index]
                let yearPublished = yearsPublished[index]
                let imageURL = imageURLs[index]
                let userRating = userRatings[index]
                let minimumPlayTime = minimumPlayTimes[index]
                let maximumPlayTime = maximumPlayTimes[index]
                let geekRating = geekRatings[index]
                let numPlays = plays[index]
                
                let newGame = Game(id: id, title: title, yearPublished: yearPublished, imageURL: imageURL, userRating: userRating, minimumPlayTime: minimumPlayTime, maximumPlayTime: maximumPlayTime, geekRating: geekRating, plays: numPlays, suggestedPlayerCounts: nil, complexity: nil)
                gameCollection.append(newGame)
            }
        }

        if currentlyGettingDetails {
            currentlyGettingDetails = false
        }
    }
}
