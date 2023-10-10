# Grape

![swift workflow](https://github.com/li3zhen1/Grape/actions/workflows/swift.yml/badge.svg)


A visualization-purposed force simulation library.




<img width="712" alt="ForceDirectedGraphLight" src="https://github.com/li3zhen1/Grape/assets/45376537/e0e8049d-25c2-4e5c-9623-6bf43ddddfa5">

#### Examples

This is a force directed graph visualizing the data from [Force Directed Graph Component](https://observablehq.com/@d3/force-directed-graph-component), running at 120FPS on a SwiftUI Canvas. Take a closer look at the animation:

https://github.com/li3zhen1/Grape/assets/45376537/5f57c223-0126-428a-a72d-d9a3ed38059d



#### Features

|   | Status (2D) | Status (3D) | Metal |
| --- | --- | --- | --- |
| **NdTree** | ✅ | 🚧 |  |
| **Simulation** | ✅ | 🚧 | 🚧 |
| &emsp;LinkForce | ✅ |   |  |
| &emsp;ManyBodyForce | ✅ |  |  |
| &emsp;CenterForce | ✅ |  |  |
| &emsp;CollideForce | ✅ |  |  |
| &emsp;PositionForce | ✅ |  |  |
| &emsp;RadialForce | ✅ |  |  |
| **SwiftUI View** | 🚧 |  |  |


#### Usage

```swift
import ForceSimulation

// nodes with unique id
let nodes: [Identifiable] = ... 

// links with source and target, ID should be the same as the type of the id
let links: [(ID, ID)] = ... 

let sim = Simulation(nodes: nodes, alphaDecay: 0.0005)
sim.createManyBodyForce(strength: -30)
sim.createLinkForce(links: links, originalLength: .constant(35))
sim.createCenterForce(center: .zero, strength: 0.1)
sim.createCollideForce(radius: .constant(5))

```

See [Example](https://github.com/li3zhen1/Grape/tree/main/Examples/GrapeView) for more details.

#### Perfomance

Currently it takes 0.046 seconds to iterate 120 times over the example graph (with 77 vertices, 254 edges, with manybody, center and link forces, release build, on a 32GB M1 Max).
