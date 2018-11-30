//
//  ViewControllerExtensions.swift
//  rcloneOSX
//
//  Created by Thomas Evensen on 28.10.2017.
//  Copyright © 2017 Thomas Evensen. All rights reserved.
//
// swiftlint:disable line_length file_length

import Foundation
import Cocoa

protocol VcSchedule {
    var storyboard: NSStoryboard? { get }
    var viewControllerScheduleDetails: NSViewController? { get }
    var viewControllerUserconfiguration: NSViewController? { get }
    var viewControllerProfile: NSViewController? { get }
}

extension VcSchedule {
    var storyboard: NSStoryboard? {
        return NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    }

    // Information Schedule details
    // self.presentViewControllerAsSheet(self.ViewControllerScheduleDetails)
    var viewControllerScheduleDetails: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardScheduleID"))
            as? NSViewController)!
    }

    // Userconfiguration
    // self.presentViewControllerAsSheet(self.ViewControllerUserconfiguration)
    var viewControllerUserconfiguration: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardUserconfigID"))
            as? NSViewController)!
    }

    // Profile
    // self.presentViewControllerAsSheet(self.ViewControllerProfile)
    var viewControllerProfile: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ProfileID"))
            as? NSViewController)!
    }
}

protocol VcMain {
    var storyboard: NSStoryboard? { get }
    var viewControllerInformation: NSViewController? { get }
    var viewControllerProgress: NSViewController? { get }
    var viewControllerBatch: NSViewController? { get }
    var viewControllerUserconfiguration: NSViewController? { get }
    var viewControllerRcloneParams: NSViewController? { get }
    var newVersionViewController: NSViewController? { get }
    var viewControllerProfile: NSViewController? { get }
    var editViewController: NSViewController? { get }
    var viewControllerScheduledBackupInWork: NSViewController? { get }
    var viewControllerAbout: NSViewController? { get }
    var viewControllerScheduleDetails: NSViewController? { get }
}

extension VcMain {
    var storyboard: NSStoryboard? {
        return NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    }

    // Information about rclone output
    // self.presentViewControllerAsSheet(self.ViewControllerInformation)
    var viewControllerInformation: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardInformationID"))
            as? NSViewController)!
    }

    // Progressbar process
    // self.presentViewControllerAsSheet(self.ViewControllerProgress)
    var viewControllerProgress: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardProgressID"))
            as? NSViewController)!
    }

    // Batch process
    // self.presentViewControllerAsSheet(self.ViewControllerBatch)
    var viewControllerBatch: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardBatchID"))
            as? NSViewController)!
    }

    // Userconfiguration
    // self.presentViewControllerAsSheet(self.ViewControllerUserconfiguration)
    var viewControllerUserconfiguration: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardUserconfigID"))
            as? NSViewController)!
    }

    // Rclone userparams
    // self.presentViewControllerAsSheet(self.viewControllerRcloneParams)
    var viewControllerRcloneParams: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardRcloneParamsID"))
            as? NSViewController)!
    }

    // New version window
    // self.presentViewControllerAsSheet(self.newVersionViewController)
    var newVersionViewController: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardnewVersionID"))
            as? NSViewController)!
    }

    // Edit
    // self.presentViewControllerAsSheet(self.editViewController)
    var editViewController: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardEditID"))
            as? NSViewController)!
    }

    // Profile
    // self.presentViewControllerAsSheet(self.ViewControllerProfile)
    var viewControllerProfile: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ProfileID"))
            as? NSViewController)!
    }

    // ScheduledBackupInWorkID
    // self.presentViewControllerAsSheet(self.ViewControllerScheduledBackupInWork)
    var viewControllerScheduledBackupInWork: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "ScheduledBackupInWorkID"))
            as? NSViewController)!
    }

    // About
    // self.presentViewControllerAsSheet(self.ViewControllerAbout)
    var viewControllerAbout: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "AboutID"))
            as? NSViewController)!
    }

    // Information Schedule details
    // self.presentViewControllerAsSheet(self.ViewControllerScheduleDetails)
    var viewControllerScheduleDetails: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardScheduleID"))
            as? NSViewController)!
    }

    // Quick backup process
    // self.presentViewControllerAsSheet(self.viewControllerQuickBackup)
    var viewControllerQuickBackup: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardQuickBackupID"))
            as? NSViewController)!
    }

    // Remote Info
    // self.presentViewControllerAsSheet(self.viewControllerQuickBackup)
    var viewControllerRemoteInfo: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardRemoteInfoID"))
            as? NSViewController)!
    }

    // Estimating
    // self.presentViewControllerAsSheet(self.viewControllerEstimating)
    var viewControllerEstimating: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardEstimatingID"))
            as? NSViewController)!
    }

    // Restore
    // self.presentViewControllerAsSheet(self.restoreViewController)
    var restoreViewController: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardRestoreID"))
            as? NSViewController)!
    }
}

