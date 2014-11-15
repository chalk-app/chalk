//
//  WhiteboardView.swift
//  Chalk
//
//  Created by Alexander Ignatenko on 15/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

import UIKit
import CoreGraphics

protocol WhiteboardViewDelegate {
    func numberOfShapes(whiteboard: WhiteboardView) -> Int
    func shapeAt(whiteboard: WhiteboardView, index: Int) -> Shape
    func hasNewShape(whiteboard: WhiteboardView, shape: Shape)
}

class WhiteboardView: UIView {

    var lineWidth: Double
    var strokeColor: UIColor

    var delegate: WhiteboardViewDelegate?

    private var currentShape: Shape?

    override init(frame: CGRect) {
        self.lineWidth = 4
        self.strokeColor = UIColor.darkGrayColor()
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        self.lineWidth = 4
        self.strokeColor = UIColor.darkGrayColor()
        super.init(coder: aDecoder)
    }

    func drawShapes() {
        if let count = self.delegate?.numberOfShapes(self) {
            for i in 0 ..< count {
                if let shape = self.delegate?.shapeAt(self, index: i) {
                    self.drawShape(shape)
                }
            }
        }
    }

    func drawShape(shape: Shape) {
        let first = shape.points[0]
        let rest = shape.points[1 ... shape.points.count]

        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(ctx, shape.strokeColor)
        CGContextMoveToPoint(ctx, first.x, first.y)
        for p in rest {
            CGContextAddLineToPoint(ctx, p.x, p.y)
        }
        CGContextClosePath(ctx)
    }

    override func drawRect(rect: CGRect) {
        self.drawShapes()
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch?
        let location: CGPoint! = touch?.locationInView(self)

        self.currentShape = Shape(
            points: [location],
            width: self.lineWidth,
            strokeColor: self.strokeColor.CGColor
        )
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch?
        let location: CGPoint! = touch?.locationInView(self)

        // TODO: we may want to skip some location
        self.currentShape?.points.append(location)
    }

    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.anyObject() as UITouch?
        let location: CGPoint! = touch?.locationInView(self)

        self.delegate?.hasNewShape(self, shape: self.currentShape!)
        self.currentShape = nil
    }

    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.currentShape = nil
    }
}
