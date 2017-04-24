
import UIKit

class GetGameViewController: UIViewController {
    
    @IBOutlet weak var playerCountSegmentedControl: UISegmentedControl!
    @IBOutlet weak var gameLengthSegmentedControl: UISegmentedControl!
    @IBOutlet weak var minRatingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var maxPlaysSegmentedControl: UISegmentedControl!
    @IBOutlet weak var bestRankedSegmentedControl: UISegmentedControl!
    
    let manager = APIManager.singleton
    let queryManager = QueryManager()
    var matchedGames: [Game] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if manager.gameCollection.isEmpty {
            manager.getGames(completion: {
                if self.manager.gameCollection.isEmpty {
                    self.presentInternetErrorAlert()
                }
            })
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
        guard playerCountSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment && gameLengthSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment && minRatingSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment && maxPlaysSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment && bestRankedSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment else {
            presentNotAllSelectedAlert()
            return
        }
        
        queryManager.filterGames(games: matchedGames, completion: { (filteredGames) in
            self.matchedGames = filteredGames
            
            if self.matchedGames.count == 0 {
                self.presentNoGamesAlert()
            }
            else {
                self.performSegue(withIdentifier: "toHeresYoGameVC", sender: nil)
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHeresYoGameVC" {
            let destination = segue.destination as! HeresYoGameViewController
            destination.matchedGames = self.matchedGames
        }
    }
    
    func presentNoGamesAlert() {
        let noGamesAlert = UIAlertController(title: "No games in your collection match the search criteria.", message: nil, preferredStyle: .alert)
        let noGamesAction = UIAlertAction(title: "Try again", style: .default) { (_) in
            self.matchedGames = self.manager.gameCollection
        }
        noGamesAlert.addAction(noGamesAction)
        present(noGamesAlert, animated: true, completion: nil)
    }
    
    func presentNotAllSelectedAlert() {
        let notAllSelectedAlert = UIAlertController(title: "Please make a selection for all options.", message: nil, preferredStyle: .alert)
        let notAllSelectedAction = UIAlertAction(title: "Try again", style: .default)
        notAllSelectedAlert.addAction(notAllSelectedAction)
        present(notAllSelectedAlert, animated: true, completion: nil)
    }
    
    func presentInternetErrorAlert() {
        let internetErrorAlert = UIAlertController(title: "There was an issue getting your board game data.", message: "Please check that your username is accurate and try reloading data from the settings menu.", preferredStyle: .alert)
        let internetErrorAction = UIAlertAction(title: "Got it", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        internetErrorAlert.addAction(internetErrorAction)
        present(internetErrorAlert, animated: true, completion: nil)    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
