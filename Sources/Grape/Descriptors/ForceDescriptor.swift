import ForceSimulation
import simd

public enum NodeAttribute<NodeID: Hashable, Attribute> {
    case varied((NodeID) -> Attribute)
    case constant(Attribute)
}

extension NodeAttribute {
    @inlinable
    func makeCompactRepresentation(nodeIDs: [NodeID]) -> ForceSimulation.AttributeDescriptor<Attribute> {
        switch self {
        case .constant(let value):
            return .constant(value)
        case .varied(let f):
            return .varied { node in
                f(nodeIDs[node])
            }
        }
    }
}


public protocol _ForceDescriptor<NodeID> {
    associatedtype NodeID: Hashable

    func _makeForceField(forceField: inout SealedForce2D, nodeIDs: [NodeID])
    func _makeDescriptor(descriptor: inout SealedForceDescriptor<NodeID>)
}

public struct SealedForceDescriptor<NodeID: Hashable>: _ForceDescriptor {
    public func _makeDescriptor(descriptor: inout SealedForceDescriptor<NodeID>) {
        for entry in storage {
            descriptor.storage.append(entry)
        }
    }

    @usableFromInline
    enum Entry {
        case center(CenterForce<NodeID>)
        case link(LinkForce<NodeID>)
        case manyBody(ManyBodyForce<NodeID>)
        case position(PositionForce<NodeID>)
        case collide(CollideForce<NodeID>)
        case radial(RadialForce<NodeID>)
    }

    @usableFromInline
    var storage: [Entry]

    @inlinable
    public func _makeForceField(forceField: inout ForceSimulation.SealedForce2D, nodeIDs: [NodeID]) {
        storage.forEach {
            switch $0 {
            case .center(let descriptor):
                descriptor._makeForceField(forceField: &forceField, nodeIDs: nodeIDs)
            case .link(let descriptor):
                descriptor._makeForceField(forceField: &forceField, nodeIDs: nodeIDs)
            case .manyBody(let descriptor):
                descriptor._makeForceField(forceField: &forceField, nodeIDs: nodeIDs)
            case .position(let descriptor):
                descriptor._makeForceField(forceField: &forceField, nodeIDs: nodeIDs)
            case .collide(let descriptor):
                descriptor._makeForceField(forceField: &forceField, nodeIDs: nodeIDs)
            case .radial(let descriptor):
                descriptor._makeForceField(forceField: &forceField, nodeIDs: nodeIDs)
            }
        }
    }


    @inlinable
    @discardableResult
    public static func center(x: Double = 0.0, y: Double = 0.0, strength: Double = 0.5) -> Self {
        SealedForceDescriptor([.center(CenterForce(x: x, y: y, strength: strength))])
    }

    @inlinable
    @discardableResult
    public static func manyBody(strength: Double = -30.0, mass: ManyBodyForce<NodeID>.NodeMass = .constant(1.0), theta: Double = 0.9) -> Self {
        SealedForceDescriptor([.manyBody(ManyBodyForce(strength: strength, mass: mass, theta: theta))])
    }

    @inlinable
    @discardableResult
    public static func link(
        originalLength: LinkForce<NodeID>.LinkLength = .constant(30.0),
        stiffness: LinkForce<NodeID>.Stiffness = .weightedByDegree { _, _ in 1.0 },
        iterationsPerTick: UInt = 1
    ) -> Self {
        SealedForceDescriptor([.link(LinkForce(originalLength: originalLength, stiffness: stiffness, iterationsPerTick: iterationsPerTick))])
    }

    @inlinable
    @discardableResult
    public static func collide(
        strength: Double = 0.5,
        radius: CollideForce<NodeID>.CollideRadius = .constant(3.0),
        iterationsPerTick: UInt = 1
    ) -> Self {
        SealedForceDescriptor([.collide(CollideForce(strength: strength, radius: radius, iterationsPerTick: iterationsPerTick))])
    }

