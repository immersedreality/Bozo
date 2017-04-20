
import UIKit

class HeresYoGameViewController: UIViewController {
    
    let manager = APIManager.singleton
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    var matchedGames: [Game] = []
    var gameIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        gameImageView.alpha = 0
        showGame()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func notThisButtonTapped(_ sender: UIButton) {
        gameIndex += 1
        if gameIndex >= matchedGames.count {
            gameIndex = 0
        }
        showGame()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func showGame() {
        gameImageView.alpha = 0
        
        manager.getImageAt(url: matchedGames[gameIndex].imageURL) { (image) in
            DispatchQueue.main.async {
                 self.gameImageView.image = image
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.gameImageView.alpha = 1
                }, completion: nil)
            }
        }
        gameTitleLabel.text = matchedGames[gameIndex].title
    }
}
