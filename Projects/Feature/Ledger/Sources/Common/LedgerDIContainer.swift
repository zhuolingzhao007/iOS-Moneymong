import UIKit

import LocalStorage
import NetworkService
import BaseFeature

public final class LedgerDIContainer {

  private let ledgerService: LedgerServiceInterface = LedgerService()
  
  private let ledgerRepo: LedgerRepositoryInterface
  private let agencyRepo: AgencyRepositoryInterface
  private let userRepo: UserRepositoryInterface
  
  public init(
    ledgerRepo: LedgerRepositoryInterface,
    agencyRepo: AgencyRepositoryInterface,
    userRepo: UserRepositoryInterface
  ) {
    self.ledgerRepo = ledgerRepo
    self.agencyRepo = agencyRepo
    self.userRepo = userRepo
  }

  func ledger(with coordinator: LedgerCoordinator) -> LedgerVC {
    let vc = LedgerVC(
      [
        ledgerTab(with: coordinator),
        memberTab(with: coordinator)
      ]
    )
    vc.reactor = LedgerReactor(
      userRepo: userRepo,
      agencyRepo: agencyRepo,
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  private func ledgerTab(with coordinator: LedgerCoordinator) -> UIViewController {
    let vc = LedgerTabVC()
    vc.title = "장부"
    vc.reactor = LedgerTabReactor()
    vc.coordinator = coordinator
    return vc
  }
  
  private func memberTab(with coordinator: LedgerCoordinator) -> UIViewController {
    let vc = MemberTabVC()
    vc.title = "멤버"
    vc.reactor = MemberTabReactor(
      userRepo: userRepo,
      agencyRepo: agencyRepo,
      ledgerService: ledgerService
    )
    vc.coordinator = coordinator
    return vc
  }
  
  func manualInput(with coordinator: Coordinator) -> UIViewController {
    let vc = UINavigationController()
    let manualInputCoordinator = ManualInputCoordinator(
      navigationController: vc,
      diContainer: ManualInputDIContainer(repo: ledgerRepo)
    )
    coordinator.childCoordinators.append(manualInputCoordinator)
    manualInputCoordinator.parentCoordinator = coordinator
    manualInputCoordinator.start(animated: false)
    return vc
  }
  
  func editMember(agencyID: Int, member: Member, with coordinator: LedgerCoordinator) -> EditMemberSheetVC {
    let vc = EditMemberSheetVC()
    vc.coordinator = coordinator
    vc.reactor = EditMemberReactor(
      agencyID: agencyID,
      member: member,
      agencyRepo: agencyRepo,
      ledgerService: ledgerService
    )
    return vc
  }
  
  func datePicker() -> UIViewController {
    let vc = DatePickerSheetVC()
    vc.reactor = DatePickerReactor(
      startDate: .init(year: 2023, month: 1),
      endDate: .init(year: 2023, month: 6)
    )
    return vc
  }
}
