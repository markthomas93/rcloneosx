//
//  OperationFactory.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 22.10.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//

import Foundation

// Protocol when a Scehduled job is starting and stopping
// Used to informed the presenting viewcontroller about what
// is going on
protocol RunningTask: class {
    func completed()
}

protocol SetScheduledTask {
    var runningtask: RunningTask? { get }
}

extension SetScheduledTask {
    weak var runningtask: RunningTask? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }
}

protocol Sendoutputprocessreference: class {
    func sendprocessreference(process: Process?)
    func sendoutputprocessreference(outputprocess: OutputProcess?)
}

class OperationFactory {

    var operationDispatch: ExecutingTaskDispatch?

    init() {
        self.operationDispatch = ExecutingTaskDispatch(seconds: 0)
    }
}
