
import UIKit

class GameDetailViewController: UIViewController {
    
    let manager = APIManager.singleton
    
    var game: Game!
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var userRatingLabel: UILabel!
    @IBOutlet weak var userPlaysLabel: UILabel!
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var playTimeLabel: UILabel!
    @IBOutlet weak var complexityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameImageView.alpha = 0
        gameTitleLabel.alpha = 0
        yearLabel.alpha = 0
        userRatingLabel.alpha = 0
        userPlaysLabel.alpha = 0
        playerCountLabel.alpha = 0
        playTimeLabel.alpha = 0
        complexityLabel.alpha = 0
        
        manager.getGameDetails(for: game) { 
            DispatchQueue.main.async {
                self.game.addSuggestedPlayerCounts(self.manager.suggestedPlayerCounts)
                self.game.addComplexity(self.manager.complexity)
                self.playerCountLabel.text = "Players: \(self.game.suggestedPlayerCounts![0].description)" + " - " + self.game.suggestedPlayerCounts!.last!.description
                self.complexityLabel.text = self.game.complexity!.rawValue
            }
        }
        
        manager.getImageAt(url: game.imageURL) { (image) in
            DispatchQueue.main.async {
                self.gameImageView.image = image
                
                UIView.animate(withDuration: 0.8, animations: {
                    self.gameImageView.alpha = 1
                    self.gameTitleLabel.alpha = 1
                    self.yearLabel.alpha = 1
                    self.userRatingLabel.alpha = 1
                    self.userPlaysLabel.alpha = 1
                    self.playerCountLabel.alpha = 1
                    self.playTimeLabel.alpha = 1
                    self.complexityLabel.alpha = 1
                })
            }
        }
        
        gameTitleLabel.text = game.title
        yearLabel.text = game.yearPublished
        userRatingLabel.text = "Your rating: \(game.userRating?.description ?? "Not Rated")"
        userPlaysLabel.text = "Your plays: \(game.plays.description)"
        
        if game.minimumPlayTime == game.maximumPlayTime {
            playTimeLabel.text = "Play time: \(game.minimumPlayTime.description)"
        }
        if game.minimumPlayTime < game.maximumPlayTime {
            playTimeLabel.text = "Play time: \(game.minimumPlayTime.description)" + " - " + game.maximumPlayTime.description
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
