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
    let myTimer = MyTimer()
    var timer = Timer()
    let goal = 3
    var gameStartedTime = TimeInterval()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBackButton()
        
        view.backgroundColor = backgroundColor
        
        
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 0
        
        stackView.addArrangedSubview(timerLabel)
        stackView.addArrangedSubview(countLabel)
        
        self.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56).isActive = true
        
        
        view.addSubview(yellowView)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)

        
        gameStartedTime = Date().timeIntervalSinceReferenceDate
        myTimer.start()
        
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
        
        myTimer.stop()
        
        let gameEndedTime = Date().timeIntervalSinceReferenceDate
        let time = gameEndedTime - gameStartedTime
        var result = "\(String(format: "%.1f",(time))) seconds \n"
        
        let vc = PopUpViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)

        vc.button.setTitle("Try again", for: .normal)
        
        switch time {
        case ..<6:
            vc.popUpView.backgroundColor = .green
            result += "YOU ARE FAST 🙂"
        case 6...15:
            vc.popUpView.backgroundColor = .yellow
            result += "YOU ARE JUST FINE"
        default:
            vc.popUpView.backgroundColor = .red
            result += "YOU ARE SO SLOW 😦"
        }
        
        vc.delegate = self
        vc.messageLabel.text = result
        
    }
    
    func resetGame() {
        
        myTimer.count = 0
        circlesCount = 0
        myTimer.start()
        countLabel.text = "Count: \(self.circlesCount)"
        
    }
    
    func createBackButton() {
        let button = UIButton(frame: CGRect(x: 10, y: 50, width: 60, height: 35))
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
    }
    
    @objc func backButtonAction(sender: UIButton!) {
//        self.dismiss(animated: true, completion: nil)
        presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        myTimer.stop()
        timer.invalidate()
    }
    
    func moveYellowView() {
        
        let minX = view.safeAreaLayoutGuide.layoutFrame.minX
        let minY = view.safeAreaLayoutGuide.layoutFrame.minY

        let maxX = view.safeAreaLayoutGuide.layoutFrame.maxX - yellowViewSize
        let maxY = view.safeAreaLayoutGuide.layoutFrame.maxY - yellowViewSize

        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)

        yellowView.frame.origin.x = randomX
        yellowView.frame.origin.y = randomY
        
    }
    
    @objc func updateTimer() {
        timerLabel.text = "\(String(format: "%.1f",(myTimer.count)))s"
    }


    deinit {
        print("game deinited")
    }
    
}
