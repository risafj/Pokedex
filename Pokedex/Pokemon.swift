import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
    let sprites: PokemonImage
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonImage: Codable {
    let front_default: String
}

struct PokemonDescriptionResult: Codable {
    let flavor_text_entries: [FlavorTextEntry]
}

struct FlavorTextEntry: Codable {
    let flavor_text: String
    let language: LanguageEntry
}

struct LanguageEntry: Codable {
    let name: String
}
