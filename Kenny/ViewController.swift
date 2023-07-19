//
//  ViewController.swift
//  Kenny
//
//  Created by Terry Jason on 2023/7/18.
//

import UIKit

class ViewController: UIViewController {
    
    let userDefault = UserDefaults()
    
    var countDownTimer = Timer()
    
    var count = 0
    var score = 0
    var highScore = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var kenny: UIImageView!
    
    @IBOutlet weak var kennyLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var kennyTopConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAll()
    }
    
    @objc func countdown() {
        kennyMove()
        count -= 1
        setTimeLabel()
        timeUp()
    }
    
    @objc func scoreUp() {
        score += 1
        setScoreLabel()
    }
    
    func setAll() {
        setTimer()
        setNumber()
        setUI()
        setKenny()
    }
    
    func setTimer() {
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
    }
    
    func setNumber() {
        count = 30
        score = 0
        
        if let defaultScore = userDefault.value(forKey: "HighScore") as? Int {
            highScore = defaultScore
        }
    }
    
    func setTimeLabel() {
        timeLabel.text = String(count)
    }
    
    func setScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func setHighScoreLabel() {
        highScoreLabel.text = "Highscore: \(highScore)"
    }
    
    func setUI() {
        setTimeLabel()
        setScoreLabel()
        setHighScoreLabel()
    }
    
    func setKenny() {
        kenny.isUserInteractionEnabled = true
        kenny.isHidden = false
        
        let catchKenny = UITapGestureRecognizer(target: self, action: #selector(scoreUp))
        kenny.addGestureRecognizer(catchKenny)
    }
    
    func timeUp() {
        if count == 0 {
            kenny.isHidden = true
            countDownTimer.invalidate()
            changeHighScore()
            endAlert()
        }
    }
    
    func changeHighScore() {
        if score > highScore {
            highScore = score
            setHighScoreLabel()
            userDefault.setValue(highScore, forKey: "HighScore")
        }
    }
    
    func startAlert() {
        let controller = generateAlertController(title: "Catch kenny", message: "If you can?")
        let startButton = UIAlertAction(title: "始める", style: .cancel) { [self] _ in
            viewDidLoad()
        }
        
        controller.addAction(startButton)
        present(controller, animated: true)
    }
    
    func endAlert() {
        let controller = generateAlertController(title: "Time's Up", message: "Do you want to play again?")
        let okButton = UIAlertAction(title: "OK", style: .cancel) { [self] _ in
            startAlert()
        }
        
        let replayButton = UIAlertAction(title: "Replay", style: .default) { [self] _ in
            viewDidLoad()
        }
        
        controller.addAction(okButton)
        controller.addAction(replayButton)
        
        present(controller, animated: true)
    }
    
    func kennyMove() {
        UIImageView.animate(withDuration: 0.5, animations: { [self] in
            setConstraint()
            view.layoutIfNeeded()
        })
    }
    
    func setConstraint() {
        let width = (view.frame.width / 2.5)
        let height = (view.frame.height / 4.5)
        
        kennyLeftConstraint.constant = CGFloat.random(in: -width...width)
        kennyTopConstraint.constant = CGFloat.random(in: -height...height)
    }
    
    func generateAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alertController
    }
    
}

