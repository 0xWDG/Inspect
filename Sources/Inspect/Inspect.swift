//
//  Inspect.swift
//  Inspect
//
//  Created by Wesley de Groot on 25/06/2024.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/Inspect
//  MIT LICENCE
//

import Foundation

#if !os(watchOS) && !os(Linux)
import SwiftUI

// MARK: - Platform Definitions
#if os(macOS)
/// Current platform's view
public typealias PlatformView = NSView
/// Current platform's view representable
public typealias PlatformViewRepresentable = NSViewRepresentable
/// Current platform's view representable context
public typealias PlatformViewRepresentableContext = NSViewRepresentableContext
/// Current platform's view controller
public typealias PlatformViewController = NSViewController
/// Current platform's view controller representable
public typealias PlatformVCRepresentable = NSViewControllerRepresentable
/// Current platform's view controller representable context
public typealias PlatformVCRepresentableContext = NSViewControllerRepresentableContext
#else
/// Current platform's view type
public typealias PlatformView = UIView
/// Current platform's view representable
public typealias PlatformViewRepresentable = UIViewRepresentable
/// Current platform's view representable context
public typealias PlatformViewRepresentableContext = UIViewRepresentableContext
/// Current platform's view controller
public typealias PlatformViewController = UIViewController
/// Current platform's view controller representable
public typealias PlatformVCRepresentable = UIViewControllerRepresentable
/// Current platform's view controller representable context
public typealias PlatformVCRepresentableContext = UIViewControllerRepresentableContext
#endif

// MARK: - Inspector
/// Helper class to find items within the PlatformView\*Element
public enum Inspector {
    /// Find Child
    ///
    /// Finds a subview of the specified type.
    /// This method will recursively look for this view.
    /// Returns nil if it can't find a view of the specified type.
    ///
    /// - Parameters:
    ///   - type: Type of view we're searching for
    ///   - root: Root view
    ///
    /// - Returns: The view of type (if found)
    public static func findChild<ViewOfType: PlatformView>(
        ofType type: ViewOfType.Type,
        in root: PlatformView
    ) -> ViewOfType? {
        // Search in subviews
        for subview in root.subviews {
            if let searchedView = subview as? ViewOfType {
                return searchedView
            } else if let searchedView = findChild(ofType: type, in: subview) {
                return searchedView
            }
        }

        // nothing found :(
        return nil
    }

    /// Find Sibling
    ///
    /// Finds a sibling that contains a view of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    ///
    /// - Parameters:
    ///   - type: Type of view we're searching for
    ///   - from: From View
    ///
    /// - Returns: The view of type (if found)
    public static func firstSibling<ViewOfType: PlatformView>(
        ofType type: ViewOfType.Type,
        from entry: PlatformView
    ) -> ViewOfType? {
        // Check if we can find a superview, and a subview with an index of PlatformView
        guard let superview = entry.superview,
              let entryIndex = superview.subviews.firstIndex(of: entry) else {
            // We could't find a index.
            return nil
        }

        // Search in subviews from the entry index.
        for subview in superview.subviews[entryIndex..<superview.subviews.endIndex] {
            // Search within child views
            if let searchedView = findChild(ofType: type, in: subview) {
                // We found the view.
                return searchedView
            }
        }

        // Nothing found :(
        return nil
    }

    /// Find Ancestor
    ///
    /// Finds an ancestor of the specified type.
    /// If it reaches the top of the view without finding the specified view type, it returns nil.
    ///
    /// - Parameters:
    ///   - type: Type of view we're searching for
    ///   - from: From view
    ///
    /// - Returns: The view of type (if found)
    public static func findAncestor<ViewOfType: PlatformView>(
        ofType type: ViewOfType.Type,
        from entry: PlatformView
    ) -> ViewOfType? {
        // Get the view above the current view (superview)
        var superview = entry.superview

        // Walk trough the subviews
        while let currentView = superview {
            // Is the current view the type we search for?
            if let searchedView = currentView as? ViewOfType {
                // We found the view.
                return searchedView
            }

            // Not found, check the view above current view (superview)
            superview = currentView.superview
        }

        // Nothing found :(
        return nil
    }

