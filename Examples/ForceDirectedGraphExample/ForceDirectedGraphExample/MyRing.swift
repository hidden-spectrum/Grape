//
//  ForceDirectedGraphSwiftUIExample.swift
//  ForceDirectedGraphExample
//
//  Created by li3zhen1 on 11/5/23.
//

import Foundation
import Grape
import SwiftUI
import ForceSimulation

struct MyRing: View {
    
    @State var graphStates = ForceDirectedGraphState()
    
    var body: some View {
        
        ForceDirectedGraph(states: graphStates) {
            Series(0..<20) { i in
                NodeMark(id: 3 * i + 0)
                    .symbolSize(radius: 6.0)
                    .foregroundStyle(.green)
                    .stroke(.clear)
                NodeMark(id: 3 * i + 1)
                    .symbol(.pentagon)
                    .symbolSize(radius:10)
                    .foregroundStyle(.blue)
                    .stroke(.clear)
                NodeMark(id: 3 * i + 2)
                    .symbol(.circle)
                    .symbolSize(radius:6.0)
                    .foregroundStyle(.yellow)
                    .stroke(.clear)
                
                LinkMark(from: 3 * i + 0, to: 3 * i + 1)
                LinkMark(from: 3 * i + 1, to: 3 * i + 2)
                
                LinkMark(from: 3 * i + 0, to: 3 * ((i + 1) % 20) + 0)
                LinkMark(from: 3 * i + 1, to: 3 * ((i + 1) % 20) + 1)
                LinkMark(from: 3 * i + 2, to: 3 * ((i + 1) % 20) + 2)
                
                
            }
            .stroke(
                .black,
                StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round)
            )
            
        } force: {
            .manyBody(strength: -15)
            .link(
                originalLength: .constant(20.0),
                stiffness: .weightedByDegree { _, _ in 3.0}
            )
            .center()
            .collide()
        }
        .graphOverlay { proxy in
            Rectangle().fill(.clear).contentShape(Rectangle())
                .withGraphDragGesture(proxy, action: describe)
                .withGraphMagnifyGesture(proxy)
        }
        .toolbar {
            GraphStateToggle(graphStates: graphStates)
        }
    }
    
    func describe(_ state: GraphDragState?) {
        switch state {
        case .node(let anyHashable):
            print("Dragging \(anyHashable as! Int)")
        case .background(let start):
            print("Dragging \(start)")
        case nil:
            print("Drag ended")
        }
    }
}
