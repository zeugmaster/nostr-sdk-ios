import Foundation
import XCTest
@testable import NostrSDK

final class RelaySessionTests: XCTestCase {
    private final class RecordingSession: URLSession, @unchecked Sendable {
        var urls: [URL] = []
        private let backing = URLSession(configuration: .ephemeral)
        override func webSocketTask(with url: URL) -> URLSessionWebSocketTask {
            urls.append(url)
            // Tasks stay suspended: this test never contacts a relay.
            return backing.webSocketTask(with: url)
        }
    }

    func testDisconnectAndReconnectPreparationUseCallerSession() throws {
        let session = RecordingSession()
        let url = URL(string: "wss://relay.invalid")!
        let relay = try Relay(url: url, session: session)
        XCTAssertTrue(session.urls.isEmpty)
        relay.socket.disconnect()
        XCTAssertEqual(session.urls, [url, url])
        relay.socket.disconnect()
        XCTAssertEqual(session.urls, [url, url, url])
    }
}
