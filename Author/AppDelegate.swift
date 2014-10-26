//
//  AppDelegate.swift
//  Author
//
//  Created by Tomoyuki Sahara on 10/25/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        print("hoge\n")
        
        var status: OSStatus

        // Creating an Authorization Reference Without Rights
        var aref = AuthorizationRef()
        status = AuthorizationCreate(nil, nil, AuthorizationFlags(kAuthorizationFlagDefaults), &aref)
        if (status != OSStatus(errAuthorizationSuccess)) {
            print("AuthorizationCreate failed.")
            return;
        }

        var aitem = AuthorizationItem(name: kSMRightBlessPrivilegedHelper, valueLength: 0, value: nil, flags: 0)
        var arights = AuthorizationRights(count: 1, items: &aitem)
        var aflags = AuthorizationFlags(kAuthorizationFlagDefaults +
            kAuthorizationFlagInteractionAllowed +
            kAuthorizationFlagPreAuthorize +
            kAuthorizationFlagExtendRights)
        status = AuthorizationCopyRights(aref, &arights, nil, aflags, nil)
        if (status != OSStatus(errAuthorizationSuccess)) {
            print("AuthorizationCopyRights failed.")
            return;
        }

        var cfError: Unmanaged<CFError>?
        if (SMJobBless(kSMDomainSystemLaunchd, "net.caddr.Author.Helper", aref, &cfError) == 0) {
            print("SMJobBless failed, error = \(cfError!.takeUnretainedValue())")
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

