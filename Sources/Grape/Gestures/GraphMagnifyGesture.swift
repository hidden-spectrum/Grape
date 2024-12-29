import SwiftUI

#if os(iOS) || os(macOS)
    public struct GraphMagnifyModifier: ViewModifier {

        @usableFromInline
        let proxy: GraphProxy

        @usableFromInline
        let action: (() -> Void)?

        @inlinable
        init(_ proxy: GraphProxy, action: (() -> Void)? = nil) {
            self.proxy = proxy
            self.action = action
        }

        @inlinable
        public func body(content: Content) -> some View {
            content.gesture(gesture)
        }

        @inlinable
        public var gesture: some Gesture {
            MagnifyGesture(minimumScaleDelta: Self.minimumScaleDelta)
                .onChanged(onMagnifyChange)
                .onEnded(onMagnifyEnd)
        }

        @inlinable
        static var minimumScaleDelta: CGFloat { 0.001 }

        @inlinable
        static var minimumScale: CGFloat { 1e-2 }

        @inlinable
        static var maximumScale: CGFloat { .infinity }

        @inlinable
        static var magnificationDecay: CGFloat { 0.1 }

        @inlinable
        internal func clamp(
            _ value: CGFloat,
            min: CGFloat,
            max: CGFloat
        ) -> CGFloat {
            Swift.min(Swift.max(value, min), max)
        }

        @inlinable
        internal func onMagnifyChange(
            _ value: MagnifyGesture.Value
        ) {
            var startTransform: ViewportTransform
            if let t = self.proxy.lastTransformRecord {
                startTransform = t
            } else {
                self.proxy.lastTransformRecord = self.proxy.modelTransform
                startTransform = self.proxy.modelTransform
            }

            let alpha = (startTransform.translate(by: self.proxy.obsoleteState.cgSize.simd / 2))
                .invert(value.startLocation.simd)

            let newScale = clamp(
                value.magnification * startTransform.scale,
                min: Self.minimumScale,
                max: Self.maximumScale)

            let newTranslate = (startTransform.scale - newScale) * alpha + startTransform.translate

            let newModelTransform = ViewportTransform(
                translate: newTranslate,
                scale: newScale
            )
            self.proxy.modelTransform = newModelTransform

            // guard let action = self.proxy._onGraphMagnified else { return }
            // action()
        }

        @inlinable
        internal func onMagnifyEnd(
            _ value: MagnifyGesture.Value
        ) {
            var startTransform: ViewportTransform
            if let t = self.proxy.lastTransformRecord {
                startTransform = t
            } else {
                self.proxy.lastTransformRecord = self.proxy.modelTransform
                startTransform = self.proxy.modelTransform
            }

            let alpha = (startTransform.translate(by: self.proxy.obsoleteState.cgSize.simd / 2))
                .invert(value.startLocation.simd)

            let newScale = clamp(
                value.magnification * startTransform.scale,
                min: Self.minimumScale,
                max: Self.maximumScale)

            let newTranslate = (startTransform.scale - newScale) * alpha + startTransform.translate
            let newModelTransform = ViewportTransform(
                translate: newTranslate,
                scale: newScale
            )
            self.proxy.lastTransformRecord = nil
            self.proxy.modelTransform = newModelTransform

            if let action {
                action()
            }
        }
    }

    extension View {
        @inlinable
        public func withGraphMagnifyGesture(
            _ proxy: GraphProxy,
            action: (() -> Void)? = nil
        ) -> some View {
            self.modifier(GraphMagnifyModifier(proxy, action: action))
        }
    }

#endif
