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
public typealias PlatformView = NSView
public typealias PlatformControl = NSControl
public typealias PlatformViewRepresentable = NSViewRepresentable
public typealias PlatformViewRepresentableContext = NSViewRepresentableContext
public typealias PlatformViewController = NSViewController
public typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable
public typealias PlatformViewControllerRepresentableContext = NSViewControllerRepresentableContext
#else
public typealias PlatformView = UIView
public typealias PlatformControl = UIControl
public typealias PlatformViewRepresentable = UIViewRepresentable
public typealias PlatformViewRepresentableContext = UIViewRepresentableContext
public typealias PlatformViewController = UIViewController
public typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable
public typealias PlatformViewControllerRepresentableContext = UIViewControllerRepresentableContext
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
    public static func findChild<viewOfType: PlatformView>(
        ofType type: viewOfType.Type,
        in root: PlatformView
    ) -> viewOfType? {
        // Search in subviews
        for subview in root.subviews {
            if let searchedView = subview as? viewOfType {
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
    public static func firstSibling<viewOfType: PlatformView>(
        ofType type: viewOfType.Type,
        from entry: PlatformView
    ) -> viewOfType? {
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
    public static func findAncestor<viewOfType: PlatformView>(
        ofType type: viewOfType.Type,
        from entry: PlatformView
    ) -> viewOfType? {
        // Get the view above the current view (superview)
        var superview = entry.superview

        // Walk trough the subviews
        while let currentView = superview {
            // Is the current view the type we search for?
            if let searchedView = currentView as? viewOfType {
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
    public static func find<viewOfType: PlatformView>(
        ofType type: viewOfType.Type,
        from entry: PlatformView
    ) -> viewOfType? {
        // Get the view above the current view (superview)
        var superview = entry.superview

        // Walk trough the subviews
        while let currentView = superview {
            // Is the current view the type we search for?
            if let searchedView = currentView as? viewOfType {
                // We found the view.
                return searchedView
            }

            // Not found, check the view above current view (superview)
            superview = currentView.superview
        }

        // Search previous sibling
        if let superview = entry.superview,
           let entryIndex = superview.subviews.firstIndex(of: entry),
           entryIndex > 0
        {
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

            print ("Try subview 2 = \(subview.self)")

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
    public override func hitTest(_ point: NSPoint) -> NSView? {
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
    /// How to use:
    ///  ```swift
    ///  .overlay {
    ///      Inspect(MyViewType()) { view
    ///          print(view)
    ///      }
    ///  }
    ///  ```
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

/// Introspection PlatformViewController that is inserted alongside the target view controller.
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
public struct InspectVC<TargetViewControllerType: PlatformViewController>: PlatformViewControllerRepresentable {
    /// The selector we want to use
    let selector: (InspectPlatformViewController) -> TargetViewControllerType?

    /// User-provided customization method for the target view.
    let customizer: (TargetViewControllerType) -> Void

    /// Inspect a PlatformViewController.
    ///
    /// Use this to inspect a view controller
    ///
    /// Example:
    ///  ```swift
    ///  .overlay {
    ///      InspectVC({ $0.tabBarController }) { view
    ///          print(view)
    ///      }
    ///  }
    ///  ```
    ///
    /// - Parameter selector: Selector to use
    /// - Parameter customizer: Customizer
    public init(
        _ selector: @escaping (PlatformViewController) -> TargetViewControllerType?,
        customizer: @escaping (TargetViewControllerType) -> Void
    ) {
        self.selector = selector
        self.customizer = customizer
    }

    // MARK: AppKit
    public func makeNSViewController(context: Context) -> InspectPlatformViewController {
        let viewController = InspectPlatformViewController()
#if os(macOS)
        viewController.view.setAccessibilityLabel("InspectVC<\(TargetViewControllerType.self)>")
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
        context: PlatformViewControllerRepresentableContext<InspectVC>
    ) -> InspectPlatformViewController {
        let viewController = InspectPlatformViewController()
#if !os(macOS)
        viewController.view.accessibilityLabel = "InspectVC<\(TargetViewControllerType.self)>"
#endif
        return viewController
    }

    public func updateUIViewController(
        _ uiViewController: InspectPlatformViewController,
        context: PlatformViewControllerRepresentableContext<InspectVC>
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
    public func inspect<TargetView: PlatformView>(
        _ element: TargetView.Type,
        customizer: @escaping (TargetView) -> ()
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

    public func inspect<TargetView: PlatformViewController>(
        viewControllerSelector: @escaping (PlatformViewController) -> TargetView?,
        customizer: @escaping (PlatformViewController) -> ()
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