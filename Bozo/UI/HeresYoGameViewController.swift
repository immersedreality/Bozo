
import UIKit

class HeresYoGameViewController: UIViewController {
    
    let manager = APIManager.singleton
    let activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    var matchedGames: [Game] = []
    var gameIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        configureActivityIndicatorView()
        gameImageView.alpha = 0
        gameTitleLabel.alpha = 0
        showGame()
    }

    private func configureActivityIndicatorView() {
        activityIndicator.alpha = 1.0
        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.color = .white
        view.addSubview(activityIndicator)
    }

    private func showGame() {
        activityIndicator.alpha = 1.0
        activityIndicator.startAnimating()
        gameImageView.alpha = 0
        gameTitleLabel.alpha = 0

        manager.getImageAt(url: matchedGames[gameIndex].imageURL) { (image) in
            DispatchQueue.main.async {
                self.activityIndicator.alpha = 0.0
                self.activityIndicator.stopAnimating()
                self.gameImageView.image = image
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    self.gameImageView.alpha = 1
                    self.gameTitleLabel.alpha = 1
                }, completion: nil)
            }
        }
        gameTitleLabel.text = matchedGames[gameIndex].title
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

}
