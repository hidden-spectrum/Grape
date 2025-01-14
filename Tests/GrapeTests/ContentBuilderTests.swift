
import XCTest
import simd
import SwiftUI

@testable import Grape



final class ContentBuilderTests: XCTestCase {
    func buildGraph<NodeID>(
        @GraphContentBuilder<NodeID> _ builder: () -> some GraphContent<NodeID>
    ) -> some GraphContent where NodeID: Hashable {
        let result = builder()
        return result
    }

    func testForLoop() {
        let _ = buildGraph {
            Series(0..<10) { i in
                NodeMark(id: i)
            }
        }
    }

    func testMixed() {
        let _ = buildGraph {
            LinkMark(from: 0, to: 1)
            
            NodeMark(id: 3)
            NodeMark(id: 4)
            // AnyGraphContent(
            //     NodeMark(id: 5)
            // )
        }
    }

    func testConditional() {
        // let _ = buildGraph {
        //     if true {
        //         NodeMark(id: 0)
        //     } else {
        //         NodeMark(id: 1)
        //     }
        // }
    }

    struct ID: Identifiable {
        var id: Int
    }

    func testForEach() {
        let arr = [
            ID(id: 0),
            ID(id: 1),
            ID(id: 2),
        ]

        let _ = buildGraph {
            Series(arr) { i in
                NodeMark(id: i.id)
            }
        }
    }

    func testComposing() {
        struct MyGraphContent: GraphContent {
            var body: some GraphContent<Int> {
                NodeMark(id: 1)
                AnnotationNodeMark(id: 3, radius: 4.0) {
                    EmptyView()
                }
            }
        }

        let _ = buildGraph {
            MyGraphContent()
        }
    }
}