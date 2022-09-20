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
    private var itemsMap : [String: Mobile]
    private let key = "mobileKey"
    
    init() {
        itemsMap = UserDefaults.standard.object(forKey: key) as? [String:Mobile] ?? [:]
    }
    
     func getAll() -> Set<Mobile> {
         Set<Mobile>(itemsMap.values)
    }
    
    func findByImei(_ imei: String) -> Mobile? {
        itemsMap[imei]
    }
    
    func save(_ mobile: Mobile) throws -> Mobile {
        if itemsMap[mobile.imei] != nil  {
            throw MobileErrors.dataAlreadyExists
        } else {
            itemsMap[mobile.imei] = mobile
            UserDefaults.standard.set(itemsMap, forKey: key)
        }
            return mobile
    }
    
    func delete(_ product: Mobile) throws {
        if itemsMap[product.imei] != nil {
            itemsMap.removeValue(forKey: product.imei)
            UserDefaults.standard.set(itemsMap, forKey: key)
        } else {
            throw MobileErrors.dataNotFound
        }
    }
    
    func exists(_ product: Mobile) -> Bool {
        itemsMap[product.imei] != nil
    }
    
    
    let mobile1 = Mobile(imei: "12312313", model: "1231231231")
    
}




