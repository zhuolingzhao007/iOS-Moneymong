import Foundation

public protocol LocalStorageInterface: AnyObject {
  @discardableResult
  func create(to key: LocalStorageKey, value: String) -> Bool
  
  func read(to key: LocalStorageKey) -> String?
  
  @discardableResult
  func delete(to key: LocalStorageKey) -> Bool
}

public final class LocalStorageManager: LocalStorageInterface {
  private let keychainHelper: KeychainHelper
  private let userDefaultHelper: UserDefaultsHelper
  
  public init(
    keychainHelper: KeychainHelper = KeychainHelper(),
    userDefaultHelper: UserDefaultsHelper = UserDefaultsHelper()
  ) {
    self.keychainHelper = keychainHelper
    self.userDefaultHelper = userDefaultHelper
  }
  
  @discardableResult
  public func create(to key: LocalStorageKey, value: String) -> Bool {
    switch key {
    case .accessToken:
      return keychainHelper.create(to: .accessToken, value: value)
    case .refreshToken:
      return keychainHelper.create(to: .refreshToken, value: value)
    case .socialAccessToken:
      return keychainHelper.create(to: .socialAccessToken, value: value)
    case .recentLoginType:
      return userDefaultHelper.saveData(newValue: value, forKey: .recentLoginType)
    case .selectedAgency:
      return userDefaultHelper.saveData(newValue: value, forKey: .selectedAgency)
    }
  }
  
  public func read(to key: LocalStorageKey) -> String? {
    switch key {
    case .accessToken:
      return keychainHelper.read(to: .accessToken)
    case .refreshToken:
      return keychainHelper.read(to: .refreshToken)
    case .socialAccessToken:
      return keychainHelper.read(to: .socialAccessToken)
    case .recentLoginType:
      return userDefaultHelper.retrieveData(forKey: .recentLoginType, type: String.self)
    case .selectedAgency:
      return userDefaultHelper.retrieveData(forKey: .selectedAgency, type: String.self)
    }
  }
  
  @discardableResult
  public func delete(to key: LocalStorageKey) -> Bool {
    switch key {
    case .accessToken:
      return keychainHelper.delete(to: .accessToken)
    case .refreshToken:
      return keychainHelper.delete(to: .refreshToken)
    case .socialAccessToken:
      return keychainHelper.delete(to: .socialAccessToken)
    case .recentLoginType:
      return userDefaultHelper.delete(forKey: .recentLoginType, type: String.self)
    case .selectedAgency:
      return userDefaultHelper.delete(forKey: .selectedAgency, type: String.self)
    }
  }
}
