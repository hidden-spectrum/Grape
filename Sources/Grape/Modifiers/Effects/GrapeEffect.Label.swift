import SwiftUI

extension GraphContentEffect {
    @usableFromInline
    internal struct Label {

        @usableFromInline
        let text: Text

        @usableFromInline
        let alignment: Alignment


        @inlinable
        public init(
            _ text: Text,
            alignment: Alignment = .bottomLeading
        ) {
            self.text = text
            self.alignment = alignment
        }
    }

}

extension GraphContentEffect.Label: GraphContentModifier {
    @inlinable
    public func _into<NodeID>(
        _ context: inout _GraphRenderingContext<NodeID>
    ) where NodeID: Hashable {

    }

    @inlinable
    @MainActor
    public func _exit<NodeID>(_ context: inout _GraphRenderingContext<NodeID>)
    where NodeID: Hashable {
        if let currentID = context.states.currentID {
            let resolvedText = text.resolved()
            context.resolvedTexts[currentID] = resolvedText
            context.symbols[resolvedText] = .pending(text)
        }
    }
}
