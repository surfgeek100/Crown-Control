import AppKit

final class CrownControl: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var enabled = true
    private var launchObserver: NSObjectProtocol?
    private var activationObserver: NSObjectProtocol?
    private let musicBundleID = "com.apple.Music"

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "♛"
        statusItem.button?.toolTip = "Crown Control — prevent Apple Music from launching"
        updateMenu()

        let center = NSWorkspace.shared.notificationCenter
        launchObserver = center.addObserver(forName: NSWorkspace.didLaunchApplicationNotification,
                                             object: nil, queue: .main) { [weak self] notice in
            self?.handleWorkspaceNotification(notice)
        }
        activationObserver = center.addObserver(forName: NSWorkspace.didActivateApplicationNotification,
                                                 object: nil, queue: .main) { [weak self] notice in
            self?.handleWorkspaceNotification(notice)
        }
        // Also handle Music if it was already open when Crown Control started.
        closeMusicIfRunning()
    }

    func applicationWillTerminate(_ notification: Notification) {
        let center = NSWorkspace.shared.notificationCenter
        if let observer = launchObserver { center.removeObserver(observer) }
        if let observer = activationObserver { center.removeObserver(observer) }
    }

    private func handleWorkspaceNotification(_ notification: Notification) {
        guard enabled,
              let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
              app.bundleIdentifier == musicBundleID else { return }
        // Use a normal, non-forceful quit request. No Accessibility permission required.
        if !app.isTerminated { _ = app.terminate() }
    }

    private func closeMusicIfRunning() {
        guard enabled else { return }
        for app in NSRunningApplication.runningApplications(withBundleIdentifier: musicBundleID) {
            if !app.isTerminated { _ = app.terminate() }
        }
    }

    private func updateMenu() {
        let menu = NSMenu()
        let toggle = NSMenuItem(title: enabled ? "Protection On ✓" : "Protection Off",
                                action: #selector(toggleProtection), keyEquivalent: "")
        toggle.target = self
        menu.addItem(toggle)
        menu.addItem(NSMenuItem.separator())
        let about = NSMenuItem(title: "Crown Control: blocks Apple Music launches", action: nil, keyEquivalent: "")
        about.isEnabled = false
        menu.addItem(about)
        menu.addItem(NSMenuItem.separator())
        let quit = NSMenuItem(title: "Quit Crown Control", action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
        statusItem.menu = menu
    }

    @objc private func toggleProtection() {
        enabled.toggle()
        updateMenu()
        if enabled { closeMusicIfRunning() }
    }

    @objc private func quitApp() { NSApp.terminate(nil) }
}

let app = NSApplication.shared
let delegate = CrownControl()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
