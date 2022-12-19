//
//  DownTimerVC.swift
//  ReactionRate
//
//  Created by Roman Yarmoliuk on 14.12.2022.
//

import UIKit

class DownTimerVC: UIViewController {
   
    var backgroundColor = UIColor()
    var timer = Timer()
    
    var count = 3 {
        didSet {
            timerLabel.text = "\(count)"
            if count == 0 {
                self.timer.invalidate()
                let vc = GameVC()
                vc.backgroundColor = self.backgroundColor
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: false)
            }
        }
    }
    
    var timerLabel: UILabel = {
        let timerLabel = UILabel()
        timerLabel.frame.size = CGSize(width: 50, height: 50)
        timerLabel.font = .systemFont(ofSize: 70)
        timerLabel.text = "3"
        timerLabel.textColor = .white
        timerLabel.textAlignment = .center
        return timerLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        timerLabel.center.x = view.center.x
        timerLabel.center.y = view.center.y

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        view.addSubview(timerLabel)
        
    }
    
    @objc func updateTimer() {
        count -= 1
        print(count)
    }
    
    deinit {
        print("DownTimer deinited")
    }
    
}
