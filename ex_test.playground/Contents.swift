import Foundation
// Implement mobile phone storage protocol
// Requirements:
// - Mobiles must be unique (IMEI is an unique number)
// - Mobiles must be stored in memory

protocol MobileStorage {
    func getAll() -> Set<Mobile>
    func findByImei(_ imei:String) -> Mobile?
    func save(_ mobile: Mobile)throws -> Mobile
    func delete(_ product: Mobile) throws
    func exists(_ product: Mobile) -> Bool
}
struct Mobile: Hashable {
    let imei: String
    let model: String
}
//MARK: -

enum MobileErrors: Error {
    case dataAlreadyExists
    case dataNotFound
}

class Whatever : MobileStorage {
    
    public let shared = Whatever()
    
    private var itemsMap = UserDefaults.standard.object(forKey: key) as? [String: String] ?? [:]
    private static let key = "mobileKey"
    
    
    func getAll() -> Set<Mobile> {
        var result: Set<Mobile> = .init()
        itemsMap.forEach { (key, value) in
            result.insert(.init(imei: key, model: value))
        }
        return result
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        guard let model = itemsMap[imei] else { return nil }
        return Mobile(imei: imei, model: model)
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        if itemsMap[mobile.imei] != nil  {
            throw MobileErrors.dataAlreadyExists
        } else {
            itemsMap[mobile.imei] = mobile.model
            UserDefaults.standard.set(itemsMap, forKey: Self.key)
            print("saved")
        }
            return mobile
    }

    func delete(_ product: Mobile) throws {
        if itemsMap[product.imei] != nil {
            itemsMap.removeValue(forKey: product.imei)
            UserDefaults.standard.set(itemsMap, forKey: Self.key)
            print("Item deleted")
        } else {
            throw MobileErrors.dataNotFound
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        itemsMap[product.imei] != nil
    }
    
}





