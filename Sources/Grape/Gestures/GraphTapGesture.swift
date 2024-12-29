import SwiftUI

extension View {
    @inlinable
    public func withGraphTapGesture(
        _ proxy: GraphProxy,
        action: @escaping (AnyHashable) -> Void
    ) -> some View {
        self.onTapGesture { value in
            if let nodeID = proxy.locateNode(at: .init(x: value.x, y: value.y)) {
                action(nodeID)
            }
        }
    }
}
