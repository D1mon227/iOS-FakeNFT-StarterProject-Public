protocol DetailedCollectionViewProtocol: AnyObject {
    func updateViewModel(with detailedDescriptionModel: CollectionDetailsTableViewCellModel)
    func updateViewModel(with nftsViewModel: NFTCollectionTableViewCellViewModel)
}

