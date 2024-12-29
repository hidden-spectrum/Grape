import SwiftUI

public struct GraphProxy {
    
    @usableFromInline
    let storage: (any _AnyGraphProxyProtocol)?
    
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
    public func locateNode(at locationInViewportCoordinate: CGPoint) -> AnyHashable? {
        storage?.locateNode(at: locationInViewportCoordinate)   
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
        get {
            .init()
        }
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
}
