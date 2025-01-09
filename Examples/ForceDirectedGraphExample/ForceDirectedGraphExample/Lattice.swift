//
//  Lattice.swift
//  ForceDirectedGraphExample
//
//  Created by li3zhen1 on 11/8/23.
//

import SwiftUI
import Grape


struct Lattice: View {
    
    let width = 30
    let edge: [(Int, Int)]
    
    @State var graphStates = ForceDirectedGraphState(
        initialIsRunning: true
    )
    
    init() {
        var edge = [(Int, Int)]()
        for i in 0..<width {
            for j in 0..<width {
                if j != width - 1 {
                    edge.append((width * i + j, width * i + j + 1))
                }
                if i != width - 1 {
                    edge.append((width * i + j, width * (i + 1) + j))
                }
            }
        }
        self.edge = edge
    }
    
    var body: some View {
        ForceDirectedGraph(states: graphStates) {
            
            Series(0..<(width*width)) { i in
                let _i = Double(i / width) / Double(width)
                let _j = Double(i % width) / Double(width)
                NodeMark(id: i)
                    .foregroundStyle(Color(red: 1, green: _i, blue: _j))
                    .stroke()
            }
            
            Series(edge) { from, to in
                LinkMark(from: from, to: to)
            }
            
        } force: {
            .link(
                originalLength: 0.8,
                stiffness: .weightedByDegree { _, _ in 1.0 }
            )
            .manyBody(strength: -0.8)
        }
        .graphOverlay(content: { proxy in
            Rectangle().fill(.clear).contentShape(Rectangle())
                .withGraphDragGesture(proxy, of: Int.self)
        })
        .toolbar {
            GraphStateToggle(graphStates: graphStates)
        }
        
    }
}
