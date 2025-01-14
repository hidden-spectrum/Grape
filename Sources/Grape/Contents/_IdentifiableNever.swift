public enum _IdentifiableNever<ID: Hashable> {
    @usableFromInline
    internal init() {
        fatalError()
    }
}


@inlinable
public func _fatalError<ID>(of identityType: ID) -> _IdentifiableNever<ID> where ID: Hashable {
    _IdentifiableNever<ID>()
}

extension _IdentifiableNever: GraphContent {
    public typealias NodeID = ID
    
    @inlinable
    public var body: Self {
        _IdentifiableNever<ID>()
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