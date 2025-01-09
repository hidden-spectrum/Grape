import ForceSimulation
import SwiftUI

public struct GraphProxy {

    @usableFromInline
    var storage: (any _AnyGraphProxyProtocol)?

    @inlinable
    init(_ storage: some _AnyGraphProxyProtocol) {
        self.storage = storage
    }

    @inlinable
    public init() {
        self.storage = nil
    }

}

extension GraphProxy: _AnyGraphProxyProtocol {
    /// Find the node ID at the given location in the viewport coordinate, with specific type.
    /// Returns `nil` if no node is found or the node is not of the specified type.
    @inlinable
    public func node<ID>(of type: ID.Type, at locationInViewportCoordinate: CGPoint) -> ID? where ID : Hashable {
        storage?.node(of: type, at: locationInViewportCoordinate)
    }

    /// Find the type erased node ID at the given location in the viewport coordinate.
    /// Returns `nil` if no node is found.
    @inlinable
    public func node(at locationInViewportCoordinate: CGPoint) -> AnyHashable? {
        storage?.node(at: locationInViewportCoordinate)
    }

    @inlinable
    public func setNodeFixation<ID: Hashable>(nodeID: ID, fixation: CGPoint?, minimumAlpha: Double = 0.5) {
        storage?.setNodeFixation(nodeID: nodeID, fixation: fixation, minimumAlpha: minimumAlpha)
    }

    @inlinable
    public var kineticAlpha: Double {
        get {
            storage?.kineticAlpha ?? 0
        }
        nonmutating set {
            storage?.kineticAlpha = newValue
        }
    }

    @inlinable
    public var finalTransform: ViewportTransform {
        storage?.finalTransform ?? .identity
    }

    @inlinable
    public var modelTransform: ViewportTransform {
        _read {
            if let storage = storage {
                yield storage.modelTransform
            } else {
                fatalError()
            }
        }
        nonmutating _modify {
            if let storage {
                yield &storage.modelTransform
            } else {
                fatalError()
            }
        }
    }

    @inlinable
    public var obsoleteState: ObsoleteState {
        get {
            storage?.obsoleteState ?? .init(cgSize: .init(width: 0, height: 0))
        }
        nonmutating set {
            storage?.obsoleteState = newValue
        }
    }

    public var lastTransformRecord: ViewportTransform? {
        get {
            storage?.lastTransformRecord
        }
        nonmutating set {
            storage?.lastTransformRecord = newValue
        }
    }

}

@usableFromInline
struct GraphProxyKey: PreferenceKey {
    @inlinable
    static func reduce(value: inout GraphProxy, nextValue: () -> GraphProxy) {
        value = nextValue()
    }

    @inlinable
    static var defaultValue: GraphProxy {
        .init()
    }
}

extension View {
    @inlinable
    public func graphOverlay<V>(
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping (GraphProxy) -> V
    ) -> some View where V: View {
        self.overlayPreferenceValue(GraphProxyKey.self, content)
    }

    @inlinable
    public func graphBackground<V>(
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping (GraphProxy) -> V
    ) -> some View where V: View {
        self.backgroundPreferenceValue(GraphProxyKey.self, content)
    }
}
