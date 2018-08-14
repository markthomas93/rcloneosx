//
//  ViewControllerRestore.swift
//  rcloneosx
//
//  Created by Thomas Evensen on 09.08.2018.
//  Copyright © 2018 Thomas Evensen. All rights reserved.
//

import Foundation
import Cocoa

class ViewControllerRestore: NSViewController, SetConfigurations, SetDismisser, GetIndex, AbortTask {
    
    @IBOutlet weak var localCatalog: NSTextField!
    @IBOutlet weak var offsiteCatalog: NSTextField!
    @IBOutlet weak var offsiteServer: NSTextField!
    @IBOutlet weak var backupID: NSTextField!
    @IBOutlet weak var working: NSProgressIndicator!
    @IBOutlet weak var gotit: NSTextField!
    
    @IBOutlet weak var transferredNumber: NSTextField!
    @IBOutlet weak var transferredNumberSizebytes: NSTextField!
    @IBOutlet weak var newfiles: NSTextField!
    @IBOutlet weak var deletefiles: NSTextField!
    @IBOutlet weak var totalNumber: NSTextField!
    @IBOutlet weak var totalDirs: NSTextField!
    @IBOutlet weak var totalNumberSizebytes: NSTextField!
    @IBOutlet weak var restoreprogress: NSProgressIndicator!
    @IBOutlet weak var restorebutton: NSButton!
    @IBOutlet weak var tmprestore: NSTextField!
    @IBOutlet weak var selecttmptorestore: NSButton!
    
    var outputprocess: OutputProcess?
    var estimationcompleted: Bool?
    var estimatedremotenumbers: Bool?
    var completed: Bool?
    
    // Close and dismiss view
    @IBAction func close(_ sender: NSButton) {
        if self.completed == false { self.abort() }
        self.dismissview(viewcontroller: self, vcontroller: .vctabmain)
    }
    
    @IBAction func dotmprestore(_ sender: NSButton) {
        guard self.tmprestore.stringValue.isEmpty == false else { return }
        if let index = self.index() {
            self.selecttmptorestore.isEnabled = false
            self.estimationcompleted = true
            self.gotit.stringValue = "Getting remote info..."
            self.working.startAnimation(nil)
            switch self.selecttmptorestore.state {
            case .on:
                self.outputprocess = OutputProcess()
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
        self.gotit.stringValue = "Got it..."
    }
    
    private func remoterclonesize(input: String) -> Size? {
        let data: Data = input.data(using: String.Encoding.utf8)!
        guard let size = try? JSONDecoder().decode(Size.self, from: data) else { return nil}
        return size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewControllerReference.shared.setvcref(viewcontroller: .vcrestore, nsviewcontroller: self)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.estimationcompleted = true
        self.completed = false
        self.estimatedremotenumbers = false
        self.restorebutton.isEnabled = false
        self.localCatalog.stringValue = ""
        self.offsiteCatalog.stringValue = ""
        self.offsiteServer.stringValue = ""
        self.backupID.stringValue = ""
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
            self.selecttmptorestore.state = .off
            _ = RestoreTask(index: index, outputprocess: self.outputprocess, dryrun: true, tmprestore: false)
        }
    }
    
    private func setNumbers(outputprocess: OutputProcess?) {
        globalMainQueue.async(execute: { () -> Void in
            let infotask = RemoteInfoTask(outputprocess: outputprocess)
            self.transferredNumber.stringValue = infotask.transferredNumber!
        })
    }
    
    // Progressbar restore
    private func initiateProgressbar() {
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
        if estimationcompleted == true {
            self.estimationcompleted = false
            self.setNumbers(outputprocess: self.outputprocess)
            guard ViewControllerReference.shared.restorePath != nil else { return }
            self.selecttmptorestore.isEnabled = true
            // And then collect remote numbers
            _ = getremotenumbers()
            
        } else {
            if self.estimatedremotenumbers == false {
                self.estimatedremotenumbers = true
                self.setremoteinfo()
            } else {
                self.gotit.stringValue = "Restore is completed..."
                self.restoreprogress.isHidden = true
            }
        }
        self.completed = true
    }
    
    func fileHandler() {
        if self.estimationcompleted == false {
            self.updateProgressbar(Double(self.outputprocess!.count()))
        }
    }
}
