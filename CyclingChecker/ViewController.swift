//
//  ViewController.swift
//  CyclingChecker
//
//  Created by Nao Kawanishi on 10/5/16.
//  Copyright © 2016 Nao Kawanishi. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let cmMotionActivityManager = CMMotionActivityManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let labelWidth: CGFloat = 280
        
        let countLabelHeight: CGFloat = 100
        let countLabelX: CGFloat = self.view.bounds.width/2 - labelWidth/2
        let countLabelY: CGFloat = self.view.bounds.height/2 - countLabelHeight/2
        let countLabel: UILabel = UILabel(frame: CGRect(x: countLabelX, y: countLabelY, width: labelWidth, height: countLabelHeight))
        countLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(100))
        countLabel.text = "0"
        countLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(countLabel)
        
        let titleLabelHeight: CGFloat = 25
        let titleLabel: UILabel = UILabel(frame: CGRect(x: countLabelX, y: countLabelY - titleLabelHeight, width: labelWidth, height: titleLabelHeight))
        titleLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(20))
        titleLabel.text = "Cycling Count"
        titleLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(titleLabel)

        let fromTitleLabelHeight: CGFloat = 15
        let fromLabel: UILabel = UILabel(frame: CGRect(x: countLabelX, y: countLabelY + countLabelHeight, width: labelWidth, height: fromTitleLabelHeight))
        fromLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
        fromLabel.text = "From: -"
        fromLabel.textAlignment = NSTextAlignment.right
        self.view.addSubview(fromLabel)
        
        let toTitleLabelHeight: CGFloat = 15
        let toLabel: UILabel = UILabel(frame: CGRect(x: countLabelX, y: countLabelY + countLabelHeight + fromTitleLabelHeight, width: labelWidth, height: toTitleLabelHeight))
        toLabel.font = UIFont.systemFont(ofSize: CGFloat(10))
        toLabel.text = "To: -"
        toLabel.textAlignment = NSTextAlignment.right
        self.view.addSubview(toLabel)
        
        if CMMotionActivityManager.isActivityAvailable() {
            var cyclingCount = 0

            let toDate = NSDate()
            let fromDate = toDate.addingTimeInterval(TimeInterval(-1*7*24*60*60))
            
            fromLabel.text = "From: \(fromDate)"
            toLabel.text = "To: \(toDate)"
            
            self.cmMotionActivityManager.queryActivityStarting(from: fromDate as Date, to: toDate as Date, to: OperationQueue.main, withHandler: {
                [unowned self] cmMotionActivities, error in
                if error != nil {
                } else {
                    for cmMotionActivity in cmMotionActivities! {
                        if cmMotionActivity.cycling {
                            cyclingCount = cyclingCount + 1
                            countLabel.text = String(cyclingCount)
                        }
                    }
                }})
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

