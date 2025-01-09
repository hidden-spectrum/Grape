import SwiftUI

extension View {
    @inlinable
    @available(tvOS, unavailable)
    public func withGraphTapGesture<NodeID: Hashable>(
        _ proxy: GraphProxy,
        of type: NodeID.Type,
        action: @escaping (NodeID) -> Void
    ) -> some View {
        self.onTapGesture { value in
            if let nodeID = proxy.node(of: type, at: value) {
                action(nodeID)
            }
        }
    }
}
