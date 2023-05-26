 

import Foundation

enum CatalogRequest: Request {
    case listOfProducts(offset: Int, limit: Int)
    case detailInfo(id: Int)

    // MARK: Internal

    var path: String {
        switch self {
        case .listOfProducts:
            return "products"
        case  let .detailInfo(id: id):
            return "product/\(id)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .listOfProducts, .detailInfo:
            return .get
        }
    }

    var mock: Data? {
        switch self {
        case let .listOfProducts(offset, _):
            if offset == 0 {
                guard let path = Bundle.main.path(forResource: "listOfProducts", ofType: "json"),
                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                else {
                    return nil
                }
                return data

            } else if 12 ... 24 ~= offset {
                guard let path = Bundle.main.path(forResource: "listOfProducts2", ofType: "json"),
                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                else {
                    return nil
                }
                return data

            } else {
                guard let path = Bundle.main.path(forResource: "listOfProducts3", ofType: "json"),
                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                else {
                    return nil
                }
                return data
            }
           
        case let .detailInfo(id):
//            if id == "47eae74-0242ac130002" {
//                guard let path = Bundle.main.path(forResource: "TShirtProduct", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            } else if id == "122fuuRGgh1ec-9621-0244442ac130002"{
//                guard let path = Bundle.main.path(forResource: "sneakersBlackProduct", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            } else if id == "090iio090-11ec-9621-0242a455ff3430002"{
//                guard let path = Bundle.main.path(forResource: "bagProduct", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            } else if id == "999999699-1efd-11ec-9621-0242aff3430002"{
//                guard let path = Bundle.main.path(forResource: "sneakersBlackWhiteProduct", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            } else if id == "9621-0242ac130002"{
//                guard let path = Bundle.main.path(forResource: "greenTShirtProduct", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            } else if id == "999399999-1eRwwsrxt"{
//                guard let path = Bundle.main.path(forResource: "basketBallProduct", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            } else if id == "67yyhbk-1efd3-11ec-9621-0242ac130002" {
//                guard let path = Bundle.main.path(forResource: "setGreenClothes", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            } else if id == "99tyiii99-uu-0242aff3430002"{
//                guard let path = Bundle.main.path(forResource: "blueTSHirtProduct", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            } else {
//                guard let path = Bundle.main.path(forResource: "setRedClothes", ofType: "json"),
//                      let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                else {
//                    return nil
//                }
//                return data
//            }
            return nil
        }
    }
}
