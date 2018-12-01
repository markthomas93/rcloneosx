//
//  ScheduleOperationDispatch.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 21.10.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//

import Foundation

class ScheduleOperationDispatch: SetSchedules, SecondsBeforeStart {

    private var workitem: DispatchWorkItem?

    private func dispatchtask(_ seconds: Int) {
        let scheduledtask = DispatchWorkItem { [weak self] in
            _ = ExecuteScheduledTask()
        }
        self.workitem = scheduledtask
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: scheduledtask)
    }

    init() {
        if self.schedules != nil {
            let seconds = self.secondsbeforestart()
            let nextseconds = self.nextsecondsbeforestart()
            guard nextseconds >= 0 else {
                ViewControllerReference.shared.scheduledTask = ViewControllerReference.shared.previousnextscheduledTask
                self.dispatchtask(0)
                ViewControllerReference.shared.dispatchTaskWaiting = self.workitem
                return
            }
            guard seconds > 0 else { return }
            self.dispatchtask(Int(seconds))
            // Set reference to schedule for later cancel if any
            ViewControllerReference.shared.dispatchTaskWaiting = self.workitem
        }
    }

    init(seconds: Int) {
        self.dispatchtask(seconds)
        // Set reference to schedule for later cancel if any
        ViewControllerReference.shared.dispatchTaskWaiting = self.workitem
    }

}
