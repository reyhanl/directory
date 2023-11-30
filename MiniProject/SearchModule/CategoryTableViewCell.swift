//
//  CategoryTableViewCell.swift
//  MiniProject
//
//  Created by reyhan muhammad on 11/08/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell{
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var amountOfChildrenLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
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
        contentView.addSubview(containerView)
        let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        bottomConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            bottomConstraint,
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30),
            NSLayoutConstraint(item: containerView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 30)
        ])
    }
    
    private func addTitleLabel(){
        containerView.addSubview(titleLabel)
        let leadingConstraint =  NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0),
            leadingConstraint,
            NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: self.frame.width / 2),
            NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: self.frame.width * 0.75)
        ])
        
        labelLeadingConstraint = leadingConstraint
        titleLabel.clipsToBounds = true
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .secondaryForegroundColor
    }
    
    private func addAmountOfChildrenLabel(){
        containerView.addSubview(amountOfChildrenLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: amountOfChildrenLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: amountOfChildrenLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: amountOfChildrenLabel, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: containerView.frame.width / 4),
        ])
        amountOfChildrenLabel.isHidden = true
        
        amountOfChildrenLabel.font = .systemFont(ofSize: 16, weight: .regular)
        amountOfChildrenLabel.textColor = .secondaryForegroundColor

    }
    
    func addCollectionViewOrTableView(){
        if level == 1{
            addTableView()
        }
        else{
            addCollectionView()
            tableView.isHidden = true
        }
    }
    
    private func addTableView(){
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .red
        
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
    }
    
    func addCollectionView(){
        contentView.addSubview(collectionView)
        self.layoutSubviews()
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        layoutIfNeeded()
    }
    
    func addGestureRecognizer(){
        containerView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        containerView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        guard let category = category else{return}
        setupData(category: category, depth: level)
    }
    
    func setupData(category: Category, searchCriteria: String? = nil, depth level: Int){
        self.category = category
        titleLabel.attributedText = category.name?.filterAndModifyTextAttributes(searchStringCharacters: searchCriteria ?? "")
        self.searchCriteria = searchCriteria
        self.level = level
        self.labelLeadingConstraint?.constant = 1 * leadingGap
        addCollectionViewOrTableView()
        layoutIfNeeded()
        guard let count = category.child?.count else{return}
        amountOfChildrenLabel.isHidden = count == 0
        amountOfChildrenLabel.text = "\(count) children"
        self.searchCriteria = searchCriteria
        collectionView.reloadData()
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
        delegate?.userSelectChildCategory(category: category)
    }
}

extension CategoryTableViewCell: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryTableViewCell
        if let category = category, let children = category.child{
            cell.setupData(category: children[indexPath.row], searchCriteria: searchCriteria, depth: level + 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category?.child?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightOfCell(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension CategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
        if let category = category, let children = category.child, indexPath.row < children.count{
            cell.setupData(category: children[indexPath.row], searchCriteria: searchCriteria)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category?.child?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: defaultThumbImagesHeight, height: defaultThumbImagesHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let category = category?.child?[indexPath.row] else{return}
        delegate?.userSavedCategory(category: category)
        
    }
}