    @inlinable
    @discardableResult
    public static func position(
        direction: Kinetics2D.DirectionOfPositionForce,
        targetOnDirection: PositionForce<NodeID>.TargetOnDirection,
        strength: PositionForce<NodeID>.PositionStrength = .constant(1.0)
    ) -> Self {
        SealedForceDescriptor([.position(PositionForce(direction: direction, targetOnDirection: targetOnDirection, strength: strength))])
    }

    @inlinable
    @discardableResult
    public static func radial(
        center: SIMD2<Double> = .zero,
        strength: RadialForce<NodeID>.RadialStrength = .constant(1.0),
        radius: RadialForce<NodeID>.Radius = .constant(3.0)
    ) -> Self {
        SealedForceDescriptor([.radial(RadialForce(center: center, strength: strength, radius: radius))])
    }


    @inlinable
    @discardableResult
    public consuming func center(x: Double = 0.0, y: Double = 0.0, strength: Double = 0.5) -> Self {
        storage.append(.center(CenterForce(x: x, y: y, strength: strength)))
        return self
    }

    @inlinable
    @discardableResult
    public consuming func manyBody(strength: Double = -30.0, mass: ManyBodyForce<NodeID>.NodeMass = .constant(1.0), theta: Double = 0.9) -> Self {
        storage.append(.manyBody(ManyBodyForce(strength: strength, mass: mass, theta: theta)))
        return self
    }

    @inlinable
    @discardableResult
    public consuming func link(
        originalLength: LinkForce<NodeID>.LinkLength = .constant(30.0),
        stiffness: LinkForce<NodeID>.Stiffness = .weightedByDegree { _, _ in 1.0 },
        iterationsPerTick: UInt = 1
    ) -> Self{
        storage.append(.link(LinkForce(originalLength: originalLength, stiffness: stiffness, iterationsPerTick: iterationsPerTick)))
        return self
    }

    @inlinable
    @discardableResult
    public consuming func collide(
        strength: Double = 0.5,
        radius: CollideForce<NodeID>.CollideRadius = .constant(3.0),
        iterationsPerTick: UInt = 1
    ) -> Self {
        storage.append(.collide(CollideForce(strength: strength, radius: radius, iterationsPerTick: iterationsPerTick)))
        return self
    }

    @inlinable
    @discardableResult
    public consuming func position(
        direction: Kinetics2D.DirectionOfPositionForce,
        targetOnDirection: PositionForce<NodeID>.TargetOnDirection,
        strength: PositionForce<NodeID>.PositionStrength = .constant(1.0)
    ) -> Self{
        storage.append(.position(PositionForce(direction: direction, targetOnDirection: targetOnDirection, strength: strength)))
        return self
    }

    @inlinable
    @discardableResult
    public consuming func radial(
        center: SIMD2<Double> = .zero,
        strength: RadialForce<NodeID>.RadialStrength = .constant(1.0),
        radius: RadialForce<NodeID>.Radius = .constant(3.0)
    ) -> Self{
        storage.append(.radial(RadialForce(center: center, strength: strength, radius: radius)))
        return self
    }


    @inlinable
    init(_ storage: [Entry] = []) {
        self.storage = storage
    }

}

@resultBuilder
public struct SealedForceDescriptorBuilder<NodeID: Hashable> {
    public static func buildPartialBlock<FD: _ForceDescriptor<NodeID>>(first: FD) -> SealedForceDescriptor<NodeID> {
        var descriptor = SealedForceDescriptor<NodeID>()
        first._makeDescriptor(descriptor: &descriptor)
        return descriptor
    }

    public static func buildPartialBlock(
        accumulated: some _ForceDescriptor<NodeID>, next: some _ForceDescriptor<NodeID>
    ) -> SealedForceDescriptor<NodeID> {
        var descriptor = SealedForceDescriptor<NodeID>()
        accumulated._makeDescriptor(descriptor: &descriptor)
        next._makeDescriptor(descriptor: &descriptor)
        return descriptor
    }
}

public struct CenterForce<NodeID: Hashable>: _ForceDescriptor {
    public var x: Double
    public var y: Double
    public var strength: Double

