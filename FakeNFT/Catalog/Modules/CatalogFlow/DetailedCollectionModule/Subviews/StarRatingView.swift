
import UIKit

final class StarRatingView: UIView {
    
    // MARK: - Properties
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.spacing = 2
        return stack
    }()
    
    private let rating: Int
    private var starImageViews: [UIImageView] = []
    
    // MARK: - Lifecycle
    init(rating: Int) {
        self.rating = rating
        super.init(frame: .zero)
        addSubview(stackView)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setStarsRatingImage(rating: Int) {
        for i in 0..<5 {
            starImageViews[i].tintColor = i < rating ? .yellowUniversal : .lightGreyDay
        }
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        for _ in 0..<5 {
            let imageView = UIImageView(image: Resourses.Images.Cell.star)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 12),
                imageView.heightAnchor.constraint(equalToConstant: 12),
            ])
            stackView.addArrangedSubview(imageView)
            starImageViews.append(imageView)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

