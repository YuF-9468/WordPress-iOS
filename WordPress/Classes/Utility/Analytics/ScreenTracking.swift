import Foundation
import WordPressShared

extension WPAnalytics {
    /// Fires the `screen_shown` event.
    static func trackScreen(
        _ screen: some ScreenIdentifier,
        context: ScreenTrackingContext,
        properties: [String: String] = [:]
    ) {
        var props = context.properties
        props["screen"] = screen.rawValue
        props.merge(properties) { _, new in new }
        WPAnalytics.track(.screenShown, properties: props)
    }
}

/// A string-backed identifier for use in structured analytics tracking.
protocol TrackingIdentifier: RawRepresentable where RawValue == String {}

/// A marker protocol for enums that identify screens.
protocol ScreenIdentifier: TrackingIdentifier {}

/// A lightweight value type that accumulates navigation context as the user
/// moves through screens.
///
/// Each view controller stores a `ScreenTrackingContext` that describes how
/// the user reached the current screen (the source). When navigating deeper,
/// the current screen appends itself to the context before passing it to the
/// next screen.
/// Describes the UI interaction that triggered a navigation.
struct ScreenTrackingTrigger {
    /// The UI element that triggered the navigation.
    let component: String

    /// The specific action on the trigger component.
    let action: String

    /// Position index for list items (0-based).
    let position: Int?

    init(
        component: some TrackingIdentifier,
        action: some TrackingIdentifier = ReaderTriggerAction.tap,
        position: Int? = nil
    ) {
        self.component = component.rawValue
        self.action = action.rawValue
        self.position = position
    }
}

/// A lightweight value type that accumulates navigation context as the user
/// moves through screens.
///
/// Each view controller stores a `ScreenTrackingContext` that describes how
/// the user reached the current screen (the source). When navigating deeper,
/// the current screen appends itself to the context before passing it to the
/// next screen.
struct ScreenTrackingContext {
    /// The breadcrumb path of source screens (e.g. `["reader_sidebar", "reader_following"]`).
    private(set) var path: [String] = []

    /// The trigger that led to the current screen.
    private(set) var trigger: ScreenTrackingTrigger?

    /// Arbitrary key-value pairs that persist through `appending()` calls and
    /// are merged into the final analytics properties.
    var userInfo: [String: String] = [:]

    /// Returns a new context with the current screen appended to the source
    /// path and an optional trigger describing what the user tapped.
    func appending(
        _ screen: some ScreenIdentifier,
        trigger: ScreenTrackingTrigger? = nil
    ) -> ScreenTrackingContext {
        var context = ScreenTrackingContext()
        context.path = path + [screen.rawValue]
        context.trigger = trigger
        context.userInfo = userInfo
        return context
    }

    // MARK: - Analytics

    /// Builds the properties dictionary for the analytics event.
    var properties: [String: String] {
        var props: [String: String] = [:]
        if !path.isEmpty {
            props["source_path"] = path.joined(separator: " > ")
            props["source_origin"] = path.first
            props["source_immediate"] = path.last
        }
        if let trigger {
            props["trigger_component"] = trigger.component
            props["trigger_action"] = trigger.action
            if let position = trigger.position {
                props["trigger_position"] = String(position)
            }
        }
        props.merge(userInfo) { _, new in new }
        return props
    }
}
