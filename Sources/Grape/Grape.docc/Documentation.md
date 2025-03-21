# ``Grape``

Construct and visualize graphs on Apple platforms.

## Overview

The Grape framework enables you to create a graph visualization in SwiftUI. With Grape, you can build effective and customizable force-directed graphs with minimal code. This framework provides nodes, links and forces as building blocks for constructing graphs. 

@Image(source: "GrapeOverview.png", alt: "A force-directed graph visualization of a small graph.")




Grape supports localization features. You can localize the labels in the graph visualization by providing a localized string key.

> If you’re looking for a more detailed control of force-directed layouts, please refer to [ForceSimulation | Documentation](https://swiftgraphs.github.io/Grape/ForceSimulation/documentation/forcesimulation/).


## Topics

### Creating a graph visualization


* <doc:CreatingAForceDirectedGraph>
* <doc:StateManagementAndEliminatingRedundantRerenders>

* ``ForceDirectedGraph``



### Describing a graph

* ``GraphContent``
* ``GraphContentBuilder``

* ``NodeMark``
* ``LinkMark``
* ``Series``
* ``GraphComponent``

### Adding interactivity
* ``GraphProxy``
* ``SwiftUICore/View/graphOverlay(alignment:content:)``
* ``SwiftUICore/View/graphBackground(alignment:content:)``
* ``SwiftUICore/View/withGraphTapGesture(_:action:)``
* ``SwiftUICore/View/withGraphDragGesture(_:action:)``
* ``SwiftUICore/View/withGraphMagnifyGesture(_:action:)``

### Managing the view state

* ``ForceDirectedGraphModel``
* ``KeyFrame``
* ``KineticState`` 
* ``TransformProtocol``
* ``ViewportTransform``

### Describing forces

* ``CenterForce``
* ``CollideForce``
* ``LinkForce``
* ``ManyBodyForce``
* ``PositionForce``
* ``RadialForce``
* ``SealedForceDescriptor``
* ``SealedForceDescriptorBuilder``

### Decorating marks

* ``GraphContentModifier``
* ``ModifiedGraphContent``
* ``AnyGraphContentModifier``
* ``StrokeColor``
* ``LinkShape``
* ``StraightLineLinkShape``
* ``PlainLineLink``
* ``ArrowLineLink``




