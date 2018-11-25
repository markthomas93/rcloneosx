//
//  ViewControllerRestore.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 09.08.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//
// swiftlint:disable line_length

import Foundation
import Cocoa

enum Work {
    case localinfoandnumbertosync
    case getremotenumbers
    case setremotenumbers
    case restore
}

class ViewControllerRestore: NSViewController, SetConfigurations, SetDismisser, GetIndex, AbortTask {

    @IBOutlet weak var localCatalog: NSTextField!
    @IBOutlet weak var offsiteCatalog: NSTextField!
    @IBOutlet weak var offsiteServer: NSTextField!
    @IBOutlet weak var backupID: NSTextField!
    @IBOutlet weak var working: NSProgressIndicator!
    @IBOutlet weak var gotit: NSTextField!
    @IBOutlet weak var transferredNumber: NSTextField!
    @IBOutlet weak var totalNumber: NSTextField!
    @IBOutlet weak var totalNumberSizebytes: NSTextField!
    @IBOutlet weak var restoreprogress: NSProgressIndicator!
    @IBOutlet weak var restorebutton: NSButton!
    @IBOutlet weak var tmprestore: NSTextField!
    @IBOutlet weak var selecttmptorestore: NSButton!

    var outputprocess: OutputProcess?
    var restorecompleted: Bool?
    weak var sendprocess: Sendprocessreference?
    var diddissappear: Bool = false
    var workqueue: [Work]?

    // Close and dismiss view
    @IBAction func close(_ sender: NSButton) {
        if self.workqueue != nil && self.outputprocess != nil { self.abort() }
        if self.restorecompleted == false { self.abort() }
        self.dismissview(viewcontroller: self, vcontroller: .vctabmain)
    }

    @IBAction func dotmprestore(_ sender: NSButton) {
        guard self.tmprestore.stringValue.isEmpty == false else { return }
        if let index = self.index() {
            self.selecttmptorestore.isEnabled = false
            self.gotit.textColor = .white
            self.gotit.stringValue = "Getting info, please wait..."
            self.working.startAnimation(nil)
            self.workqueue?.append(.localinfoandnumbertosync)
            self.outputprocess = OutputProcess()
            self.sendprocess?.sendoutputprocessreference(outputprocess: self.outputprocess)
            switch self.selecttmptorestore.state {
            case .on:
                _ = RestoreTask(index: index, outputprocess: self.outputprocess, dryrun: true, tmprestore: true)
            case .off:
                self.outputprocess = OutputProcess()
                _ = RestoreTask(index: index, outputprocess: self.outputprocess, dryrun: true, tmprestore: false)
            default:
                return
            }
        } else {
            self.gotit.stringValue = "Well, this did not work ..."
        }
    }

    @IBAction func restore(_ sender: NSButton) {
        let answer = Alerts.dialogOKCancel("Do you REALLY want to start a RESTORE ?", text: "Cancel or OK")
        if answer {
            if let index = self.index() {
                self.restorebutton.isEnabled = false
                self.initiateProgressbar()
                self.outputprocess = OutputProcess()
                self.sendprocess?.sendoutputprocessreference(outputprocess: self.outputprocess)
                switch self.selecttmptorestore.state {
                case .on:
                    _ = RestoreTask(index: index, outputprocess: self.outputprocess, dryrun: false, tmprestore: true)
                case .off:
                    _ = RestoreTask(index: index, outputprocess: self.outputprocess, dryrun: false, tmprestore: false)
                default:
                    return
                }
            }
        }
    }

    private func getremotenumbers() {
        if let index = self.index() {
            self.outputprocess = OutputProcess()
            self.sendprocess?.sendoutputprocessreference(outputprocess: self.outputprocess)
            _ = RcloneSize(index: index, outputprocess: self.outputprocess)
        }
    }

    private func setremoteinfo() {
        guard self.outputprocess?.getOutput()?.count ?? 0 > 0 else { return }
        let size = self.remoterclonesize(input: self.outputprocess!.getOutput()![0])
        guard size != nil else { return }
        NumberFormatter.localizedString(from: NSNumber(value: size!.count), number: NumberFormatter.Style.decimal)
        self.totalNumber.stringValue = String(NumberFormatter.localizedString(from: NSNumber(value: size!.count), number: NumberFormatter.Style.decimal))
        self.totalNumberSizebytes.stringValue = String(NumberFormatter.localizedString(from: NSNumber(value: size!.bytes/1024), number: NumberFormatter.Style.decimal))
        self.working.stopAnimation(nil)
        self.restorebutton.isEnabled = true
        self.gotit.textColor = .green
        self.gotit.stringValue = "Got it..."
        self.workqueue = nil
        self.outputprocess = nil
    }