    @inlinable
    public init(
        x: Double = 0.0,
        y: Double = 0.0,
        strength: Double = 0.5
    ) {
        self.x = x
        self.y = y
        self.strength = strength
    }

    @inlinable
    public func _makeForceField(forceField: inout ForceSimulation.SealedForce2D, nodeIDs: [NodeID]) {
        let force = Kinetics2D.CenterForce(center: [x, y], strength: strength)
        forceField.entries.append(.center(force))
    }

    @inlinable
    public func _makeDescriptor(descriptor: inout SealedForceDescriptor<NodeID>) {
        descriptor.storage.append(.center(self))
    }
}

public struct ManyBodyForce<NodeID: Hashable>: _ForceDescriptor {

    public typealias NodeMass = NodeAttribute<NodeID, Double>

    public var strength: Double
    public var mass: NodeMass
    public var theta: Double
    @inlinable
    public init(
        strength: Double = -30.0,
        mass: NodeMass = .constant(1.0),
        theta: Double = 0.9
    ) {
        self.strength = strength
        self.mass = mass
        self.theta = theta
    }

    @inlinable
    public func _makeForceField(forceField: inout ForceSimulation.SealedForce2D, nodeIDs: [NodeID]) {
        let compactMass: Kinetics2D.NodeMass = mass.makeCompactRepresentation(nodeIDs: nodeIDs)
        let force = Kinetics2D.ManyBodyForce(
            strength: strength, nodeMass: compactMass, theta: theta
        )
        forceField.entries.append(.manyBody(force))
    }

    @inlinable
    public func _makeDescriptor(descriptor: inout SealedForceDescriptor<NodeID>) {
        descriptor.storage.append(.manyBody(self))
    }

}

public struct LinkForce<NodeID: Hashable>: _ForceDescriptor {

    public enum Stiffness {
        case constant(Double)
        case weightedByDegree((EdgeID<NodeID>, LinkLookup<NodeID>) -> Double)
    }

    public enum LinkLength {
        case constant(Double)
        case varied((EdgeID<NodeID>, LinkLookup<NodeID>) -> Double)
    }
    public var stiffness: Stiffness
    public var originalLength: LinkLength
    public var iterationsPerTick: UInt

    @usableFromInline var links: [EdgeID<NodeID>]

    @inlinable
    public init(
        originalLength: LinkLength = .constant(30.0),
        stiffness: Stiffness = .weightedByDegree { _, _ in 1.0 },
        iterationsPerTick: UInt = 1
    ) {
        self.stiffness = stiffness
        self.originalLength = originalLength
        self.iterationsPerTick = iterationsPerTick
        self.links = []
    }

    @inlinable
    public func _makeForceField(forceField: inout ForceSimulation.SealedForce2D, nodeIDs: [NodeID]) {

        let mappedLookup = LinkLookup<NodeID>(links: links)
        let compactStiffness: Kinetics2D.LinkStiffness =
            switch stiffness {
            case .constant(let value):
                .constant(value)
            case .weightedByDegree(let f):
                .weightedByDegree { edge, _ in
                    let mappedEdge = EdgeID(
                        source: nodeIDs[edge.source], target: nodeIDs[edge.target]
                    )
                    return f(mappedEdge, mappedLookup)
                }
            }

        let compactLength: Kinetics2D.LinkLength =
            switch originalLength {
            case .constant(let value):
                .constant(value)
            case .varied(let f):
                .varied { edge, _ in
                    let mappedEdge = EdgeID(
                        source: nodeIDs[edge.source], target: nodeIDs[edge.target]
                    )
                    return f(mappedEdge, mappedLookup)
                }
            }

        let force = Kinetics2D.LinkForce(
            stiffness: compactStiffness, originalLength: compactLength, iterationsPerTick: iterationsPerTick
        )
        forceField.entries.append(.link(force))
    }

    @inlinable
    public func _makeDescriptor(descriptor: inout SealedForceDescriptor<NodeID>) {
        descriptor.storage.append(.link(self))
    }
}

public struct CollideForce<NodeID: Hashable>: _ForceDescriptor {

