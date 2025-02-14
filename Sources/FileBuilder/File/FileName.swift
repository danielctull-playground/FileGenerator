import Foundation

public struct FileName: Equatable, Hashable, Sendable {
    fileprivate let value: String
    public init(_ value: String) {
        self.value = value
    }
}

extension FileName: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

extension FileName: ExpressibleByStringInterpolation {}

extension URL {
    func appending(_ name: FileName) -> URL {
        appendingPathComponent(name.value)
    }
}