    /// Find Sibling
    ///
    /// Finds a sibling that contains a view of the specified type.
    /// This method inspects siblings recursively.
    /// Returns nil if no sibling contains the specified type.
    ///
    /// - Parameters:
    ///   - type: Type of view we're searching for
    ///   - from: From View
    ///
    /// - Returns: The view of type (if found)
    public static func find<ViewOfType: PlatformView>(
        ofType type: ViewOfType.Type,
        from entry: PlatformView
    ) -> ViewOfType? {
        // Get the view above the current view (superview)
        var superview = entry.superview

        // Walk trough the subviews
        while let currentView = superview {
            // Is the current view the type we search for?
            if let searchedView = currentView as? ViewOfType {
                // We found the view.
                return searchedView
            }

            // Not found, check the view above current view (superview)
            superview = currentView.superview
        }

        // Search previous sibling
        if let superview = entry.superview,
           let entryIndex = superview.subviews.firstIndex(of: entry),
           entryIndex > 0 {
            for subview in superview.subviews[0..<entryIndex].reversed() {
                if let typed = findChild(ofType: type, in: subview) {
                    return typed
                }
            }
        }

        // Check if we can find a superview, and a subview with an index of PlatformView
        guard let superview = entry.superview,
              let entryIndex = superview.subviews.firstIndex(of: entry) else {
            // We could't find a index.
            return nil
        }

        // Search in subviews from the entry index.
        for subview in superview.subviews[entryIndex..<superview.subviews.endIndex] {
            // Search within child views
            if let searchedView = findChild(ofType: type, in: subview) {
                // We found the view.
                return searchedView
            }
        }

        // Nothing found :(
        return nil
    }

    /// Find Hosting View
    ///
    /// Finds the hosting view of a specific subview.
    /// Hosting views generally contain subviews for one specific SwiftUI element.
    /// For instance, if there are multiple text fields in a VStack, the hosting view will contain those text fields.
    ///
    /// - Parameter entry: View
    ///
    /// - Returns: The view of type (if found)
    public static func findHostingView(from entry: PlatformView) -> PlatformView? {
        // Get the view above the current view (superview)
        var superview = entry.superview

        // Walk trough the subviews
        while let currentView = superview {
            // Check if the current view classname contains HostingView
            if NSStringFromClass(type(of: currentView)).contains("HostingView") {
                // We found the view.
                return currentView
            }

            // Not found, check the view above current view (superview)
            superview = currentView.superview
        }

        // Nothing found :(
        return nil
    }

    /// Find View Host
    ///
    /// Finds the view host of a specific view.
    /// SwiftUI wraps each UIView within a ViewHost, then within a HostingView.
    ///
    /// - Parameter entry: View
    ///
    /// - Returns: The view of type (if found)
    public static func findViewHost(from entry: PlatformView) -> PlatformView? {
        // Get the view above the current view (superview)
        var superview = entry.superview

        // Walk trough the subviews
        while let currentView = superview {
            // Check if the current view classname contains ViewHost
            if NSStringFromClass(type(of: currentView)).contains("ViewHost") {
                // We found the view.
                return currentView
            }

            // Not found, check the view above current view (superview)
            superview = currentView.superview
        }

        // Nothing found :(
        return nil
    }
}

/// Introspection PlatformView that is inserted alongside the target view.
///
/// This class is used to create a PlatformView
public class InspectPlatformView: PlatformView {
    required init() {
        super.init(frame: .zero)
        isHidden = true
    }

#if os(macOS)
    override public func hitTest(_ point: NSPoint) -> NSView? {
        return nil
    }
#endif

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Inspect
/// Inspect a PlatformView
public struct Inspect<TargetView: PlatformView>: PlatformViewRepresentable {
    /// The view type which we want to inspect
    let viewType: TargetView.Type

    /// User-provided customization method for the target view.
    let customizer: (TargetView) -> Void

    /// Inspect a PlatformView
    ///
    /// Use this to inspect a view
    ///
    /// - Parameter viewType: PlatformView
    /// - Parameter customizer: Customizer
    public init(
        _ viewType: TargetView.Type,
        customizer: @escaping (TargetView) -> Void
    ) {
        self.viewType = viewType
        self.customizer = customizer
    }

    // MARK: AppKit
    public func makeNSView(context: Context) -> InspectPlatformView {
        let view = InspectPlatformView()
#if os(macOS)
        view.setAccessibilityLabel("Inspect<\(TargetView.self)>")
#endif
        return view
    }

