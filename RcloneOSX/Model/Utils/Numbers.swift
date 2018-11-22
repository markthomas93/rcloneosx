//
//  numbers.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 22.05.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
//  Class for crunching numbers from rsyn output.  Numbers are
//  informal only, either used in main view or for logging purposes.
//
//  swiftlint:disable line_length

import Foundation

// enum for returning what is asked for
enum EnumNumbers {
    case totalNumber
    case totalDirs
    case totalNumberSizebytes
    case transferredNumber
    case transferredNumberSizebytes
    case new
    case delete
}

final class Numbers: SetConfigurations {

    private var output: [String]?
    // numbers after dryrun and stats
    var totNum: Int?
    var totDir: Int?
    var totNumSize: Double?
    var newfiles: Int?
    var deletefiles: Int?

    var transferNum: String?
    var transferNumSize: String?
    var transferNumSizeByte: String?
    var time: String?

    // Get numbers from rclone (dry run)
    func getTransferredNumbers (numbers: EnumNumbers) -> Int {
        switch numbers {
        case .totalDirs:
            return self.totDir ?? 0
        case .totalNumber:
            return self.totNum ?? 0
        case .transferredNumber:
            return Int(self.transferNum ?? "0") ?? 0
        case .totalNumberSizebytes:
            let size = self.totNumSize ?? 0
            return Int(size/1024 )
        case .transferredNumberSizebytes:
            let size = Int(self.transferNumSize ?? "0") ?? 0
            return Int(size/1024)
        case .new:
            let num = self.newfiles ?? 0
            return Int(num)
        case .delete:
            let num = self.deletefiles ?? 0
            return Int(num)
        }
    }

    private func prepareresult() {
        let transferred = self.output!.filter({(($0).contains("Transferred:"))})
        let elapsedtime = self.output!.filter({(($0).contains("Elapsed time:"))})
        guard transferred.count >= 2 && elapsedtime.count >= 1  else { return }
        let indextransferred = transferred.count
        let indexelapsed = elapsedtime.count
        let filesizessplit = transferred[indextransferred-2].components(separatedBy: " ").filter {$0.isEmpty == false && $0 != "Transferred:"}
        let filenumberssplit = transferred[indextransferred-1].components(separatedBy: " ").filter {$0.isEmpty == false}
        let elapstedtimesplit = elapsedtime[indexelapsed-1].components(separatedBy: " ").filter {$0.isEmpty == false}
        if filenumberssplit.count > 1 {
            if ViewControllerReference.shared.rclone143 {
                // ["Transferred:","5","/","5","100%"]
                self.transferNum = filenumberssplit[1]
            } else {
                // ["Transferred:","5"]
                self.transferNum = filenumberssplit[filenumberssplit.count - 1]
            }
        } else {
            self.transferNum = "0"
        }
        if filesizessplit.count > 3 {
            self.transferNumSize = filesizessplit[0]
            self.transferNumSizeByte = filesizessplit[1]
        } else {
            self.transferNumSize = "0.0"
            self.transferNumSizeByte = "bytes"
        }
        if elapstedtimesplit.count > 2 { self.time = elapstedtimesplit[2] } else { self.time = "0.0" }
    }

    // Collecting statistics about job
    func stats() -> String {
        let num = self.transferNum ?? "0"
        let size = self.transferNumSize ?? "0"
        let byte = self.transferNumSizeByte ?? "bytes"
        let time = self.time ?? "0"
        return  num + " files," + " " + size + " " + byte  + " in " + time
    }

    init (outputprocess: OutputProcess?) {
        guard outputprocess != nil else { return }
        self.output = outputprocess!.getOutput()
        self.prepareresult()
    }
}