protocol VcCopyFiles {
    var storyboard: NSStoryboard? { get }
    var viewControllerInformation: NSViewController? { get }
    var viewControllerSource: NSViewController? { get }
}

extension VcCopyFiles {
    var storyboard: NSStoryboard? {
        return NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
    }

    // Information about rclone output
    // self.presentViewControllerAsSheet(self.ViewControllerInformation)
    var viewControllerInformation: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "StoryboardInformationCopyFilesID")) as? NSViewController)!
    }

    // Source for CopyFiles
    // self.presentViewControllerAsSheet(self.viewControllerSource)
    var viewControllerSource: NSViewController? {
        return (self.storyboard!.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "CopyFilesID")) as? NSViewController)!
    }
}

// Protocol for dismissing a viewcontroller
protocol DismissViewController: class {
    func dismiss_view(viewcontroller: NSViewController)
}
protocol SetDismisser {
    var dismissDelegateMain: DismissViewController? {get}
    var dismissDelegateSchedule: DismissViewController? {get}
    var dismissDelegateNewConfigurations: DismissViewController? {get}
}

extension SetDismisser {
    weak var dismissDelegateMain: DismissViewController? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }
    weak var dismissDelegateSchedule: DismissViewController? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabschedule) as? ViewControllertabSchedule
    }
    weak var dismissDelegateNewConfigurations: DismissViewController? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vcnewconfigurations) as? ViewControllerNewConfigurations
    }

    func dismissview(viewcontroller: NSViewController, vcontroller: ViewController) {
        if vcontroller == .vctabmain {
            self.dismissDelegateMain?.dismiss_view(viewcontroller: (self as? NSViewController)!)
        } else if vcontroller == .vctabschedule {
            self.dismissDelegateSchedule?.dismiss_view(viewcontroller: (self as? NSViewController)!)
        } else {
            self.dismissDelegateNewConfigurations?.dismiss_view(viewcontroller: (self as? NSViewController)!)
        }
    }
}

// Protocol for deselecting rowtable
protocol DeselectRowTable: class {
    func deselect()
}

protocol Deselect {
    var deselectDelegateMain: DeselectRowTable? {get}
    var deselectDelegateSchedule: DeselectRowTable? {get}
    func deselectrowtable(vcontroller: ViewController)
}

extension Deselect {
    weak var deselectDelegateMain: DeselectRowTable? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }
    weak var deselectDelegateSchedule: DeselectRowTable? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabschedule) as? ViewControllertabSchedule
    }

    func deselectrowtable(vcontroller: ViewController) {
        if vcontroller == .vctabmain {
            self.deselectDelegateMain?.deselect()
        } else {
            self.deselectDelegateSchedule?.deselect()
        }
    }
}

protocol Index {
     func index() -> Int?
}

extension Index {
    func index() -> Int? {
        let view = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
        return view?.getindex()
    }
}

protocol Delay {
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> Void)
}

extension Delay {

    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}

protocol Abort {
    func abort()
}

extension Abort {
    func abort() {
        let view = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
        view?.abortOperations()
    }
}

protocol GetOutput: class {
    func getoutput () -> [String]
}

protocol OutPut {
    var informationDelegateMain: GetOutput? {get}
    var informationDelegateCopyFiles: GetOutput? {get}
}

