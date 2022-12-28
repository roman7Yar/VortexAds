//
//  BlackVC.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 11.12.2022.
//

import UIKit


class GameVC: UIViewController, AlertViewControllerDelegate {
        
    var backgroundColor = UIColor()
    let yellowViewSize = 50.0
    
    var volumeImageView = VolumeImageView()
    
    var yellowView: UIView = {
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        yellowView.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        yellowView.layer.cornerRadius = 25
        return yellowView
    }()
    
    lazy var countLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.textColor = .white
        countLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        countLabel.text  = "Count: \(circlesCount)"
        countLabel.textAlignment = .center
        return countLabel
    }()
    
    var timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.textColor = .white
        timerLabel.widthAnchor.constraint(equalToConstant: 62).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        timerLabel.textAlignment = .center
        return timerLabel
    }()
    
    var circlesCount = 0
    let goal = 10
    var gameStartedTime = TimeInterval()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            
        }
        
        createBackButton()
                
        view.backgroundColor = backgroundColor
        
        
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 5
        
        stackView.addArrangedSubview(timerLabel)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(volumeImageView.volumeImage)
        
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        
        view.addSubview(yellowView)
                
        countDownTimer()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.gameStartedTime = Date().timeIntervalSinceReferenceDate
            self.updateTimerLabel()
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(changeVol), name: Notification.Name("changeVolume"), object: nil)
        
    }
   
    @objc func changeVol(_ notification: NSNotification) {
        guard let name = notification.object as? Bool else {
            print("not Bool")
            return
        }
        volumeImageView.volumeImage.image = name ? volumeImageView.volumeOn : volumeImageView.volumeOff
    }

    
    func updateTimerLabel() {
        var count = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            self.timerLabel.text = "\(String(format: "%.1f",(count)))s"
            count += 0.1
            if self.circlesCount == self.goal {
                count = 0
                Timer.invalidate()
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!.location(in: self.view)
        
        
        if yellowView.frame.contains(touch) {
            
            circlesCount += 1
            moveYellowView()
            
            if circlesCount == goal {
                showResult()
            }
        }
        
        countLabel.text = "Count: \(circlesCount)"

    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        moveYellowView()
        
    }
    
    
    func showResult() {
                
        let gameEndedTime = Date().timeIntervalSinceReferenceDate
        let time = gameEndedTime - gameStartedTime
      
        var result = "\n\nYour result: \(String(format: "%.1f",(time))) seconds\n"
        
        let bestResult = UserDefaultsManager.shared.getScore()
        if bestResult == 0 {
            UserDefaultsManager.shared.setScore(value: time)
        } else if bestResult > time {
            UserDefaultsManager.shared.setScore(value: time)
        }
        
        result += "\nBest result: \(String(format: "%.1f",(bestResult))) seconds"
        
        let vc = PopUpViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)

        vc.button.setTitle("Try again", for: .normal)
        
        switch time {
        case ..<6:
            MusicManager.shared.playSound(with: Sound.forGood.id)
            vc.popUpView.backgroundColor = .green
            result = "YOU ARE FAST 🙂" + result
        case 6...15:
            MusicManager.shared.playSound(with: Sound.forNorm.id)
            vc.popUpView.backgroundColor = .yellow
            result = "YOU ARE JUST FINE" + result
        default:
            MusicManager.shared.playSound(with: Sound.forBad.id)
            vc.popUpView.backgroundColor = .red
            result = "YOU ARE SO SLOW 😦" + result
        }
        
        vc.delegate = self
        vc.messageLabel.text = result
        
    }
    
    func resetGame() {
        MusicManager.shared.playSound(with: Sound.toStart.id)
        
        countDownTimer()
        circlesCount = 0
        countLabel.text = "Count: \(self.circlesCount)"
        timerLabel.text = "0.0s"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.updateTimerLabel()
            self.gameStartedTime = Date().timeIntervalSinceReferenceDate
        }
    }
    
    func createBackButton() {
        let button = UIButton(frame: CGRect(x: 10, y: 50, width: 60, height: 35))
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true

    }
    
    @objc func backButtonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
        MusicManager.shared.playSound(with: Sound.toDissmiss.id)
//        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func moveYellowView() {
        
        MusicManager.shared.playSound(with: Sound.toMoveView.id)
        
        let minX = view.safeAreaLayoutGuide.layoutFrame.minX
        let minY = view.safeAreaLayoutGuide.layoutFrame.minY

        let maxX = view.safeAreaLayoutGuide.layoutFrame.maxX - yellowViewSize
        let maxY = view.safeAreaLayoutGuide.layoutFrame.maxY - (yellowViewSize + 20)

        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)

        yellowView.frame.origin.x = randomX
        yellowView.frame.origin.y = randomY
        
    }
    
    func countDownTimer() {
        
        var count = 3
       
        let blackView = UIView()
        blackView.frame = self.view.frame
        blackView.backgroundColor = self.backgroundColor
        view.addSubview(blackView)
        
        let label = UILabel()
        label.frame.size = CGSize(width: 100, height: 100)
        label.center = blackView.center
        label.font = .systemFont(ofSize: 70)
        label.text = "3"
        label.textAlignment = .center
        label.textColor = .white
        blackView.addSubview(label)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            count -= 1
            label.text = "\(count)"
            
            if count == 0 {
                Timer.invalidate()
                blackView.removeFromSuperview()
            }
        }

        
    }

    deinit {
        print("game deinited")
    }
    
}
