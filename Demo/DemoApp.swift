import SwiftUI
import FencedLease
import FencedLeaseUI

/// Host app for `FencedLease`'s interactive demonstration.
///
/// The app deliberately owns one real decision -- how long a demo lease runs for --
/// so it has a genuine reason to import the core module rather than importing
/// something it never uses. `LeaseTheatreView` takes that value as a parameter.
@main
struct DemoApp: App {

    var body: some Scene {
        WindowGroup {
            LeaseTheatreView(leaseDuration: DemoConfiguration.leaseDuration)
        }
    }
}

/// Compiled-in configuration, validated against the library's own bounds.
enum DemoConfiguration {

    /// Seconds a demo lease is granted for.
    ///
    /// Validated here, at the app boundary, rather than trusted. `LeaseCoordinator`
    /// would throw `.invalidDuration` on a bad value deep inside an acquire; doing
    /// the check at the edge means a bad constant degrades to the library's minimum
    /// and the demo still launches. That is the right trade for a demo, and it is
    /// also the reason the app imports `FencedLease` at all.
    static let leaseDuration: TimeInterval = {
        let requested: TimeInterval = 30
        do {
            try LeaseLimits.validate(requested)
            return requested
        } catch {
            return LeaseLimits.minimumDuration
        }
    }()
}
