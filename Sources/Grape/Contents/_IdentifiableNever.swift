public enum _IdentifiableNever<ID: Hashable> { }

extension _IdentifiableNever: GraphContent {
    public typealias NodeID = ID
    
    public var body: Self {
        fatalError()
    }
    
    public func _attachToGraphRenderingContext(_ context: inout _GraphRenderingContext<NodeID>) {
        fatalError()
    }
}