import SwiftUI
import simd

public struct NodeMark<NodeID: Hashable>: GraphContent, Identifiable, Equatable {

    public var id: NodeID

    @inlinable
    public init(
        id: NodeID
    ) {
        self.id = id
    }

    @inlinable
    public func _attachToGraphRenderingContext(_ context: inout _GraphRenderingContext<NodeID>) {
        context.nodeOperations.append(
            .init(
                self,
                context.states.currentShading,
                context.states.currentStroke,
                context.states.currentSymbolShapeOrSize
            )
        )
        context.states.currentID = .node(id)
        context.nodeRadiusSquaredLookup[id] = simd_length_squared(
            context.states.currentSymbolSizeOrDefault.simd)
    }
}

extension NodeMark: CustomDebugStringConvertible {
    @inlinable
    public var debugDescription: String {
        return "Node(id: \(id))"
    }
}