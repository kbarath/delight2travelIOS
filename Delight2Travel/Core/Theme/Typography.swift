import SwiftUI

enum AppTypography {
    static func title() -> Font { .system(size: 24, weight: .bold) }
    static func headline() -> Font { .system(size: 18, weight: .semibold) }
    static func body() -> Font { .system(size: 16, weight: .regular) }
    static func caption() -> Font { .system(size: 14, weight: .regular) }
    static func label() -> Font { .system(size: 12, weight: .medium) }
}
