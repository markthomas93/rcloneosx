//
//  ArgumentsOneConfiguration.swift
//
//  Created by Thomas Evensen on 09/02/16.
//  Copyright © 2016 Thomas Evensen. All rights reserved.
//
//  swiftlint OK - 17 July 2017
//  swiftlint:disable line_length

import Foundation

// Struct for to store info for ONE configuration.
// Struct is storing rclone arguments for real run, dryrun
// and a version to show in view of both

struct ArgumentsOneConfiguration {

    var config: Configuration?
    var arg: [String]?
    var argdryRun: [String]?
    var argDisplay: [String]?
    var argdryRunDisplay: [String]?
    var argslistRemotefiles: [String]?
    var argsRestorefiles: [String]?
    var argsRestorefilesdryRun: [String]?
    var argsRestorefilesdryRunDisplay: [String]?
    // Restore
    var restore: [String]?
    var restoredryRun: [String]?
    var restoreDisplay: [String]?
    var restoredryRunDisplay: [String]?
    // Temporary restore
    var tmprestore: [String]?
    var tmprestoredryRun: [String]?

    init(config: Configuration) {
        // The configuration
        self.config = config
        // All arguments for rclone is computed, two sets. One for dry-run and one for real run.
        // the parameter forDisplay = true computes arguments to display in view.
        self.arg = RcloneProcessArguments().argumentsRclone(config, dryRun: false, forDisplay: false)
        self.argDisplay = RcloneProcessArguments().argumentsRclone(config, dryRun: false, forDisplay: true)
        self.argdryRun = RcloneProcessArguments().argumentsRclone(config, dryRun: true, forDisplay: false)
        self.argdryRunDisplay = RcloneProcessArguments().argumentsRclone(config, dryRun: true, forDisplay: true)
        self.argslistRemotefiles = RcloneProcessArguments().argumentsRclonelistfile(config)
        self.argsRestorefiles = RcloneProcessArguments().argumentsRclonerestore(config, dryRun: false, forDisplay: false)
        self.argsRestorefilesdryRun = RcloneProcessArguments().argumentsRclonerestore(config, dryRun: true, forDisplay: false)
        self.argsRestorefilesdryRunDisplay = RcloneProcessArguments().argumentsRclonerestore(config, dryRun: true, forDisplay: true)
        // Restore path
        self.restore = RcloneProcessArguments().argumentsRestore(config, dryRun: false, forDisplay: false, tmprestore: false)
        self.restoredryRun = RcloneProcessArguments().argumentsRestore(config, dryRun: true, forDisplay: false, tmprestore: false)
        self.restoreDisplay = RcloneProcessArguments().argumentsRestore(config, dryRun: false, forDisplay: true, tmprestore: false)
        self.restoredryRunDisplay = RcloneProcessArguments().argumentsRestore(config, dryRun: true, forDisplay: true, tmprestore: false)
        // Temporary restore path
        self.tmprestore = RcloneProcessArguments().argumentsRestore(config, dryRun: false, forDisplay: false, tmprestore: true)
        self.tmprestoredryRun = RcloneProcessArguments().argumentsRestore(config, dryRun: true, forDisplay: false, tmprestore: true)
    }
}
