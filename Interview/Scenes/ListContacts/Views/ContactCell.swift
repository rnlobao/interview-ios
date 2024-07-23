import UIKit

class ContactCell: UITableViewCell {
    
    private lazy var contactImage: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureViews()
    }
    
    private func configureViews() {
        configureViewsHierarchy()
        configureViewConstraints()
    }
    
    private func configureViewsHierarchy() {
        contentView.addSubview(contactImage)
        contentView.addSubview(fullnameLabel)
    }
    
    private func configureViewConstraints() {
        NSLayoutConstraint.activate([
            contactImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            contactImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contactImage.heightAnchor.constraint(equalToConstant: 100),
            contactImage.widthAnchor.constraint(equalToConstant: 100),
            
            fullnameLabel.leadingAnchor.constraint(equalTo: contactImage.trailingAnchor, constant: 16),
            fullnameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            fullnameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            fullnameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public func configureCell(with contact: Contact) {
        fullnameLabel.text = contact.name
        contactImage.image = UIImage(systemName: "photo")
        if let urlPhoto = URL(string: contact.photoURL) {
            DispatchQueue.global().async { [weak self] in
                guard let self else { return }
                do {
                    let data = try Data(contentsOf: urlPhoto)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.contactImage.image = image
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.contactImage.image = UIImage(systemName: "photo")
                    }
                }
                
            }
        } else {
            contactImage.image = UIImage(systemName: "photo")
        }
    }
    
}
