import UIKit
import SnapKit

class NavigationNewsView: UIView, NavigationNewsViewProtocol {
    
    private let titleLabel: UILabel
    private let textLabel: UILabel
    private let imageView: UIImageView
    private let indicatorView: UIActivityIndicatorView
    
    init(titleLabel: UILabel, textLabel: UILabel, imageView: UIImageView, indicatorView: UIActivityIndicatorView) {
        self.titleLabel = titleLabel
        self.textLabel = textLabel
        self.imageView = imageView
        self.indicatorView = indicatorView
        super.init(frame: .zero)
        setupConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Private
private extension NavigationNewsView {
    
    func setupConfiguration() {
        imageView.clipsToBounds = true
        imageView.addSubview(indicatorView)
        addSubview(titleLabel)
        addSubview(textLabel)
        addSubview(imageView)
    }
    
    func setupConstraints(_ data: NewsInfo) {
        guard constraints.isEmpty else { return }
        
        snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(data.layout.size)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(data.layout.titleLabel.constraints.top)
            $0.leading.equalToSuperview().inset(data.layout.titleLabel.constraints.left)
            $0.trailing.equalTo(imageView.snp.leading).offset(data.layout.titleLabel.constraints.right)
        }
            
        textLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(data.layout.textLabel.constraints.left)
            $0.trailing.equalTo(imageView.snp.leading).offset(data.layout.textLabel.constraints.right)
            $0.bottom.equalToSuperview().inset(data.layout.textLabel.constraints.bottom)
        }
            
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(data.layout.imageView.constraints.top)
            $0.trailing.equalToSuperview().inset(data.layout.imageView.constraints.right)
            $0.width.equalTo(data.layout.imageView.size.width)
            $0.height.equalTo(data.layout.imageView.size.height)
            $0.bottom.equalToSuperview().inset(data.layout.imageView.constraints.bottom)
        }
            
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setupSubviews(_ data: NewsInfo) {
        titleLabel.text = data.title
        titleLabel.numberOfLines = data.layout.titleLabel.numberOfLines
        titleLabel.font = data.layout.titleLabel.font
        titleLabel.textColor = data.layout.titleLabel.textColor
        
        textLabel.text = data.description
        textLabel.font = data.layout.textLabel.font
        textLabel.textColor = data.layout.textLabel.textColor
        
        imageView.image = data.image
        imageView.image == nil ? indicatorView.startAnimating() : indicatorView.stopAnimating()
        imageView.layer.cornerRadius = data.layout.imageView.cornerRadius
    }
    
}

// MARK: Protocol
extension NavigationNewsView {
    
    func configure(_ data: NewsInfo) {
        setupConstraints(data)
        setupSubviews(data)
    }
    
    func reset() {
        titleLabel.text?.removeAll()
        textLabel.text?.removeAll()
        imageView.image = nil
    }
    
}

// MARK: - NavigationNewsViewLayout
struct NavigationNewsViewLayout {
    let titleLabel = NavigationNewsTitleLabelLayout()
    let textLabel = NavigationNewsTextLabelLayout()
    let imageView = NavigationNewsImageViewLayout()
    let size = CGSize(width: UIScreen.main.bounds.width - 40, height: 0)
}

// MARK: - NavigationNewsTitleLabelLayout
struct NavigationNewsTitleLabelLayout {
    let constraints = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: -20)
    let numberOfLines = 3
    let font = UIFont.boldSystemFont(ofSize: 17)
    let textColor = UIColor.black
}

// MARK: - NavigationNewsTextLabelLayout
struct NavigationNewsTextLabelLayout {
    let constraints = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: -20)
    let font = UIFont.systemFont(ofSize: 12)
    let textColor = UIColor.lightGray
}

// MARK: - NavigationNewsImageViewLayout
struct NavigationNewsImageViewLayout {
    let constraints = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 20)
    let size = CGSize(width: 140, height: 99)
    let cornerRadius = CGFloat(10)
}
