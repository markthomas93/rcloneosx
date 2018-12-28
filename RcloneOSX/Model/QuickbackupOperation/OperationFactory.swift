//
//  OperationFactory.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 22.10.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//

import Foundation

protocol Sendoutputprocessreference: class {
    func sendprocessreference(process: Process?)
    func sendoutputprocessreference(outputprocess: OutputProcess?)
}

class OperationFactory {

    var operationDispatch: QuickbackupDispatch?

    init() {
        self.operationDispatch = QuickbackupDispatch(seconds: 0)
    }
}
