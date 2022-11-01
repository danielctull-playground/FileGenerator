
import Foundation

struct BuiltinFile {

    private let _write: (URL, EnvironmentValues) throws -> Void

    init(write: @escaping (URL, EnvironmentValues) throws -> Void) {
        _write = write
    }

    func write(in directory: URL, environment: EnvironmentValues) throws {
        try _write(directory, environment)
    }
}

extension BuiltinFile: File {

    var body: Never { fatalError("Builtin body should not be called.") }
}
