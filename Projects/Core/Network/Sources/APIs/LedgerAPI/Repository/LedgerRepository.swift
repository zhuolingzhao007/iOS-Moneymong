import Foundation

import LocalStorage

public protocol LedgerRepositoryInterface {
  
  func imageUpload(_ data: Data) async throws -> ImageInfo
  func imageDelete(_ image: ImageInfo) async throws
  func fetchLedgerDetail(id: Int) async throws -> LedgerDetail
  func create(
    id: Int,
    storeInfo: String,
    fundType: FundType,
    amount: Int,
    description: String,
    paymentDate: String,
    receiptImageUrls: [String],
    documentImageUrls: [String]
  ) async throws
  func update(ledger: LedgerDetail) async throws -> LedgerDetail
  func delete(id: Int) async throws
  func fetchLedgerList(
    id: Int,
    start: DateInfo,
    end: DateInfo,
    page: Int,
    limit: Int,
    fundType: FundType?
  ) async throws -> LedgerList
  func fetchOCR(_ data: Data) async throws -> OCRResult
  func receiptImagesUpload(detailId: Int, receiptImageUrls: [String]) async throws
  func receiptImageDelete(detailId: Int, receiptId: Int) async throws
  func documentImagesUpload(detailId: Int, documentImageUrls: [String]) async throws
  func documentImageDelete(detailId: Int, documentId: Int) async throws
}

public final class LedgerRepository: LedgerRepositoryInterface {
  private let networkManager: NetworkManagerInterfacae
  private let localStorage: LocalStorageInterface

  public init(
    networkManager: NetworkManagerInterfacae,
    localStorage: LocalStorageInterface
  ) {
    self.networkManager = networkManager
    self.localStorage = localStorage
  }
  
  public func create(
    id: Int,
    storeInfo: String,
    fundType: FundType,
    amount: Int,
    description: String,
    paymentDate: String,
    receiptImageUrls: [String],
    documentImageUrls: [String]
  ) async throws {
    let targetType = LedgerAPI.create(
      id: id,
      param: .init(
        storeInfo: storeInfo,
        fundType: fundType.rawValue,
        amount: amount,
        description: description,
        paymentDate: paymentDate,
        receiptImageUrls: receiptImageUrls,
        documentImageUrls: documentImageUrls
      )
    )
    _ = try await networkManager.request(target: targetType, of: LedgerDetailResponseDTO.self)
  }

  public func update(ledger: LedgerDetail) async throws -> LedgerDetail {
    let targetType = LedgerAPI.update(
      id: ledger.id,
      param: .init(
        storeInfo: ledger.storeInfo,
        fundType: ledger.fundType.rawValue,
        amount: ledger.amount,
        description: ledger.description,
        paymentDate: ledger.paymentDate,
        receiptImageUrls: ledger.receiptImageUrls.map { $0.url },
        documentImageUrls: ledger.documentImageUrls.map { $0.url }
      )
    )
    let dto = try await networkManager.request(target: targetType, of: LedgerDetailResponseDTO.self)
    return dto.toEntity
  }

  public func delete(id: Int) async throws {
    let targetType = LedgerAPI.delete(id: id)
    try await networkManager.request(target: targetType)
  }

  public func imageUpload(_ data: Data) async throws -> ImageInfo {
    let targetType = LedgerAPI.uploadImage(data)
    return try await networkManager.request(target: targetType, of: ImageResponseDTO.self).toEntity
  }
  
  public func imageDelete(_ image: ImageInfo) async throws {
    let targetType = LedgerAPI.deleteImage(
      param: .init(key: image.key, path: image.url)
    )
    try await networkManager.request(target: targetType)
  }
  
  public func fetchLedgerList(
    id: Int,
    start: DateInfo,
    end: DateInfo,
    page: Int,
    limit: Int,
    fundType: FundType?
  ) async throws -> LedgerList {
    let request = LedgerListRequestDTO(
      startYear: start.year,
      endYear: end.year,
      startMonth: start.month,
      endMonth: end.month,
      page: page,
      limit: limit,
      fundType: fundType?.rawValue
    )
    let targetType: TargetType
    if fundType == nil {
      targetType = LedgerAPI.ledgerList(id: id, param: request)
    } else {
      targetType = LedgerAPI.ledgerFilterList(id: id, param: request)
    }
    return try await networkManager.request(target: targetType, of: LedgerListResponseDTO.self).toEntity
  }
  
  public func fetchLedgerDetail(id: Int) async throws -> LedgerDetail {
    let targetType = LedgerAPI.ledgerDetail(id: id)
    return try await networkManager.request(target: targetType, of: LedgerDetailResponseDTO.self).toEntity
  }
  
  public func fetchOCR(_ data: Data) async throws -> OCRResult {
    let dto = OCRRequestDTO(
      requestId: UUID().uuidString,
      images: [
        .init(format: "jpeg", name: "receipt")
      ])
    let targetType = LedgerAPI.receiptOCR(param: dto, data: data)
    return try await networkManager.request(target: targetType, of: OCRResponseDTO.self).toEntity
  }

  public func receiptImagesUpload(detailId: Int, receiptImageUrls: [String]) async throws {
    let targetType = LedgerAPI.receiptImagesUpload(
      detailId: detailId,
      receiptImageUrls: ReceiptUploadRequestDTO(receiptImageUrls: receiptImageUrls)
    )
    return try await networkManager.request(target: targetType)
  }

  public func receiptImageDelete(detailId: Int, receiptId: Int) async throws {
    let targetType = LedgerAPI.receiptImageDelete(detailId: detailId, receiptId: receiptId)
    return try await networkManager.request(target: targetType)
  }

  public func documentImagesUpload(detailId: Int, documentImageUrls: [String]) async throws {
    let targetType = LedgerAPI.documentImagesUpload(
      detailId: detailId,
      documentImageUrls: DocumentUploadRequestDTO(documentImageUrls: documentImageUrls)
    )
    return try await networkManager.request(target: targetType)
  }

  public func documentImageDelete(detailId: Int, documentId: Int) async throws {
    let targetType = LedgerAPI.documentImageDelete(detailId: detailId, documentId: documentId)
    return try await networkManager.request(target: targetType)
  }
}

