import ForceSimulation
import SwiftUI

public enum GraphDragState {
    case node(AnyHashable)
    case background(start: SIMD2<Double>)
}

#if !os(tvOS)

@usableFromInline
struct GraphDragModifier: ViewModifier {

    @inlinable
    public var dragGesture: some Gesture {
        DragGesture(
            minimumDistance: Self.minimumDragDistance,
            coordinateSpace: .local
        )
        .onChanged(onChanged)
        .onEnded(onEnded)
    }

    @inlinable
    public func body(content: Content) -> some View {
        content.gesture(dragGesture)
    }

    @inlinable
    @State
    public var dragState: GraphDragState?

    @usableFromInline
    let graphProxy: GraphProxy

    @usableFromInline
    let action: ((GraphDragState?) -> Void)?

    @inlinable
    init(
        graphProxy: GraphProxy,
        action: ((GraphDragState?) -> Void)? = nil
    ) {
        self.graphProxy = graphProxy
        self.action = action
    }

    @inlinable
    static var minimumDragDistance: CGFloat { 3.0 }

    @inlinable
    static var minimumAlphaAfterDrag: CGFloat { 0.5 }

    @inlinable
    public func onEnded(
        value: DragGesture.Value
    ) {
        if dragState != nil {
            switch dragState {
            case .node(let nodeID):
                graphProxy.setNodeFixation(nodeID: nodeID, fixation: nil)
            case .background(let start):
                let delta = value.location.simd - start
                graphProxy.modelTransform.translate += delta
                dragState = .background(start: value.location.simd)
            case .none:
                break
            }
            dragState = .none
        }

        if let action {
            action(dragState)
        }
    }

    @inlinable
    public func onChanged(
        value: DragGesture.Value
    ) {
        if dragState == nil {
            if let nodeID = graphProxy.node(at: value.startLocation) {
                dragState = .node(nodeID)
                graphProxy.setNodeFixation(nodeID: nodeID, fixation: value.startLocation)
            } else {
                dragState = .background(start: value.location.simd)
            }
        } else {
            switch dragState {
            case .node(let nodeID):
                graphProxy.setNodeFixation(nodeID: nodeID, fixation: value.location)
            case .background(let start):
                let delta = value.location.simd - start
                graphProxy.modelTransform.translate += delta
                dragState = .background(start: value.location.simd)
            case .none:
                break
            }
        }

        if let action {
            action(dragState)
        }
    }
}

extension View {
    @inlinable
    public func withGraphDragGesture(
        _ proxy: GraphProxy,
        action: ((GraphDragState?) -> Void)? = nil
    ) -> some View {
        self.modifier(GraphDragModifier(graphProxy: proxy, action: action))
    }
}

#endif