extension OutPut {
    weak var informationDelegateMain: GetOutput? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
    }
    weak var informationDelegateCopyFiles: GetOutput? {
        return ViewControllerReference.shared.getvcref(viewcontroller: .vccopyfiles) as? ViewControllerCopyFiles
    }

    func getinfo(viewcontroller: ViewController) -> [String] {
        if viewcontroller == .vctabmain {
            return self.informationDelegateMain!.getoutput()
        } else {
            return self.informationDelegateCopyFiles!.getoutput()
        }
    }
}

protocol RcloneIsChanged: class {
    func rcloneischanged()
}

protocol NewRclone {
    func newrclone()
}

extension NewRclone {
    func newrclone() {
        let view = ViewControllerReference.shared.getvcref(viewcontroller: .vctabmain) as? ViewControllertabMain
        view?.rcloneischanged()
    }
}

protocol TemporaryRestorePath: class {
    func temporaryrestorepath()
}

protocol ChangeTemporaryRestorePath {
    func changetemporaryrestorepath()
}

extension ChangeTemporaryRestorePath {
    func changetemporaryrestorepath() {
        let view = ViewControllerReference.shared.getvcref(viewcontroller: .vccopyfiles) as? ViewControllerCopyFiles
        view?.temporaryrestorepath()
    }
}

protocol Createandreloadconfigurations: class {
    func createandreloadconfigurations()
}
// Protocol for sorting
protocol Sorting {
    func sortbyrundate(notsorted: [NSMutableDictionary]?, sortdirection: Bool) -> [NSMutableDictionary]?
    func sortbystring(notsorted: [NSMutableDictionary]?, sortby: Sortandfilter, sortdirection: Bool) -> [NSMutableDictionary]?
    func filterbystring(filterby: Sortandfilter) -> String
}

extension Sorting {
    func sortbyrundate(notsorted: [NSMutableDictionary]?, sortdirection: Bool) -> [NSMutableDictionary]? {
        guard notsorted != nil else { return nil }
        let dateformatter = Dateandtime().setDateformat()
        let sorted = notsorted!.sorted { (dict1, dict2) -> Bool in
            let date1 = (dateformatter.date(from: (dict1.value(forKey: "dateExecuted") as? String) ?? "") ?? dateformatter.date(from: "01 Jan 1900 00:00")!)
            let date2 = (dateformatter.date(from: (dict2.value(forKey: "dateExecuted") as? String) ?? "") ?? dateformatter.date(from: "01 Jan 1900 00:00")!)
            if date1.timeIntervalSince(date2) > 0 {
                return sortdirection
            } else {
                return !sortdirection
            }
        }
        return sorted
    }

    func sortbystring(notsorted: [NSMutableDictionary]?, sortby: Sortandfilter, sortdirection: Bool) -> [NSMutableDictionary]? {
        guard notsorted != nil else { return nil }
        var sortstring: String?
        switch sortby {
        case .localcatalog:
            sortstring = "localCatalog"
        case .remoteserver:
            sortstring = "offsiteServer"
        case .task:
            sortstring = "task"
        case .backupid:
            sortstring = "backupID"
        case .profile:
            sortstring = "profile"
        default:
            sortstring = ""
        }
        let sorted = notsorted!.sorted { (dict1, dict2) -> Bool in
            if (dict1.value(forKey: sortstring!) as? String) ?? "" > (dict2.value(forKey: sortstring!) as? String) ?? "" {
                return sortdirection
            } else {
                return !sortdirection
            }
        }
        return sorted
    }

    func filterbystring(filterby: Sortandfilter) -> String {
        switch filterby {
        case .localcatalog:
            return "localCatalog"
        case .profile:
            return "profile"
        case .remotecatalog:
            return "offsiteCatalog"
        case .remoteserver:
            return "offsiteServer"
        case .task:
            return "task"
        case .backupid:
            return "backupID"
        case .numberofdays:
            return ""
        case .executedate:
            return "dateExecuted"
        }
    }
}

protocol Remoterclonesize: class {
    // empty
}

extension Remoterclonesize {
    func remoterclonesize(input: String) -> Size? {
        let data: Data = input.data(using: String.Encoding.utf8)!
        guard let size = try? JSONDecoder().decode(Size.self, from: data) else { return nil}
        return size
    }
}
