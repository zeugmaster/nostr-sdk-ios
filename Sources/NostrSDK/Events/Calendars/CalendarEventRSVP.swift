//
//  CalendarEventRSVP.swift
//  
//
//  Created by Terry Yiu on 12/1/23.
//

import Foundation

/// A calendar event RSVP is a response to a calendar event to indicate a user's attendance intention.
/// 
/// See [NIP-52 - Calendar Event RSVP](https://github.com/nostr-protocol/nips/blob/master/52.md#calendar-event-rsvp).
public final class CalendarEventRSVP: NostrEvent, IdentifierTagInterpreting {
    public required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    @available(*, unavailable, message: "This initializer is unavailable for this class.")
    override init(kind: EventKind, content: String, tags: [Tag] = [], createdAt: Int64 = Int64(Date.now.timeIntervalSince1970), signedBy keypair: Keypair) throws {
        try super.init(kind: kind, content: content, tags: tags, createdAt: createdAt, signedBy: keypair)
    }

    public init(content: String, tags: [Tag] = [], createdAt: Int64 = Int64(Date.now.timeIntervalSince1970), signedBy keypair: Keypair) throws {
        try super.init(kind: .calendarEventRSVP, content: content, tags: tags, createdAt: createdAt, signedBy: keypair)
    }

    /// Event coordinates to the calendar event this RSVP responds to.
    public var calendarEventCoordinates: EventCoordinates? {
        tags.compactMap { EventCoordinates(eventCoordinatesTag: $0) }
            .first { $0.kind == .dateBasedCalendarEvent || $0.kind == .timeBasedCalendarEvent }
    }

    /// The attendance status to the referenced calendar event.
    ///  Mimics the Participation Status type in the [RFC 5545 iCalendar spec](https://datatracker.ietf.org/doc/html/rfc5545#section-3.2.12).
    public var status: CalendarEventRSVPStatus? {
        guard let statusTag = tags.first(where: { $0.name == TagName.label.rawValue && $0.otherParameters.first == "status" }) else {
            return nil
        }

        return CalendarEventRSVPStatus(rawValue: statusTag.value)
    }

    /// Whether the user is free or busy for the duration of the calendar event.
    /// Mimics the Free/Busy Time Type in the [RFC 5545 iCalendar spec](https://datatracker.ietf.org/doc/html/rfc5545#section-3.2.9).
    public var freebusy: CalendarEventRSVPFreebusy? {
        guard let freebusyTag = tags.first(where: { $0.name == TagName.label.rawValue && $0.otherParameters.first == "freebusy" }) else {
            return nil
        }

        return CalendarEventRSVPFreebusy(rawValue: freebusyTag.value)
    }
}
