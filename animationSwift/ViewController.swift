//
//  ViewController.swift
//  animationSwift
//
//  Created by deepak mishra on 5/11/15.
//  Copyright © 2015 deepakmishra. All rights reserved.
//

import UIKit

enum Direction {
    case Forward
    case Reverse
}

class ViewController: UIViewController {
    
    var lengthOfLine: CGFloat = 0
    let lineLayer = CAShapeLayer()
    var nameLabel = UILabel()
    let startAngle: CGFloat = CGFloat((90/180)  * M_PI)
    let endAngle: CGFloat = CGFloat((90.001/180) * M_PI)
    let startPointX: CGFloat = 25.0
    let startPointY: CGFloat = 60.0
    let radius: CGFloat = 20.0
    let durationFactor = 0.4
    let lineWidth:CGFloat = 2.0
    var strokeEndPoint:CGFloat = 0.0
    var direction: Direction?
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        lengthOfLine = (view.frame.size.width - (2 * startPointX))
        
        // set the end point of line upto the
        strokeEndPoint = lengthOfLine / (lengthOfLine + (2 * CGFloat(M_PI) * radius)) //2πr is the circumference of circle
        self.designTheGraphics()
        
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, startPointY))
    }
    
    private func designTheGraphics() {
        let designContainer = UIView(frame: CGRectMake(0, 0, view.frame.size.width, startPointY))
        designContainer.backgroundColor = UIColor.clearColor()
        view.addSubview(designContainer)
        
        //String above line
        nameLabel = UILabel(frame: CGRectMake(startPointX, 25, 150, 40))
        nameLabel.textColor = UIColor.redColor()
        nameLabel.text = "Welcome"
        designContainer.addSubview(nameLabel)
        
        //Three parallel lines at right most side
        self.designParallelLinesGroup(designContainer)
        
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPointMake(startPointX, startPointY))
        linePath.addLineToPoint(CGPointMake(startPointX + lengthOfLine, startPointY))
        linePath.addArcWithCenter(CGPointMake(startPointX + lengthOfLine, startPointY - radius),
            radius: radius,
            startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        lineLayer.path = linePath.CGPath
        lineLayer.lineWidth = lineWidth
        lineLayer.lineCap = kCALineCapRound
        lineLayer.fillColor = UIColor.clearColor().CGColor
        lineLayer.strokeColor = UIColor.redColor().CGColor
        lineLayer.strokeStart = 0
        lineLayer.strokeEnd = strokeEndPoint
        
        designContainer.layer.addSublayer(lineLayer)
    }

    private func designParallelLinesGroup(superView: UIView) {
        let spanLength = radius
        let spacePadding = radius/4
        
        let topLine = UIBezierPath()
        topLine.moveToPoint(CGPointMake(startPointX + lengthOfLine - (spanLength/2), startPointY - radius - spacePadding))
        topLine.addLineToPoint(CGPointMake(startPointX + lengthOfLine + (spanLength/2), startPointY - radius - spacePadding))
        let topLineLayer = CAShapeLayer()
        topLineLayer.path = topLine.CGPath
        topLineLayer.lineWidth = lineWidth
        topLineLayer.lineCap = kCALineCapRound
        topLineLayer.fillColor = UIColor.clearColor().CGColor
        topLineLayer.strokeColor = UIColor.redColor().CGColor
        superView.layer.addSublayer(topLineLayer)
        
        let middleLine = UIBezierPath()
        middleLine.moveToPoint(CGPointMake(startPointX + lengthOfLine - (spanLength/2), startPointY - radius))
        middleLine.addLineToPoint(CGPointMake(startPointX + lengthOfLine + (spanLength/2), startPointY - radius))
        let middleLineLayer = CAShapeLayer()
        middleLineLayer.lineCap = kCALineCapRound
        middleLineLayer.path = middleLine.CGPath
        middleLineLayer.lineWidth = lineWidth
        middleLineLayer.fillColor = UIColor.clearColor().CGColor
        middleLineLayer.strokeColor = UIColor.redColor().CGColor
        superView.layer.addSublayer(middleLineLayer)
        
        let bottomLine = UIBezierPath()
        bottomLine.moveToPoint(CGPointMake(startPointX + lengthOfLine - (spanLength/2), startPointY - radius + spacePadding))
        bottomLine.addLineToPoint(CGPointMake(startPointX + lengthOfLine + (spanLength/2), startPointY - radius + spacePadding))
        let bottomLineLayer = CAShapeLayer()
        bottomLineLayer.lineCap = kCALineCapRound
        bottomLineLayer.path = bottomLine.CGPath
        bottomLineLayer.lineWidth = lineWidth
        bottomLineLayer.fillColor = UIColor.clearColor().CGColor
        bottomLineLayer.strokeColor = UIColor.redColor().CGColor
        superView.layer.addSublayer(bottomLineLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK: Animation Code
extension ViewController {
    func animateLine(direction: Direction) {
        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        strokeStart.duration = durationFactor
        
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.duration = durationFactor
        
        switch direction {
        case .Forward:
            print("Forward")
            strokeStart.fromValue = 0
            strokeStart.toValue = strokeEndPoint
            strokeEnd.fromValue = strokeEndPoint
            strokeEnd.toValue = 1
            lineLayer.strokeStart = strokeEndPoint
            lineLayer.strokeEnd = 1
        case .Reverse:
            print("Reverse")
            strokeStart.fromValue = strokeEndPoint
            strokeStart.toValue = 0
            strokeEnd.fromValue = 1
            strokeEnd.toValue = strokeEndPoint
            lineLayer.strokeStart = 0
            lineLayer.strokeEnd = strokeEndPoint
        }
        lineLayer.addAnimation(strokeStart, forKey: "strokeStart")
        lineLayer.addAnimation(strokeEnd, forKey: "strokeEnd")
        self.direction = direction
    }
    
    func animateText(direction: Direction) {
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.duration = durationFactor
        
        switch direction {
        case .Forward:
            transition.subtype = kCATransitionFromTop
            nameLabel.text = ""
        case .Reverse:
            transition.subtype = kCATransitionFromBottom
            nameLabel.text = "Welcome"
        }
        nameLabel.layer.addAnimation(transition, forKey: kCATransition)
    }
}


//MARK:- UITableViewDelegate and UITableViewDatasource
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as! FoodTableViewCell
        cell.selectionStyle = .None
        return cell
    }
}

//MARK:- UIScrollViewDelegate 
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let newOffset = scrollView.contentOffset
        switch newOffset.y {
        case let y where y > 0:
            guard let _ = self.direction else {
                animateLine(.Forward)
                animateText(.Forward)
                break
            }
        case let y where y < 0:
            guard let _ = self.direction else {
                break
            }
            animateLine(.Reverse)
            animateText(.Reverse)
            self.direction = nil
        default:
            break
        }
    }
}