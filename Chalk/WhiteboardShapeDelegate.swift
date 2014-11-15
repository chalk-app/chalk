//
//  WhiteboardShapeDelegate.swift
//  Chalk
//
//  Created by Alexander Ignatenko on 15/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

import UIKit

class WhiteboardShapeDelegate: WhiteboardViewDelegate {

    var shapes = [Shape]()

    func numberOfShapes(whiteboard: WhiteboardView) -> Int {
        return self.shapes.count
    }

    func shapeAt(whiteboard: WhiteboardView, index: Int) -> Shape {
        return self.shapes[index]
    }

    func hasNewShape(whiteboard: WhiteboardView, shape: Shape) {
        self.shapes.append(shape)
        whiteboard.setNeedsDisplay()
    }
}
