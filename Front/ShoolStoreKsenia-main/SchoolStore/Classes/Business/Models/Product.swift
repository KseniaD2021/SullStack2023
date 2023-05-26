 

import Foundation

struct Product: Decodable, Hashable, Equatable {
    let id: Int
    let title: String
    let department: String
    let price: Int
    let bagde: String
    let bagdeColor: String
    let preview: String
    let images: [String]?
    let sizeValue: String
    let isAvaliableSize: Bool
    let description: String
    let details: [String]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: CodingKeys.id)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        department = try container.decode(String.self, forKey: CodingKeys.department)
        price = try container.decode(Int.self, forKey: CodingKeys.price)
        bagde = try container.decode(String.self, forKey: CodingKeys.bagde)
        preview = try container.decode(String.self, forKey: CodingKeys.preview) // вопрос
        images = ["https://fanatics.frgimages.com/FFImage/thumb.aspx?i=/productimages/_3888000/altimages/ff_3888062-f848e302bef4a86eff9aalt3_full.jpg&w=900"] //try container.decodeIfPresent([String].self, forKey: CodingKeys.images) ?? []
        description = try container.decode(String.self, forKey: CodingKeys.description)
        details = try? container.decode([String].self, forKey: CodingKeys.details)
        bagdeColor = try container.decode(String.self, forKey: CodingKeys.bagdeColor)
        sizeValue = try container.decode(String.self, forKey: CodingKeys.sizeValue)
        isAvaliableSize = try container.decode(Bool.self, forKey: CodingKeys.isAvaliableSize)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, department, price, bagde, preview, images, sizeValue, description, details, bagdeColor, isAvaliableSize
    }
}