    private func remoterclonesize(input: String) -> Size? {
        let data: Data = input.data(using: String.Encoding.utf8)!
        guard let size = try? JSONDecoder().decode(Size.self, from: data) else { return nil}
        return size
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerReference.shared.setvcref(viewcontroller: .vcrestore, nsviewcontroller: self)
        self.sendprocess = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        guard self.diddissappear == false else { return }
        guard self.workqueue == nil && self.outputprocess == nil else { return }
        _ = self.removework()
        self.restorebutton.isEnabled = false
        self.localCatalog.stringValue = ""
        self.offsiteCatalog.stringValue = ""
        self.offsiteServer.stringValue = ""
        self.backupID.stringValue = ""
        self.restoreprogress.isHidden = true
        if let index = self.index() {
            let config: Configuration = self.configurations!.getConfigurations()[index]
            self.localCatalog.stringValue = config.localCatalog
            self.offsiteCatalog.stringValue = config.offsiteCatalog
            self.offsiteServer.stringValue = config.offsiteServer
            self.backupID.stringValue = config.backupID
            self.tmprestore.stringValue = ViewControllerReference.shared.restorePath ?? " ... set in User configuration ..."
            if ViewControllerReference.shared.restorePath == nil {
                self.selecttmptorestore.isEnabled = false
            }
            self.working.startAnimation(nil)
            self.outputprocess = OutputProcess()
            self.sendprocess?.sendoutputprocessreference(outputprocess: self.outputprocess)
            self.selecttmptorestore.state = .off
            _ = self.removework()
            _ = RestoreTask(index: index, outputprocess: self.outputprocess, dryrun: true, tmprestore: false)
        }
    }

    override func viewDidDisappear() {
        super.viewDidDisappear()
        self.diddissappear = true
    }

    private func setNumbers(outputprocess: OutputProcess?) {
        globalMainQueue.async(execute: { () -> Void in
            let infotask = RemoteInfoTask(outputprocess: outputprocess)
            self.transferredNumber.stringValue = infotask.transferredNumber!
        })
    }

    private func removework() -> Work? {
        // Initialize
        guard self.workqueue != nil else {
            self.workqueue = [Work]()
            self.workqueue?.append(.restore)
            self.workqueue?.append(.setremotenumbers)
            self.workqueue?.append(.getremotenumbers)
            self.workqueue?.append(.localinfoandnumbertosync)
            return nil
        }
        guard self.workqueue!.count > 1 else {
            let work = self.workqueue?[0] ?? .restore
            return work
        }
        let index = self.workqueue!.count - 1
        let work = self.workqueue!.remove(at: index)
        return work
    }

    // Progressbar restore
    private func initiateProgressbar() {
        self.restoreprogress.isHidden = false
        if let calculatedNumberOfFiles = self.outputprocess?.getMaxcount() {
            self.restoreprogress.maxValue = Double(calculatedNumberOfFiles)
        }
        self.restoreprogress.minValue = 0
        self.restoreprogress.doubleValue = 0
        self.restoreprogress.startAnimation(self)
    }

    private func updateProgressbar(_ value: Double) {
        self.restoreprogress.doubleValue = value
    }

}

extension ViewControllerRestore: UpdateProgress {
    func processTermination() {
        switch self.removework()! {
        case .getremotenumbers:
            self.setNumbers(outputprocess: self.outputprocess)
            guard ViewControllerReference.shared.restorePath != nil else { return }
            self.selecttmptorestore.isEnabled = true
            // And then collect remote numbers
            _ = getremotenumbers()
        case .setremotenumbers:
            self.setremoteinfo()
        case .restore:
            self.gotit.textColor = .green
            self.gotit.stringValue = "Restore is completed..."
            self.restoreprogress.isHidden = true
            self.restorecompleted = true
            self.restoreprogress.isHidden = true
        case .localinfoandnumbertosync:
            self.setNumbers(outputprocess: self.outputprocess)
            guard ViewControllerReference.shared.restorePath != nil else { return }
            self.selecttmptorestore.isEnabled = true
            self.working.stopAnimation(nil)
            self.restorebutton.isEnabled = true
            self.gotit.textColor = .green
            self.gotit.stringValue = "Got it..."
        }
    }

    func fileHandler() {
        if self.workqueue?.count == 1 {
            self.updateProgressbar(Double(self.outputprocess!.count()))
        }
    }
}
