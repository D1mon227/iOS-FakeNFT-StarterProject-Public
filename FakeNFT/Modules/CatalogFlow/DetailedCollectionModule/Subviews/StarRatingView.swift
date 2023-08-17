
import UIKit

final class StarRatingView: UIView {
    
    // MARK: - Properties
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = NSLayoutConstraint.Axis.horizontal
        stack.distribution  = UIStackView.Distribution.equalSpacing
        stack.spacing = 3
        return stack
    }()
    
    private let rating: Int
    
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
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
        }
        
        for number in  1...5 {
            var starImageView: UIImageView
            if number > rating {
                starImageView = UIImageView.init(image: UIImage(named: "star"))
            } else {
                starImageView = UIImageView.init(image: UIImage(named: "star.fill"))
            }
            stackView.addArrangedSubview(starImageView)
        }
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        for number in  1...5 {
            var starImageView: UIImageView
            if number > rating {
                starImageView = UIImageView.init(image: UIImage(named: "star"))
            } else {
                starImageView = UIImageView.init(image: UIImage(named: "star.fill"))
            }
            stackView.addArrangedSubview(starImageView)
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