    public func updateNSView(_ nsView: InspectPlatformView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let viewHost = Inspector.findViewHost(from: nsView),
                  let targetView = Inspector.find(ofType: TargetView.self, from: viewHost) else {
                return
            }

            self.customizer(targetView)
        }
    }

    // MARK: UIKit
    public func makeUIView(context: PlatformViewRepresentableContext<Inspect>) -> InspectPlatformView {
        let view = InspectPlatformView()
#if !os(macOS)
        view.accessibilityLabel = "Inspect<\(TargetView.self)>"
#endif
        return view
    }

    public func updateUIView(
        _ uiView: InspectPlatformView,
        context: PlatformViewRepresentableContext<Inspect>
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let viewHost = Inspector.findViewHost(from: uiView),
                  let targetView = Inspector.find(ofType: TargetView.self, from: viewHost) else {
                return
            }

            self.customizer(targetView)
        }
    }
}

/// Inspect PlatformViewController that is inserted alongside the target view controller.
public class InspectPlatformViewController: PlatformViewController {
    required init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Inspect (View Controller)
/// Inspect a PlatformViewController
public struct InspectVC<TargetVCType: PlatformViewController>: PlatformVCRepresentable {
    /// The selector we want to use
    let selector: (InspectPlatformViewController) -> TargetVCType?

    /// User-provided customization method for the target view.
    let customizer: (TargetVCType) -> Void

    /// Inspect a PlatformViewController.
    ///
    /// Use this to inspect a view controller
    ///
    /// - Parameter selector: Selector to use
    /// - Parameter customizer: Customizer
    public init(
        _ selector: @escaping (PlatformViewController) -> TargetVCType?,
        customizer: @escaping (TargetVCType) -> Void
    ) {
        self.selector = selector
        self.customizer = customizer
    }

    // MARK: AppKit
    public func makeNSViewController(context: Context) -> InspectPlatformViewController {
        let viewController = InspectPlatformViewController()
#if os(macOS)
        viewController.view.setAccessibilityLabel("InspectVC<\(TargetVCType.self)>")
#endif
        return viewController
    }

    public func updateNSViewController(_ nsViewController: InspectPlatformViewController, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let targetView = self.selector(nsViewController) else {
                return
            }
            self.customizer(targetView)
        }
    }

    // MARK: UIKit
    public func makeUIViewController(
        context: PlatformVCRepresentableContext<InspectVC>
    ) -> InspectPlatformViewController {
        let viewController = InspectPlatformViewController()
#if !os(macOS)
        viewController.view.accessibilityLabel = "InspectVC<\(TargetVCType.self)>"
#endif
        return viewController
    }

    public func updateUIViewController(
        _ uiViewController: InspectPlatformViewController,
        context: PlatformVCRepresentableContext<InspectVC>
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            guard let targetView = self.selector(uiViewController) else {
                return
            }
            self.customizer(targetView)
        }
    }
}

extension View {
    /// Inspect a PlatformView
    ///
    /// Use this to inspect a view
    ///
    /// How to use:
    ///  ```swift
    ///  .inspect(MyViewType()) { view
    ///      print(view)
    ///  }
    ///  ```
    ///
    /// - Parameter element: Element to inspect
    /// - Parameter customizer: Element to modify
    public func inspect<TargetView: PlatformView>(
        _ element: TargetView.Type,
        customizer: @escaping (TargetView) -> Void
    ) -> some View {
        return overlay(
            Inspect(
                element,
                customizer: customizer
            ).frame(
                width: 0,
                height: 0
            )
        )
    }

    /// Inspect View Controller
    ///
    /// Use this to inspect a view controller
    ///
    ///  ```swift
    ///  .inspectVC({ $0.tabBarController }) { view
    ///      print(view)
    ///  }
    ///  ```
    ///
    /// - Parameter viewControllerSelector: View controller selector
    /// - Parameter customizer: Element to modify
    public func inspect<TargetView: PlatformViewController>(
        viewControllerSelector: @escaping (PlatformViewController) -> TargetView?,
        customizer: @escaping (PlatformViewController) -> Void
    ) -> some View {
        return overlay(
            InspectVC(
                viewControllerSelector,
                customizer: customizer
            ).frame(
                width: 0,
                height: 0
            )
        )
    }
}

#endif
// swiftlint:disable:this file_length
