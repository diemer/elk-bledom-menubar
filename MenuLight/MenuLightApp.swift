//
//  MenuLightApp.swift
//  MenuLight
//
//  Created by Dan Diemer on 7/30/24.
//

import SwiftUI

@main
struct MenuLightApp: App {
  var body: some Scene {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //        WindowGroup {
    //            ContentView()
    //        }
    Settings {
      EmptyView()
    }
  }
  
  
  class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover!
    var popoverController: NSViewController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
      statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
      
      if let button = statusItem?.button {
        button.image = NSImage(systemSymbolName: "lightbulb", accessibilityDescription: "Light")
        button.action = #selector(togglePopover(_:))
      }
      
      popoverController = NSViewController()
      popoverController.view = NSHostingView(rootView: ContentView())
      popover = NSPopover()
      popover.contentViewController = popoverController
      popover.behavior = .transient
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
      if let button = statusItem?.button {
        if popover.isShown {
          popover.performClose(sender)
        } else {
          popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
      }
    }
  }
}
