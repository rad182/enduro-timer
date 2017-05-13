//
//  LapTimesViewController.swift
//  Timer
//
//  Created by Royce Dy on 12/05/2017.
//  Copyright © 2017 Royce Dy. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class LapTimesViewController: UITableViewController {
   
    var lapTimes: Results<LapTime>!
    let dateFormatter = DateFormatter()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Lap Times"
        let clearAllBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: self, action: #selector(didTapClearAllBarButtonItem))
        self.navigationItem.rightBarButtonItem = clearAllBarButtonItem
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.dateFormatter.dateFormat = "hh:mm:ss.SS a"

        let realm = try! Realm()
        self.lapTimes = realm.objects(LapTime.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didTapClearAllBarButtonItem() {
        let actionSheetViewController = UIAlertController(title: "Are you sure you want to clear all Lap Times?", message: nil, preferredStyle: .actionSheet)
        actionSheetViewController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {  [unowned self] (_) in
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
            self.tableView.reloadData()
        }))
        actionSheetViewController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheetViewController, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lapTimes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        
        let lapTime = self.lapTimes[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: UIFontWeightRegular)
        cell.textLabel?.text = self.dateFormatter.string(from: lapTime.time)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let lapTime = self.lapTimes[indexPath.row]
            let realm = try! Realm()
            try! realm.write {
                realm.delete(lapTime)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
