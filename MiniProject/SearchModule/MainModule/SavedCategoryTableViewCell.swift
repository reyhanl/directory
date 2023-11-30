//
//  SavedCategoryTableViewCell.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import UIKit
import Kingfisher

class SavedCategoryTableViewCell: UITableViewCell{
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var activeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var stackViewLeadingConstraint: NSLayoutConstraint?
    
    var defaultRowHeight: CGFloat = 30
    var defaultThumbImagesHeight: CGFloat = 60
    var searchCriteria: String? = nil
    var level: Int = 0
    var leadingGap: CGFloat = 20
    var isEditingMode: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.clipsToBounds = true
//        addContainerView()
        selectionStyle = .none
        addStackView()
        addActiveView()
        addImageView()
        addTitleLabel()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        setupActiveStatus()
    }
    
//    func addContainerView(){
//        addSubview(containerView)
//        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
//        bottomConstraint.priority = .defaultLow
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
//            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
//            bottomConstraint
//        ])
//    }
    
    func addStackView(){
        addSubview(stackView)
        
        let leadingConstraint =  NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
            leadingConstraint
        ])
        stackViewLeadingConstraint = leadingConstraint
    }
    
    private func addTitleLabel(){
        stackView.addArrangedSubview(titleLabel)
//        NSLayoutConstraint.activate([
//            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 20),
//            NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 20)
//        ])
//
        titleLabel.text = "dwwd"
        titleLabel.numberOfLines = 0
    }
    
    func addActiveView(){
        stackView.addArrangedSubview(activeView)
        let size = 20.0
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: activeView, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: size),
            NSLayoutConstraint(item: activeView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: size),
      ])
        activeView.backgroundColor = .purple
        activeView.layer.cornerRadius = size / 2
    }
    
    func addImageView(){
        stackView.addArrangedSubview(thumbImageView)
        let size = 20.0
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: thumbImageView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.8, constant: 0),
            NSLayoutConstraint(item: thumbImageView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.8, constant: 0),
      ])
        thumbImageView.layer.cornerRadius = 5
    }
    
    func setupActiveStatus(){
        switch isSelected{
        case true:
            activeView.backgroundColor = .purple
            activeView.layer.borderWidth = 0
        case false:
            activeView.backgroundColor = .systemBackground
            activeView.layer.borderColor = UIColor.purple.cgColor
            activeView.layer.borderWidth = 2
        }
    }
    
    func addGestureRecognizer(){
//        containerView.isUserInteractionEnabled = true
//        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
//        containerView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupData(category: Category, isEditingMode: Bool){
        titleLabel.text = category.name
        print(category.iconImageUrl)
        let url = URL(string: category.iconImageUrl ?? "")
        thumbImageView.kf.setImage(with: url)
        activeView.isHidden = !isEditingMode
        self.stackViewLeadingConstraint?.constant = CGFloat(level) * leadingGap
        setupActiveStatus()
    }
    
    @objc func didTap(){
        
    }
}
