import Foundation

import NetworkService

import RxDataSources

/// TableView Section, Row에 사용
struct MyPageSectionItemModel {
  typealias Model = SectionModel<Section, Item>
  
  enum Section: Equatable {
    case account(UserInfo)
    case setting(String)
  }
  
  enum Item: Equatable {
    case university(UserInfo)
    case setting(SettingItem)
  }
  
  let model: Section
  let items: [Item]
}
