## RcloneOSX

![](icon/rcloneosx.png)

The project is a adapting [RsyncOSX](https://github.com/rsyncOSX/RsyncOSX) utilizing [rclone](https://rclone.org/) for synchronizing and backup of catalogs and files to a number of cloud services. RcloneOSX utilizes `rclone copy`, `sync`, `move` and `check` commands.

RcloneOSX is compiled with support for macOS version 10.11 - 10.13. The application is implemented in Swift 4 by using Xcode 9. RcloneOSX require the rclone utility to be installed. If installed in other directory than /usr/local/bin, please change directory by user Configuration in RcloneOSX. RcloneOSX checks if there is a rclone installed in the provided directory.

Rclone is *rsync for cloud storage*. Even if `rclone` and `rsync` are somewhat equal they are also different in many ways. RcloneOSX is built upon the ideas from RsyncOSX. But it is not possible to clone all functions in RsyncOSX to RcloneOSX. I spend most of my time developing RsyncOSX and from time to time some of the functions within RcloneOSX are ported from RsyncOSX. I am quite sure I could do more development in RcloneOSX, but my main focus is RsyncOSX. I am not an advanced user of rclone. I am synchronizing my GitHub catalog to Dropbox and Google.

I have also implemented [encrypted](https://rsyncosx.github.io/Encrypted) backup in RsyncOSX by utilizing RcloneOSX.

A short [intro](https://rsyncosx.github.io/RcloneIntro) about what RcloneOSX is. **Caution:** the screendumps in the intro are from the first version and not updated to last version.

### Application icon

The application icon is created by [Zsolt Sándor](https://github.com/graphis). All rights reserved to Zsolt Sándor.

### Changelog

Please see [Changelog](https://rsyncosx.github.io/RcloneChangelog)
