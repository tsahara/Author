//
//  AppDelegate.swift
//  Author
//
//  Created by Tomoyuki Sahara on 10/25/14.
//  Copyright (c) 2014 Tomoyuki Sahara. All rights reserved.
//

import Cocoa
import ServiceManagement

let helper_service_name = "net.caddr.Author.Helper"

let PROTOCOL_VERSION = "1.3"

@objc protocol AuthorHelperProtocol {
    func getVersion(withReply: (NSString) -> Void)
    func openBPF(withReply: (Int) -> Void)
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func checkHelperProtocolVersion(callback: (Bool) -> Void) {
        let xpc = NSXPCConnection(machServiceName: helper_service_name, options: NSXPCConnectionOptions.Privileged)
        xpc.remoteObjectInterface = NSXPCInterface(`protocol`: AuthorHelperProtocol.self)
        xpc.invalidationHandler = { println("XPC invalidated") }
        xpc.resume()
        println(xpc)
        
        // getVersionAction
        var proxy = xpc.remoteObjectProxyWithErrorHandler({
            err in
            println("proxy=>\(err)")
            callback(false)
        }) as AuthorHelperProtocol
        proxy.getVersion({
            str in println("get version => \(str)")

            if (str != PROTOCOL_VERSION) {
                xpc.invalidate()
                callback(false)
            } else {
                xpc.invalidate()
                callback(true)
            }
        })
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        print("hoge\n")
        self.checkHelperProtocolVersion({
            ok in println("check version -> \(ok)")

            if (!ok) {
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
                    return
                }

                print("helper installed")
            }
        })
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
}
