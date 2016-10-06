//
//  ViewController.swift
//  CyclingChecker
//
//  Created by Nao Kawanishi on 10/5/16.
//  Copyright © 2016 Nao Kawanishi. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cmMotionActivityManager = CMMotionActivityManager()
    
    var myLabel: UILabel!
    let myItems: NSMutableArray = []
    var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(ViewController.checkCyclingData),
            name:NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil)
        
        // Status Barの高さを取得
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        // Viewの高さと幅を取得
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        // Labelの生成
        let labelHeight: CGFloat = 40
        let myLabel: UILabel = UILabel(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: labelHeight))
        myLabel.backgroundColor = UIColor.black
        myLabel.textColor = UIColor.white
        myLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(14))
        myLabel.textAlignment = NSTextAlignment.center
        myLabel.text = "startDate of MotionActivity with 'cycling'"
        self.view.addSubview(myLabel)
        
        // TableViewの生成
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight + labelHeight, width: displayWidth, height: displayHeight - (barHeight + labelHeight)))
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel!.text = "\(myItems[indexPath.row])"
        return cell
    }
    
    func checkCyclingData() {
        if CMMotionActivityManager.isActivityAvailable() {
            myItems.removeAllObjects()
            
            let toDate = NSDate()
            let fromDate = toDate.addingTimeInterval(TimeInterval(-1*7*24*60*60))
            
            self.cmMotionActivityManager.queryActivityStarting(from: fromDate as Date, to: toDate as Date, to: OperationQueue.main, withHandler: {
                [unowned self] cmMotionActivities, error in
                if error != nil {
                } else {
                    for cmMotionActivity in cmMotionActivities! {
                        if cmMotionActivity.cycling == true {
                            self.myItems.add(cmMotionActivity.startDate as NSDate)
                        }
                    }
                    self.myTableView.reloadData()
                }})
            
        }
    }
}

