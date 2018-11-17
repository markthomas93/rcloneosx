//
//  Batchoutput.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 12.03.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//

import Foundation

class OutputBatch {

    var output: [String]?

    func getOutput () -> [String] {
        return self.output ?? [""]
    }

    init() {
        self.output = nil
        self.output = [String]()
    }

}
