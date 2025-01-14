public enum _IdentifiableNever<ID: Hashable> { }

extension _IdentifiableNever: GraphContent {
    public typealias NodeID = ID
    
    @inlinable
    public var body: Self {
        fatalError()
    }
    
    @inlinable
    public func _attachToGraphRenderingContext(_ context: inout _GraphRenderingContext<NodeID>) {
        fatalError()
    }
}


extension _IdentifiableNever: Identifiable {
    @inlinable
    public var id: ID {
        fatalError()
    }
}