//
//  PendantView.swift
//  Buzzi
//
//  Created by Ingo Wiederoder on 13.03.15.
//  Copyright (c) 2015 Ingo Wiederoder. All rights reserved.
//

import UIKit


extension String {
    
    func sizeForFont(font: UIFont) -> CGSize {
        let stringObject: NSString = self
        let stringSize = stringObject.sizeWithAttributes([NSFontAttributeName: font])
        return stringSize
    }
    
}


enum ArrowPosition {
    case topLeft
    case topCenter
    case topRight
    case bottomLeft
    case bottomCenter
    case bottomRight
}

class PendantView: UIView {
    
    var color: UIColor = UIColor.yellowColor(){
        didSet {
            if color != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
        
    var textRows: Int = 1 {
        didSet {
            if textRows != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    lazy var radius: CGFloat = 8.0
    
    var arrowPosition: ArrowPosition = .topCenter {
        didSet {
            if arrowPosition != oldValue {
                if arrowPosition == .bottomCenter || arrowPosition == .bottomLeft || arrowPosition == .bottomRight {
                    textLabel.frame.origin.y = edgeSpace
                }
                self.setNeedsDisplay()
            }
        }
    }
    
    var fontSize: CGFloat = 17.0 {
        didSet {
            if fontSize != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    
    var pendantText: String
    
    let arrowHeight: CGFloat = 13.0
    let arrowWidth: CGFloat = 17.0
    
    let textLabel: UILabel
    var viewHeight: CGFloat = 36.0
    var edgeSpace: CGFloat = 8.0
    
    
    init(frame: CGRect, text: String) {
        var labelOffset: CGFloat
        switch self.arrowPosition {
        case .bottomCenter, .bottomLeft, .bottomRight :
            labelOffset = 0.0
        default:
            labelOffset = arrowHeight
        }
        textLabel = UILabel(frame: CGRectMake(edgeSpace, edgeSpace + labelOffset, frame.size.width, fontSize))
        pendantText = text
        super.init(frame: frame)
        textLabel.font = UIFont(name: "Helvetica Neue", size: fontSize)
        textLabel.text = self.pendantText
        textLabel.sizeToFit()
        self.addSubview(textLabel)
    }

    convenience init(text: String) {
        let edgeValue: CGFloat = 8.0
        let textSize = text.sizeForFont(UIFont(name: "Helvetica Neue", size: 17.0)!)
        let pendantFrame = CGRectMake(0.0, 0.0, textSize.width + 2*edgeValue , (textSize.height + 2*edgeValue) + 13.0)
        self.init(frame:pendantFrame, text: text)
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience init(text: String, arrowPosition: ArrowPosition, color: UIColor,textRows: Int) {
        self.init(text: text)
        self.arrowPosition = arrowPosition
        self.color = color
        self.textRows = textRows
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func drawArrow() {
        
        func getSecondArrowPoint(headPoint: CGPoint) -> CGPoint {
            switch self.arrowPosition {
            case .topCenter, .topLeft, .topRight :
                return CGPointMake(headPoint.x + arrowWidth/2, arrowHeight)
            case .bottomCenter, .bottomLeft, .bottomRight :
                return CGPointMake(headPoint.x + arrowWidth/2, headPoint.y - arrowHeight)
            default:
                return CGPointMake(headPoint.x + arrowWidth/2, arrowHeight)
                
            }
        }
        
        func getThirdArrowPoint(headPoint: CGPoint) -> CGPoint {
            switch self.arrowPosition {
            case .topCenter, .topLeft, .topRight :
                return CGPointMake(headPoint.x - arrowWidth/2, arrowHeight)
            case .bottomCenter, .bottomLeft, .bottomRight :
                return CGPointMake(headPoint.x - arrowWidth/2, headPoint.y - arrowHeight)
            default :
                return CGPointMake(headPoint.x - arrowWidth/2, arrowHeight)
            }
        }
        
        let arrowPath = UIBezierPath()
        let headPoint = getArrowHeadPoint()
        arrowPath.moveToPoint(headPoint)
        arrowPath.addLineToPoint(getSecondArrowPoint(headPoint))
        arrowPath.addLineToPoint(getThirdArrowPoint(headPoint))
        arrowPath.closePath()
        self.color.setFill()
        arrowPath.fill()
    }
    
   private func drawPendant(){
        var yPos: CGFloat = 0.0
        switch self.arrowPosition {
        case .topCenter, .topLeft, .topRight :
            yPos = arrowHeight
        case .bottomCenter, .bottomLeft, .bottomRight :
            yPos = 0.0
        default: arrowHeight
        }
        let pendantBounds = CGRectMake(0.0, yPos, self.bounds.width, self.bounds.height - arrowHeight)
        let pendantPath = UIBezierPath(roundedRect: pendantBounds, cornerRadius: self.radius)
        self.color.setFill()
        pendantPath.fill()
    }
    
    private func getArrowHeadPoint() -> CGPoint {
        switch self.arrowPosition {
        case .topCenter :
            return CGPointMake(CGRectGetMidX(self.bounds), 0.0)
        case .topLeft :
            return CGPointMake(edgeSpace + arrowWidth, 0.0)
        case .topRight :
            let xValue = CGRectGetMaxX(self.bounds) - (edgeSpace + arrowWidth)
            return CGPointMake(xValue, 0.0)
        case .bottomCenter :
            return CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds))
        case .bottomLeft :
            return CGPointMake(edgeSpace + arrowWidth, CGRectGetMaxY(self.bounds))
        case .bottomRight :
            let xValue = CGRectGetMaxX(self.bounds) - (edgeSpace + arrowWidth)
            return CGPointMake(xValue, CGRectGetMaxY(self.bounds))
        default:
            return CGPointMake(CGRectGetMidX(self.bounds), 0.0)
        }
    }
    

    
    // MARK: drawRect

    override func drawRect(rect: CGRect) {
        drawArrow()
        drawPendant()
    }


}
