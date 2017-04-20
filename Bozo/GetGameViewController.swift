
import UIKit

class GetGameViewController: UIViewController {
    
    let manager = APIManager.singleton
    let queryManager = QueryManager()
    var matchedGames: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if manager.gameCollection.isEmpty {
            manager.getGames()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        matchedGames = manager.gameCollection
    }
    
    @IBAction func playerCountSelected(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            queryManager.playerCount = 1
        case 1:
            queryManager.playerCount = 2
        case 2:
            queryManager.playerCount = 3
        case 3:
            queryManager.playerCount = 4
        case 4:
            queryManager.playerCount = 5
        case 5:
            queryManager.playerCount = 6
        case 6:
            queryManager.playerCount = 7
        case 7:
            queryManager.playerCount = 8
        default:
            return
        }
    }
    
    @IBAction func gameLengthSelected(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            queryManager.gameLength = 30
        case 1:
            queryManager.gameLength = 60
        case 2:
            queryManager.gameLength = 90
        case 3:
            queryManager.gameLength = 120
        case 4:
            queryManager.gameLength = 150
        case 5:
            queryManager.gameLength = 180
        default:
            return
        }
    }
    
    @IBAction func complexitySelected(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            queryManager.complexity = .light
        case 1:
            queryManager.complexity = .mediumLight
        case 2:
            queryManager.complexity = .medium
        case 3:
            queryManager.complexity = .mediumHeavy
        case 4:
            queryManager.complexity = .heavy
        default:
            return
        }
    }

    @IBAction func minRatingSelected(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            queryManager.minRating = nil
        case 1:
            queryManager.minRating = 7
        case 2:
            queryManager.minRating = 8
        case 3:
            queryManager.minRating = 9
        case 4:
            queryManager.minRating = 10
        default:
            return
        }
    }
    
    @IBAction func maxPlaysSelected(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            queryManager.maxPlays = 0
        case 1:
            queryManager.maxPlays = 1
        case 2:
            queryManager.maxPlays = 5
        case 3:
            queryManager.maxPlays = 10
        case 4:
            queryManager.maxPlays = nil
        default:
            return
        }
    }
    
    @IBAction func bestRankedSelected(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        switch index {
        case 0:
            queryManager.bestRanked = true
        case 1:
            queryManager.bestRanked = false
        default:
            return
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getGameTapped(_ sender: UIButton) {
        matchedGames = queryManager.filterGames(games: matchedGames)
        
        if matchedGames.count == 0 {
            presentNoGamesAlert()
        }
        else {
            performSegue(withIdentifier: "toHeresYoGameVC", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHeresYoGameVC" {
            let destination = segue.destination as! HeresYoGameViewController
            destination.matchedGames = self.matchedGames
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func presentNoGamesAlert() {
        let noGamesAlert = UIAlertController(title: "No games in your collection match the search criteria.", message: nil, preferredStyle: .alert)
        let noGamesAction = UIAlertAction(title: "Let me try again.", style: .default) { (_) in
            self.matchedGames = self.manager.gameCollection
        }
        noGamesAlert.addAction(noGamesAction)
        present(noGamesAlert, animated: true, completion: nil)
    }
}
