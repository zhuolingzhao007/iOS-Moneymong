import UIKit

final class DesignSystemVC: UITableViewController {
  
  enum Screen: Int, CaseIterable {
    case color
    case font
    case button
    case floatingButton
    case selection
    case snackbar
    case alert
    case tag
    case lineTab
    case textFields
    case navigation
    case tooltip
    case indicator

    var title: String {
      switch self {
      case .color: return "Colors"
      case .font: return "Fonts"
      case .button: return "Buttons"
      case .floatingButton: return "FloatingButton"
      case .selection: return "Selection"
      case .snackbar: return "SnackBar"
      case .alert: return "Alert"
      case .tag: return "Tag"
      case .lineTab: return "LineTab"
      case .textFields: return "TextFields"
      case .navigation: return "Navigation"
      case .tooltip: return "Tooltip"
      case .indicator: return "Indicator"
      }
    }
    
    func move(with navigationController: UINavigationController?) {
      let vc: UIViewController
      switch self {
      case .color: vc = ColorVC(style: .insetGrouped)
      case .font: vc = FontVC(style: .insetGrouped)
      case .button: vc = ButtonVC()
      case .floatingButton: vc = FloatingButtonVC()
      case .selection: vc = SelectionVC()
      case .snackbar: vc = SnackBarVC()
      case .alert: vc = AlertVC()
      case .tag: vc = TagVC()
      case .lineTab: vc = LineTabVC()
      case .textFields: vc = TextFieldsVC()
      case .navigation: vc = NavigationVC()
      case .tooltip: vc = ToolTipVC()
      case .indicator: vc = IndicatorVC()
      }
      
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
  }
  
  private func setupView() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
    title = "Components"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
}

extension DesignSystemVC {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Screen.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = Screen(rawValue: indexPath.row)?.title
    cell.textLabel?.font = .systemFont(ofSize: 20)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    Screen(rawValue: indexPath.row)?.move(with: navigationController)
  }
}
