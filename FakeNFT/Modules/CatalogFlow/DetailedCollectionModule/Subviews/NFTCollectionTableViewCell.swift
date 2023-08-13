
import UIKit

struct NFTCollectionTableViewCellViewModel: DetailedCollectionTableViewCellProtocol {
    let nftModels: [NFTCollectionViewCellViewModel]
}

protocol NFTCollectionTableViewCellDelegate: AnyObject {
    func didTapNFTLikeButton(id: String)
    func didTapNFTCartButton(id: String)
}

extension NFTCollectionTableViewCell {
    enum Layout {
        static let cellSize = CGSize(width: 108, height: 192)
        static let spacingBetweenCells: CGFloat = 8
        static let bothSideOffset: CGFloat = 10
    }
    
    enum Constants {
        static let countOfCellsPerRow = 3
    }
}

final class NFTCollectionTableViewCell: UITableViewCell {
    
    weak var delegate: NFTCollectionTableViewCellDelegate?
    
    private var nftModels: [NFTCollectionViewCellViewModel] = []
    
    private let collectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Layout.spacingBetweenCells
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero,
                                    collectionViewLayout: collectionViewFlowLayout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blackDay
        view.isScrollEnabled = false
        view.register(
            NFTCollectionViewCell.self,
            forCellWithReuseIdentifier: NFTCollectionViewCell.identifier
        )
        return view
    }()
    
    private lazy var collectionViewHeightAnchor = collectionView.heightAnchor.constraint(equalToConstant: 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCollectionView()
        setupCollectionViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: NFTCollectionTableViewCellViewModel) {

        nftModels = viewModel.nftModels
        
        if collectionViewHeightAnchor.constant == 0 {
            let numberOfRows = nftModels.count / Constants.countOfCellsPerRow
            
            var totalHeight = (CGFloat(numberOfRows) * Layout.cellSize.height) + (CGFloat(numberOfRows - 1) * Layout.spacingBetweenCells)
            let remainingCells = nftModels.count % Constants.countOfCellsPerRow
            if remainingCells > 0 {
                totalHeight += Layout.cellSize.height + Layout.spacingBetweenCells
            }
            
            collectionViewHeightAnchor.constant = totalHeight
        }
        collectionView.reloadData()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setupCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.bothSideOffset),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.bothSideOffset),
            collectionViewHeightAnchor
        ])
    }
    
}

extension NFTCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nftModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NFTCollectionViewCell.identifier, for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let viewModel = nftModels[indexPath.row]
        cell.configure(with: viewModel)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        Layout.cellSize
    }

}

extension NFTCollectionTableViewCell: NFTCollectionViewCellDelegateProtocol {
    func didTapNFTLikeButton(id: String) {
        delegate?.didTapNFTLikeButton(id: id)
    }
    
    func didTapNFTCartButton(id: String) {
        delegate?.didTapNFTCartButton(id: id)
    }
}
