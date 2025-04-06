import Foundation
import RegexBuilder
import Testing

@testable import UUIDv7MCP

@Test func UUIDv7Tests() throws {
    let now = ISO8601DateFormatter().date(from: "2024-08-16T12:34:56Z")!

    let actual: UUID = .v7(now: now)

    let expected = Regex {
        "01915B2F-0D80-7"
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        "-"
        CharacterClass.anyOf("89AB")
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        "-"
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
        CharacterClass.hexDigit
    }
    let match = try expected.wholeMatch(in: actual.description)
    #expect(match != nil)
}
