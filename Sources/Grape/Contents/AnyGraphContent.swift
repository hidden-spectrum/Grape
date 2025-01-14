
public struct AnyGraphContent<NodeID: Hashable>: GraphContent {

    @usableFromInline
    let storage: any GraphContent<NodeID>

    @inlinable
    public init(_ storage: any GraphContent<NodeID>) {
        self.storage = storage
    }


    @inlinable
    public var body: _IdentifiableNever<NodeID> {
        _IdentifiableNever<_>()
    }

    @inlinable
    public func _attachToGraphRenderingContext(_ context: inout _GraphRenderingContext<NodeID>) {
        storage._attachToGraphRenderingContext(&context)
    }

}
