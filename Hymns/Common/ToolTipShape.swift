import SwiftUI

/**
 * Creates a rounded rectangle shape with a little arrow on the top to serve as a tool tip.
 */
struct ToolTip: Shape {

    private let cornerRadius: CGFloat
    private let toolTipMidX: CGFloat
    private let toolTipHeight: CGFloat

    init(cornerRadius: CGFloat, toolTipMidX: CGFloat, toolTipHeight: CGFloat = 40) {
        self.cornerRadius = cornerRadius
        self.toolTipMidX = toolTipMidX
        self.toolTipHeight = toolTipHeight
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height

            // Starting point
            path.move(to: CGPoint(x: cornerRadius, y: 0))

            // Top line (including caret)
            path.addLine(to: CGPoint(x: toolTipMidX - toolTipHeight, y: 0))
            path.addLine(to: CGPoint(x: toolTipMidX, y: -toolTipHeight)) // Tool tip caret
            path.addLine(to: CGPoint(x: toolTipMidX + toolTipHeight, y: 0)) // Tool tip caret
            path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))

            // Top-right corner
            path.addArc(center: CGPoint(x: width - cornerRadius, y: 0 + cornerRadius),
                        radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0),
                        clockwise: false)

            // Right line
            path.addLine(to: CGPoint(x: width, y: height - cornerRadius))

            // Bottom-right corner
            path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                        radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90),
                        clockwise: false)

            // Bottom line
            path.addLine(to: CGPoint(x: cornerRadius, y: height))

            // Bottom-left corner
            path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                        radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180),
                        clockwise: false)

            // Left line
            path.addLine(to: CGPoint(x: 0, y: cornerRadius + 0))

            // Top-left corner
            path.addArc(center: CGPoint(x: cornerRadius, y: 0 + cornerRadius),
                        radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270),
                        clockwise: false)

            path.closeSubpath()
        }
    }
}

#if DEBUG
struct ToolTip_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToolTip(cornerRadius: 15, toolTipMidX: 300).fill().previewDisplayName("filled tooltip")
            ToolTip(cornerRadius: 15, toolTipMidX: 300).stroke().previewDisplayName("outlined tooltip")
        }
    }
}
#endif
