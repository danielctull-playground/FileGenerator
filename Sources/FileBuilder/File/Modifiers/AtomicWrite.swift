
import Foundation

extension File {

    /// Writes the contents of the file structure to a temporary directory first
    /// and then replaces the original directory with the contents on successful
    /// write.
    ///
    /// - Returns: A file that is atomically written to disk.
    public func writeAtomically() -> some File {
        modifier(AtomicWrite())
    }
}

private struct AtomicWrite<Content: File>: FileModifier {

    func body(content: Content) -> some File {
        BuiltinFile { directory, environment in
            let fileManager = FileManager()
            try fileManager.withTemporaryDirectory { temporary in
                let temporary = temporary.appendingPathComponent(directory.lastPathComponent)
                try fileManager.createDirectory(at: temporary, withIntermediateDirectories: false)
                try content.write(in: temporary, environment: environment)
                _ = try fileManager.replaceItemAt(directory, withItemAt: temporary)
            }
        }
    }
}

extension FileManager {

    fileprivate func withTemporaryDirectory(_ perform: (URL) throws -> Void) throws {
        let url = temporaryDirectory
            .appendingPathComponent("FileBuilder")
            .appendingPathComponent(UUID().uuidString)
        defer { try? removeItem(at: url) }
        try createDirectory(at: url, withIntermediateDirectories: true)
        try perform(url)
    }
}
