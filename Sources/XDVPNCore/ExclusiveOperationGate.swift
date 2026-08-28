import Foundation

/// A process-local serialization boundary for synchronous side effects.
/// XDVPN uses one gate for every privileged tunnel cleanup/connect mutation.
public final class ExclusiveOperationGate: @unchecked Sendable {
    private let lock = NSLock()

    public init() {}

    public func perform<T>(_ operation: () throws -> T) rethrows -> T {
        lock.lock()
        defer { lock.unlock() }
        return try operation()
    }
}
