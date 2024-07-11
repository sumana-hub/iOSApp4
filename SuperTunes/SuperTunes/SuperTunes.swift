// Codable class to parse the top-level JSON response from iTunes API
class ResultArray: Codable {
    var resultCount = 0
    var results = [SuperTunes]()
}

// Codable and CustomStringConvertible class to parse individual search results
class SuperTunes: Codable, CustomStringConvertible {
    var trackName: String? = ""
    var artistName: String? = ""
    
    // Computed property to return the track or collection name
    var name: String {
        return trackName ?? collectionName ?? ""
    }

    // Computed property to return a custom string description of the object
    var description: String {
        return "\nResult - Kind: \(kind ?? "None"), Track Name: \(name), Artist Name: \(artistName ?? "None")"
    }

    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""

    var trackViewUrl: String?
    var collectionName: String?
    var collectionViewUrl: String?
    var collectionPrice: Double?
    var itemPrice: Double?
    var itemGenre: String?
    var bookGenre: [String]?

    // Computed property to return the appropriate URL for the item
    var storeURL: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }

    // Computed property to return the appropriate price for the item
    var price: Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }

    // Computed property to return the appropriate genre for the item
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }

    // Computed property to return the appropriate type for the item based on its kind
    var type: String {
        let kind = self.kind ?? "audiobook"
        switch kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "E-Book"
        case "feature-movie": return "Movie"
        case "music-video": return "Music Video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: break
        }
        return "Unknown"
    }

    // Computed property to return the artist name
    var artist: String {
        return artistName ?? ""
    }

    // Enum to map JSON keys to properties
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }
}

// Overloading the < operator to sort SuperTunes objects by name
func < (lhs: SuperTunes, rhs: SuperTunes) -> Bool {
    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
}

