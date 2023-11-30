//
//  CategoryCollectionViewCell.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell{
    
    lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.textAlignment = .center
        return label
    }()
    
    var category: Category?
    var searchCriteria: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLabel()
        addImageView()
        contentView.backgroundColor = .secondaryBackgroundColor
        backgroundColor = .secondaryBackgroundColor
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupData(category: Category, searchCriteria: String? = nil){
        self.category = category
        nameLabel.attributedText = category.name?.filterAndModifyTextAttributes(searchStringCharacters: searchCriteria ?? "", fontSize: 10)
        self.searchCriteria = searchCriteria
        guard let urlString = category.iconImageUrl,
              let url = URL(string: urlString)
        else {return}
        
        imageView.kf.setImage(with: url)
    }
    
    func addImageView(){
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: nameLabel, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemBackground
    }
    
    func addLabel(){
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        ])
    }
}
