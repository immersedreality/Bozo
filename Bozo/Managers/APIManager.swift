
import Foundation
import UIKit

final class APIManager: NSObject, XMLParserDelegate {
    static let singleton = APIManager()
    
    let defaults = UserDefaults.standard
    
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
    var minPlayerCounts: [Int] = []
    var maxPlayerCounts: [Int] = []
    var geekRatings: [Double] = []
    var plays: [Int] = []

    var currentlyGettingGames = false
    var networkTimer = Timer()
    var networkAttemptsRemaining = 6
    
    override private init(){}
    
    func getGames(completion: @escaping ([Game]) -> ()) {
        gameCollection.removeAll()
        
        guard let username = username else { return }
        let urlString = URL(string: baseURL + "collection?username=\(username)&own=1&stats=1")
        
        guard let url = urlString else { return }
        let urlRequest = URLRequest(url: url)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard let responseStatus = response as? HTTPURLResponse else { completion([]); return }
            print(responseStatus.statusCode)
            switch responseStatus.statusCode {
            case 200:
                guard let responseData = data else { return }
                print(responseData)
                self.currentlyGettingGames = true
                let xmlParser = XMLParser(data: responseData)
                xmlParser.delegate = self
                xmlParser.parse()
                completion(self.gameCollection)
            case 202:
                DispatchQueue.main.async {
                    self.keepTrying(completion: { (games) in
                        if !games.isEmpty {
                            self.networkAttemptsRemaining = 6
                            completion(self.gameCollection)
                        }
                        else {
                            self.networkAttemptsRemaining = 6
                            completion([])
                        }
                    })
                }
            default:
                completion([])
            }
        }
        dataTask.resume()
    }
    
    func keepTrying(completion: @escaping ([Game]) -> ()) {
        if networkAttemptsRemaining > 0 {
            networkTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (timer) in
                self.gameCollection.removeAll()
                
                guard let username = self.username else { return }
                let urlString = URL(string: self.baseURL + "collection?username=\(username)&own=1&stats=1")
                
                guard let url = urlString else { return }
                let urlRequest = URLRequest(url: url)
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
                    guard let responseStatus = response as? HTTPURLResponse else { self.networkAttemptsRemaining -= 1; return }
                    print(responseStatus.statusCode)
                    switch responseStatus.statusCode {
                    case 200:
                        guard let responseData = data else { return }
                        print(responseData)
                        self.currentlyGettingGames = true
                        let xmlParser = XMLParser(data: responseData)
                        xmlParser.delegate = self
                        xmlParser.parse()
                        completion(self.gameCollection)
                    default:
                        self.networkAttemptsRemaining -= 1
                        DispatchQueue.main.async {
                            self.keepTrying(completion: { (games) in
                                if !games.isEmpty {
                                    completion(self.gameCollection)
                                }
                                else {
                                    completion([])
                                }
                            })
                        }
                    }
                }
                dataTask.resume()
            })
        }
        else {
            completion([])
        }
    }
    
    func getImageAt(url: String, completion: @escaping (UIImage) -> ()) {
        guard let url = URL(string: url) else { return }
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
            if let id = attributeDict["objectid"] {
                ids.append(id)
                
                //default values
                yearsPublished.append("(Unknown Year)")
                minimumPlayTimes.append(60)
                maximumPlayTimes.append(120)
                minPlayerCounts.append(2)
                maxPlayerCounts.append(4)
                imageURLs.append("https://cf.geekdo-images.com/images/pic1657689.jpg")
            }
        case "rating":
            if let rating = attributeDict["value"] {
                if rating == "N/A" {
                    userRatings.append(nil)
                }
                if let rating = Int(rating) {
                    userRatings.append(rating)
                }
                else if let rating = Double(rating) {
                    let roundedRating = Int(rating.rounded())
                    userRatings.append(roundedRating)
                }
            }
        case "stats":
            if let minimumPlayTime = attributeDict["minplaytime"] {
                if let minimumPlayTime = Int(minimumPlayTime) {
                    minimumPlayTimes.removeLast()
                    minimumPlayTimes.append(minimumPlayTime)
                }
            }
            
            if let maximumPlayTime = attributeDict["maxplaytime"] {
                if let maximumPlayTime = Int(maximumPlayTime) {
                    maximumPlayTimes.removeLast()
                    maximumPlayTimes.append(maximumPlayTime)
                }
            }
            
            if let minPlayerCount = attributeDict["minplayers"] {
                if let minPlayerCount = Int(minPlayerCount) {
                    minPlayerCounts.removeLast()
                    minPlayerCounts.append(minPlayerCount)
                }
            }
            if let maxPlayerCount = attributeDict["maxplayers"] {
                if let maxPlayerCount = Int(maxPlayerCount) {
                    maxPlayerCounts.removeLast()
                    maxPlayerCounts.append(maxPlayerCount)
                }
            }
        case "bayesaverage":
            if let geekRating = attributeDict["value"] {
                if let geekRating = Double(geekRating) {
                    geekRatings.append(geekRating)
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
            titles.append(currentElement)

        case "yearpublished":
            yearsPublished.removeLast()
            yearsPublished.append("(\(currentElement))")
            
        case "image":
            imageURLs.removeLast()
            imageURLs.append(currentElement)
            
        case "numplays":
            if let numPlays = Int(currentElement) {
                plays.append(numPlays)
            }
        default:
            return
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for (index, id) in ids.enumerated() {
            
            let title = titles[index]
            let yearPublished = yearsPublished[index]
            let imageURL = imageURLs[index]
            let userRating = userRatings[index]
            let minimumPlayTime = minimumPlayTimes[index]
            let maximumPlayTime = maximumPlayTimes[index]
            let geekRating = geekRatings[index]
            let numPlays = plays[index]
            let minPlayerCount = minPlayerCounts[index]
            let maxPlayerCount = maxPlayerCounts[index]
            
            let newGame = Game(id: id, title: title, yearPublished: yearPublished, imageURL: imageURL, userRating: userRating, minimumPlayTime: minimumPlayTime, maximumPlayTime: maximumPlayTime, geekRating: geekRating, plays: numPlays, suggestedPlayerCounts: nil, minPlayerCount: minPlayerCount, maxPlayerCount: maxPlayerCount)
            gameCollection.append(newGame)
        }
        
        ids.removeAll()
        titles.removeAll()
        yearsPublished.removeAll()
        imageURLs.removeAll()
        userRatings.removeAll()
        minimumPlayTimes.removeAll()
        maximumPlayTimes.removeAll()
        geekRatings.removeAll()
        plays.removeAll()
        minPlayerCounts.removeAll()
        maxPlayerCounts.removeAll()
    }
}
