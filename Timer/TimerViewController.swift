//
//  TimerViewController.swift
//  Timer
//
//  Created by Royce Dy on 12/05/2017.
//  Copyright © 2017 Royce Dy. All rights reserved.
//

import UIKit
import RealmSwift

class TimerViewController: UIViewController {
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var lapButton: UIButton!
    
    fileprivate let dateFormatter = DateFormatter()
    fileprivate var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let lapTimesBarButtonItem = UIBarButtonItem(title: "Times", style: .done, target: self, action: #selector(didTapLapTimesBarButtonItem))
        self.navigationItem.rightBarButtonItem = lapTimesBarButtonItem
        self.title = "Timer"
        // use monospace
        self.currentTimeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 63, weight: UIFontWeightRegular)
        
        self.dateFormatter.dateFormat = "hh:mm:ss.SS"
        self.updateCurrentTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.stopTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [unowned self] _ in
            self.updateCurrentTime()
        }
    }
    
    func updateCurrentTime() {
        self.currentTimeLabel.text = self.dateFormatter.string(from: Date())
    }
    
    func didTapLapTimesBarButtonItem() {
        let lapTimesViewController = LapTimesViewController()
        self.navigationController?.pushViewController(lapTimesViewController, animated: true)
    }
    
    @IBAction func didTapLapButton() {
        let realm = try! Realm()
        try! realm.write {
            let lapTime = LapTime()
            lapTime.time = Date()
            realm.add(lapTime)
        }
        
    }

}