    public typealias CollideRadius = NodeAttribute<NodeID, Double>

    public var strength: Double
    public var radius: CollideRadius = .constant(3.0)
    public var iterationsPerTick: UInt = 1

    @inlinable
    public init(
        strength: Double = 0.5,
        radius: CollideRadius = .constant(3.0),
        iterationsPerTick: UInt = 1
    ) {
        self.strength = strength
        self.radius = radius
        self.iterationsPerTick = iterationsPerTick
    }

    @inlinable
    public func _makeForceField(forceField: inout ForceSimulation.SealedForce2D, nodeIDs: [NodeID]) {
        let compactRadius: Kinetics2D.CollideRadius = radius.makeCompactRepresentation(nodeIDs: nodeIDs)

        let force = Kinetics2D.CollideForce(
            radius: compactRadius, strength: strength, iterationsPerTick: iterationsPerTick
        )
        forceField.entries.append(.collide(force))
    }

    @inlinable
    public func _makeDescriptor(descriptor: inout SealedForceDescriptor<NodeID>) {
        descriptor.storage.append(.collide(self))
    }
}

public struct PositionForce<NodeID: Hashable>: _ForceDescriptor {

    public typealias PositionStrength = NodeAttribute<NodeID, Double>
    public typealias TargetOnDirection = NodeAttribute<NodeID, Double>
    public typealias DirectionOfPositionForce = Kinetics2D.DirectionOfPositionForce

    public var strength: PositionStrength
    public var targetOnDirection: TargetOnDirection
    public var direction: Kinetics2D.DirectionOfPositionForce
    @inlinable
    public init(
        direction: Kinetics2D.DirectionOfPositionForce,
        targetOnDirection: TargetOnDirection,
        strength: PositionStrength = .constant(1.0)
    ) {
        self.strength = strength
        self.direction = direction
        self.targetOnDirection = targetOnDirection
    }
    @inlinable
    public func _makeForceField(forceField: inout ForceSimulation.SealedForce2D, nodeIDs: [NodeID]) {
        let compactStrength: Kinetics2D.PositionStrength = strength.makeCompactRepresentation(nodeIDs: nodeIDs)
        let compactTargetOnDirection: Kinetics2D.TargetOnDirection = targetOnDirection.makeCompactRepresentation(nodeIDs: nodeIDs)
        let force = Kinetics2D.PositionForce(
            direction: direction, targetOnDirection: compactTargetOnDirection, strength: compactStrength
        )
        forceField.entries.append(.position(force))
    }

    @inlinable
    public func _makeDescriptor(descriptor: inout SealedForceDescriptor<NodeID>) {
        descriptor.storage.append(.position(self))
    }
}

public struct RadialForce<NodeID: Hashable>: _ForceDescriptor {
    public typealias Radius = NodeAttribute<NodeID, Double>
    public typealias RadialStrength = NodeAttribute<NodeID, Double>

    public var strength: RadialStrength
    public var radius: Radius = .constant(3.0)
    public var center: SIMD2<Double> = .zero
    public var iterationsPerTick: UInt = 1

    @inlinable
    public init(
        center: SIMD2<Double> = .zero,
        strength: RadialStrength = .constant(1.0),
        radius: Radius = .constant(3.0)
    ) {
        self.center = center
        self.strength = strength
        self.radius = radius
    }
    @inlinable
    public func _makeForceField(forceField: inout ForceSimulation.SealedForce2D, nodeIDs: [NodeID]) {
        let compactRadius: Kinetics2D.CollideRadius = radius.makeCompactRepresentation(nodeIDs: nodeIDs)
        let compactStrength: Kinetics2D.PositionStrength = strength.makeCompactRepresentation(nodeIDs: nodeIDs)
        let force = Kinetics2D.RadialForce(
            center: center, radius: compactRadius, strength: compactStrength
        )
        forceField.entries.append(.radial(force))
    }

    @inlinable
    public func _makeDescriptor(descriptor: inout SealedForceDescriptor<NodeID>) {
        descriptor.storage.append(.radial(self))
    }
}
