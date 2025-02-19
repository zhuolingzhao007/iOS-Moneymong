import UIKit

public enum Scene {
  case main // 메인화면
  case login // 로그인화면
  case ledger // 장부화면
  case createManualLedger(Int) // 운영비 등록화면
  case agency // 소속화면
}

public protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get set }
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }

  func remove() // 자기자신을 부모의 childCoordinators 스택에서 제거
  func move(to scene: Scene) // 특정 화면으로 이동 (부모에게 요청)
}

public extension Coordinator {
  func remove() {
    parentCoordinator?.childCoordinators.removeAll { $0 === self }
  }

  func move(to scene: Scene) {
    // empty
  }
}
