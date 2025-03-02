import Foundation
import KeychainSwift

final class Keychain {
    private let keychain: KeychainSwift
    
    init() {
        keychain = KeychainSwift()
    }
    
    func set(_ value: String, forKey key: String) {
        keychain.set(value, forKey: key)
    }
    
    func get(forKey key: String) -> String? {
        keychain.get(key)
    }
    
    func delete(forKey key: String) {
        keychain.delete(key)
    }
}
