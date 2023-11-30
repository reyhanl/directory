//
//  CategoryHeader.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import UIKit

class CategoryTableViewHeader: UIView{
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var amountOfChildrenLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    var labelLeadingConstraint: NSLayoutConstraint?
    
    var category: Category?
    var defaultRowHeight: CGFloat = 30
    var defaultThumbImagesHeight: CGFloat = 60
    var searchCriteria: String? = nil
    var level: Int = 0
    var leadingGap: CGFloat = 20
    var delegate: CategoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        addContainerView()
        addTitleLabel()
        addAmountOfChildrenLabel()
        addGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addContainerView(){
        addSubview(containerView)
        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            bottomConstraint
        ])
        backgroundColor = .systemBackground
    }
    
    private func addTitleLabel(){
        containerView.addSubview(titleLabel)
        
        let widthConstraint = NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: self.frame.width / 2)
        widthConstraint.priority = .defaultLow

        let leadingConstraint =  NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0),
            widthConstraint,
            leadingConstraint
        ])
        
        labelLeadingConstraint = leadingConstraint
    }
    
    private func addAmountOfChildrenLabel(){
        containerView.addSubview(amountOfChildrenLabel)
        
        let widthConstraint = NSLayoutConstraint(item: amountOfChildrenLabel, attribute: .width, relatedBy: .equal, toItem: containerView, attribute: .width, multiplier: 0.25, constant: 0)
        widthConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: amountOfChildrenLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: amountOfChildrenLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -10),
            widthConstraint,
            NSLayoutConstraint(item: amountOfChildrenLabel, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .trailing, multiplier: 1, constant: 10),
        ])
        amountOfChildrenLabel.isHidden = true
    }
    
    func addGestureRecognizer(){
        containerView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        containerView.addGestureRecognizer(gestureRecognizer)
    }
    
    func setupData(category: Category, searchCriteria: String? = nil, depth level: Int){
        self.category = category
        titleLabel.attributedText = category.name?.filterAndModifyTextAttributes(searchStringCharacters: searchCriteria ?? "")
        self.searchCriteria = searchCriteria
        self.level = level
        self.labelLeadingConstraint?.constant = CGFloat(level) * leadingGap
        layoutIfNeeded()
        guard let count = category.child?.count else{return}
        amountOfChildrenLabel.isHidden = count == 0
        amountOfChildrenLabel.text = "\(count) children"
    }
    
    func getHeightOfCell(index: Int) -> CGFloat{
        guard let category = category,
              let children = category.child,
              children.count - 1 >= index else{return 0}
        var height = defaultRowHeight
        let child = children[index]
        if child.isExpanded{
            if level == 1{
                height += defaultThumbImagesHeight
                height += defaultRowHeight
            }else{
                for _ in child.child ?? []{
                    height += defaultRowHeight
                }
            }
        }
        return height
    }
    
    @objc func didTap(){
        guard let category = category else{return}
        print("height of: \(collectionView.frame.height)")
        category.isExpanded = !category.isExpanded
        delegate?.userSelectParentCategory(category: category)
    }
}
