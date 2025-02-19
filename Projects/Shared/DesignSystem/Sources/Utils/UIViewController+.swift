import UIKit

// 나중에 BaseVC로 옮길예정
public extension UIViewController {
  enum BarItem {
    case back
    case backWhite
    case closeBlack
    case closeWhite
    case trash
    case 수정완료
    case 등록하기
    case warning
    case none

    var button: UIBarButtonItem {
      let button = UIBarButtonItem()
      
      switch self {
      case .back:
        button.image = Images.chevronLeft?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.Gray._7
      case .backWhite:
        button.image = Images.chevronLeft?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.White._1
      case .closeBlack:
        button.image = Images.close?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.Gray._7
      case .closeWhite:
        button.image = Images.close?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.White._1
      case .trash:
        button.image = Images.trash?.withRenderingMode(.alwaysTemplate)
        button.tintColor = Colors.Gray._7
      case .수정완료:
        button.title = "수정완료"
        button.setTitleTextAttributes([.font: Fonts.body._3], for: .normal)
        button.setTitleTextAttributes([.font: Fonts.body._3], for: .disabled)
        button.tintColor = Colors.Blue._4
      case .none:
        button.image = UIImage()
      case .warning:
        button.image = Images.warning?.withRenderingMode(.alwaysTemplate)
        button.tintColor = .white
      case .등록하기:
        button.title = "등록하기"
        button.setTitleTextAttributes([.font: Fonts.body._3], for: .normal)
        button.tintColor = Colors.Blue._4
      }
      
      return button
    }
  }
  
  func setTitle(_ title: String, color: UIColor = Colors.Gray._10, font: UIFont = Fonts.heading._1) {
    let label = UILabel()
    label.text = title
    label.textColor = color
    label.font = font
    
    navigationItem.titleView = label
  }
  
  func setTitle(_ titleView: UIView) {
    navigationItem.titleView = titleView
  }
  
  func setLeftItem(_ item: BarItem, color: UIColor? = nil) {
    navigationItem.leftBarButtonItem = item.button
    
    if let color {
      navigationItem.rightBarButtonItem?.tintColor = color
    }
  }
  
  func setRightItem(_ item: BarItem, color: UIColor? = nil) {
    navigationItem.rightBarButtonItem = item.button
    
    if let color {
      navigationItem.rightBarButtonItem?.tintColor = color
    }
  }
  
  func topViewController() -> UIViewController {
    return searchTopViewController(of: self)
  }
  
  private func searchTopViewController(of viewController: UIViewController) -> UIViewController {
    if let presentedViewController = viewController.presentedViewController {
      return searchTopViewController(of: presentedViewController)
    }
    if let navigationViewController = viewController as? UINavigationController,
       let topViewController = navigationViewController.topViewController {
      return searchTopViewController(of: topViewController)
    }
    if let tabBarController = viewController as? UITabBarController,
       let selectedViewController = tabBarController.selectedViewController {
      return searchTopViewController(of: selectedViewController)
    }
    return viewController
  }
  
  func searchTopViewController() -> UIViewController {
    if let presentedViewController = self.presentedViewController {
      return presentedViewController.searchTopViewController()
    }
    if let navigationViewController = self as? UINavigationController,
       let topViewController = navigationViewController.topViewController {
      return topViewController.searchTopViewController()
    }
    if let tabBarController = self as? UITabBarController,
       let selectedViewController = tabBarController.selectedViewController {
      return selectedViewController.searchTopViewController()
    }
    return self
  }
}
