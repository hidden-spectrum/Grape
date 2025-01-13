import ForceSimulation
import SwiftUI
import simd


extension ForceDirectedGraphModel {

    @inlinable 
    internal func findNodeFromViewAnnotation(
        at locationInSimulationCoordinate: SIMD2<Double>
    ) -> GraphRenderingStates<NodeID>.StateID? {
        for (symbolID, box) in rasterizedSymbols {
            if box.contains(locationInSimulationCoordinate) {
                return symbolID
            }
        }
        return nil
    }

    @inlinable
    internal func findNode(
        at locationInSimulationCoordinate: SIMD2<Double>
    ) -> NodeID? {
        
        let viewportScale = self.finalTransform.scale
        
        for i in simulationContext.storage.kinetics.range.reversed() {
            let iNodeID = simulationContext.nodeIndices[i]
            guard
                let iRadius2 = graphRenderingContext.nodeHitSizeAreaLookup[
                    simulationContext.nodeIndices[i]
                ]
            else { continue }
            let iPos = simulationContext.storage.kinetics.position[i]
            
            /// https://github.com/li3zhen1/Grape/pull/62#issue-2753932460
            ///
            /// ```swift
            /// let actualRadius = pow((iRadius2 * 0.5), 0.5) * 0.5
            /// let scaledRadius = actualRadius / max(.ulpOfOne, viewportScale)
            /// let scaledRadius2 = pow(scaledRadius, 2.0)
            /// ```
            ///
            let scaledRadius2 = iRadius2 / max(.ulpOfOne, (8.0 * viewportScale * viewportScale))
            let length2 = simd_length_squared(locationInSimulationCoordinate - iPos)
            
            if length2 <= scaledRadius2 {
                return iNodeID
            }
        }
        return nil
    }


    @inlinable
    internal func findNode(
        at locationInViewportCoordinate: CGPoint
    ) -> NodeID? {
        let simulationLocation = self.finalTransform.invert(locationInViewportCoordinate.simd)
        return findNode(at: simulationLocation)
    }

}
