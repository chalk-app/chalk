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
    func numberOfShapes() -> Int
    func shapeAt(index: Int) -> Shape
}

class WhiteboardView: UIView {

    var delegate: WhiteboardViewDelegate?

    func drawShapes() {
        if let count = self.delegate?.numberOfShapes() {
            for i in 0 ..< count {
                if let shape = self.delegate?.shapeAt(i) {
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
}
