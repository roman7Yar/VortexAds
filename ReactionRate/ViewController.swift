//
//  ViewController.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 06.12.2022.
//

import UIKit


class MyTimer {
    var timer: Timer?
    var count = 0.0
    
    func start() -> Void {
        self.timer = Timer.scheduledTimer(withTimeInterval:0.1, repeats: true) {_ in
            self.count = self.count + 0.1
           }
    }
    func stop() -> Void {
        self.timer?.invalidate()
        self.timer = nil
    }
}

class BlackVC: UIViewController {

    
    var yellowView = UIView()
    var countLabel = UILabel()
    var timerLabel = UILabel()
    var circlesCount = 0
    let myTimer = MyTimer()
    let goal = 10
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        countLabel.textColor = .white
        countLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        countLabel.text  = "Count: \(circlesCount)"
        countLabel.textAlignment = .center
        
        timerLabel.textColor = .white
        timerLabel.widthAnchor.constraint(equalToConstant: 62).isActive = true
        timerLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        timerLabel.textAlignment = .center
        
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing = 0

        stackView.addArrangedSubview(timerLabel)
        stackView.addArrangedSubview(countLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(stackView)
        
        let horizontalConstraint = NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1, constant: -10)
        let verticalConstraint = NSLayoutConstraint(item: stackView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 50)
        
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint])

        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.timerLabel.text = "\(String(format: "%.1f",(self.myTimer.count)))sec"
        }
        
        yellowView.backgroundColor = .yellow
        yellowView.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        yellowView.layer.cornerRadius = 25

        view.addSubview(yellowView)
//        view.addSubview(countLabel)
//        view.addSubview(timerLabel)

        myTimer.start()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        let x = yellowView.frame.origin.x
        let y = yellowView.frame.origin.y
        let viewDiametr = yellowView.frame.height
        
        let maxX = view.frame.maxX - 50
        let maxY = view.frame.maxY - 150
        
        let randomX = CGFloat.random(in: 50...maxX)
        let randomY = CGFloat.random(in: 150...maxY)
        
        let touch = touches.first!.location(in: self.view)
        
        if touch.x > x && touch.x < x + viewDiametr && touch.y > y && touch.y < y + viewDiametr {
            
            circlesCount += 1
            
            yellowView.frame.origin.x = randomX
            yellowView.frame.origin.y = randomY
            
            if circlesCount == goal {
                showResult()
            }
            
        }
    
        countLabel.text = "Count: \(circlesCount)"

    }
    
    func showResult() {
        
        myTimer.stop()
        
        let result = "\(String(format: "%.1f",(myTimer.count))) seconds"
        
        let vc = UIAlertController(title: "Your result is", message: result , preferredStyle: .alert)
        
        let tryAgain = UIAlertAction(title: "Try again", style: .default) {_ in
            self.myTimer.count = 0
            self.circlesCount = 0
            self.myTimer.start()
        }
        
        vc.addAction(tryAgain)
        present(vc, animated: true)
        
    }
    
    func createButton(x: Int, y: Int, title: String, color: UIColor) {
            let button = UIButton(frame: CGRect(x: x, y: y, width: 60, height: 35))
            button.setTitle(title, for: .normal)
            button.backgroundColor = color
            button.layer.cornerRadius = 10
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

            self.view.addSubview(button)
        }
        
        @objc func buttonAction(sender: UIButton!) {
            self.dismiss(animated: true, completion: nil)
        }
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = BlackVC()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
        
    }

}




