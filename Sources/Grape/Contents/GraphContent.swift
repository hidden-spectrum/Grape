import SwiftUI


public protocol GraphContent<NodeID> {
    associatedtype NodeID: Hashable
    associatedtype Body: GraphContent<NodeID>

    @inlinable
    func _attachToGraphRenderingContext(_ context: inout _GraphRenderingContext<NodeID>)

    @inlinable
    @GraphContentBuilder<NodeID>
    var body: Body { get }
}


extension GraphContent {

    @inlinable
    public func _attachToGraphRenderingContext(_ context: inout _GraphRenderingContext<NodeID>) {
        body._attachToGraphRenderingContext(&context)
    }
}