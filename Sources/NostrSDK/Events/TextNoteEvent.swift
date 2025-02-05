//
//  TextNoteEvent.swift
//  
//
//  Created by Bryan Montz on 7/23/23.
//

import Foundation

/// An event that contains plaintext content.
///
/// > Note: [NIP-01 Specification](https://github.com/nostr-protocol/nips/blob/b503f8a92b22be3037b8115fe3e644865a4fa155/01.md#basic-event-kinds)
public final class TextNoteEvent: NostrEvent, CustomEmojiInterpreting {
    
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    @available(*, unavailable, message: "This initializer is unavailable for this class.")
    override init(kind: EventKind, content: String, tags: [Tag] = [], createdAt: Int64 = Int64(Date.now.timeIntervalSince1970), signedBy keypair: Keypair) throws {
        try super.init(kind: kind, content: content, tags: tags, createdAt: createdAt, signedBy: keypair)
    }
    
    init(content: String, tags: [Tag] = [], createdAt: Int64 = Int64(Date.now.timeIntervalSince1970), signedBy keypair: Keypair) throws {
        try super.init(kind: .textNote, content: content, tags: tags, createdAt: createdAt, signedBy: keypair)
    }
    
    /// Pubkeys mentioned in the note content.
    public var mentionedPubkeys: [String] {
        allValues(forTagName: .pubkey) ?? []
    }
    
    /// Events mentioned in the note content.
    public var mentionedEventIds: [String] {
        allValues(forTagName: .event) ?? []
    }
    
    /// a short subject for a text note, similar to subjects in emails.
    ///
    /// See [NIP-14 - Subject tag in Text events](https://github.com/nostr-protocol/nips/blob/master/14.md).
    public var subject: String? {
        firstValueForTagName(.subject)
    }
}
