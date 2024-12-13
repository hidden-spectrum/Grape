import CoreGraphics
import SwiftUI

//#if canImport(AppKit)
//    import AppKit
//    @inlinable
//    internal func getDisplayScale() -> CGFloat {
//        return NSScreen.main?.backingScaleFactor ?? 2.0
//    }
//#elseif os(xrOS)
//    @inlinable
//    internal func getDisplayScale() -> CGFloat {
//        return 2.0
//    }
//#elseif canImport(UIKit)
//    import UIKit
//    @inlinable
//    internal func getDisplayScale() -> CGFloat {
//        return UIScreen.main.scale
//    }
//#else
//    @inlinable
//    internal func getDisplayScale() -> CGFloat {
//        return 2.0
//    }
//#endif

// #if os(macOS)
//     import AppKit
//     @inlinable
//     func getCGContext() -> CGContext? {
//         return NSGraphicsContext.current?.cgContext
//     }
// #elseif os(iOS)
//     import UIKit
//     @inlinable
//     func getCGContext() -> CGContext? {
//         return UIGraphicsGetCurrentContext()
//     }
// #endif

// class CLD: NSObject, CALayerDelegate {
//     func draw(_ layer: CALayer, in ctx: CGContext) {
//         let text = "Hello World!"
//         let font = NSFont.systemFont(ofSize: 72)
//         let attributes = [NSAttributedString.Key.font: font]
//         let attributedString = NSAttributedString(string: text, attributes: attributes)
//         let line = CTLineCreateWithAttributedString(attributedString)
//         let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
//         ctx.textMatrix = .identity
//         ctx.translateBy(x: 0, y: bounds.height)
//         ctx.scaleBy(x: 1.0, y: -1.0)
//         CTLineDraw(line, ctx)
//     }
// }

extension View {
    @inlinable
    @MainActor
    internal func toCGImage(scaledBy factor: CGFloat) -> CGImage? {
        let renderer = ImageRenderer(
            content: self
        )
        renderer.scale = factor
        return renderer.cgImage
    }

    @inlinable
    @MainActor
    internal func toCGImage(with environment: EnvironmentValues) -> CGImage? {
        let renderer = ImageRenderer(
            content: self.environment(\.self, environment)
        )
        renderer.scale = environment.displayScale
        return renderer.cgImage
    }
}

extension Text {
    @inlinable
    internal func resolved() -> String {
        // This is an undocumented API
        return self._resolveText(in: Self.resolvingEnvironment)
    }

    @inlinable
    static internal var resolvingEnvironment: EnvironmentValues {
        return EnvironmentValues()
    }

}
