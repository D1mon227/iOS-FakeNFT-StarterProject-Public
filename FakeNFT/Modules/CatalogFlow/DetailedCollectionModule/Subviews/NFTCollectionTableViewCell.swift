
import UIKit

struct NFTCollectionTableViewCellViewModel: DetailedCollectionTableViewCellProtocol {
    let nftModels: [NFTCollectionViewCellViewModel]
}

final class NFTCollectionTableViewCell: UITableViewCell {
    
    private var nftModels: [NFTCollectionViewCellViewModel] = []
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundDay
        view.register(
            NFTCollectionViewCell.self,
            forCellWithReuseIdentifier: NFTCollectionViewCell.identifier
        )
        return view
    }()
    
    func configure(with viewModel: NFTCollectionTableViewCellViewModel) {
        nftModels = viewModel.nftModels
        collectionView.reloadData()
    }
    
    func setupCollectionView() {
        //collectionView.addSubview(<#T##view: UIView##UIView#>)
    }

    func setupCollectionViewConstrains() {
        NSLayoutConstraint.activate([
        //
        ])
    }
    
}

extension NFTCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nftModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier,
                                                            for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel = nftModels[indexPath.row]
        cell.configure(with: viewModel)
        
        return cell
    }

}

