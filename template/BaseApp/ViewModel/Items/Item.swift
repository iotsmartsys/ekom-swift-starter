import Foundation

typealias ItemsResponse = [Item]

struct Item: Codable, Equatable, Identifiable {
    var uid: String = UUID().uuidString
    let id: Int?
    let name: String
    let description: String?
    let isActive: Bool
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case isActive
        case createdAt
        case updatedAt
    }

    init(
        id: Int? = nil,
        name: String,
        description: String? = nil,
        isActive: Bool = true,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.isActive = isActive
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        isActive = try container.decode(Bool.self, forKey: .isActive)

        if let createdAtString = try container.decodeIfPresent(String.self, forKey: .createdAt) {
            createdAt = Date.apiDateFormatter.date(from: createdAtString)
        } else {
            createdAt = nil
        }

        if let updatedAtString = try container.decodeIfPresent(String.self, forKey: .updatedAt) {
            updatedAt = Date.apiDateFormatter.date(from: updatedAtString)
        } else {
            updatedAt = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(isActive, forKey: .isActive)

        if let createdAt = createdAt {
            try container.encode(Date.apiDateFormatter.string(from: createdAt), forKey: .createdAt)
        } else {
            try container.encodeNil(forKey: .createdAt)
        }

        if let updatedAt = updatedAt {
            try container.encode(Date.apiDateFormatter.string(from: updatedAt), forKey: .updatedAt)
        } else {
            try container.encodeNil(forKey: .updatedAt)
        }
    }
}

struct ItemPayload: Codable {
    let name: String
    let description: String?
    let isActive: Bool
}

struct ItemFormData: Equatable {
    var id: Int?
    var name: String
    var description: String
    var isActive: Bool

    init(
        id: Int? = nil,
        name: String = "",
        description: String = "",
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.isActive = isActive
    }

    init(item: Item) {
        id = item.id
        name = item.name
        description = item.description ?? ""
        isActive = item.isActive
    }

    func makePayload() throws -> ItemPayload {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw ItemFormError.invalidName }

        let desc = description.trimmingCharacters(in: .whitespacesAndNewlines)
        return ItemPayload(name: trimmed, description: desc.isEmpty ? nil : desc, isActive: isActive)
    }

    var isEditing: Bool { id != nil }
}

enum ItemFormError: LocalizedError {
    case invalidName

    var errorDescription: String? {
        switch self {
        case .invalidName:
            return "Informe um nome para o item."
        }
    }
}

extension Item {
    var searchTokens: String {
        [name, description ?? ""].joined(separator: " ")
    }
}
