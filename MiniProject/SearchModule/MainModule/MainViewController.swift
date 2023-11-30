//
//  MainViewController.swift
//  MiniProject
//
//  Created by reyhan muhammad on 12/08/23.
//

import UIKit

class MainViewController: UIViewController{
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SavedCategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.isUserInteractionEnabled = true
        tableView.backgroundColor = .clear
        tableView.accessibilityIdentifier = "tableView"
        return tableView
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "titleLabel"
        return label
    }()
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var toolBar: UIToolbar = {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        let flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        cancelSelectionButton.accessibilityIdentifier = "cancelSelectionButton"
       toolbar.items = [cancelSelectionButton, flexibleSpaceItem, trashButton]
        return toolbar
    }()
    lazy var trashButton: UIBarButtonItem = {
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteSelectedItems))
        trashButton.accessibilityIdentifier = "removeAllbutton"
        return trashButton
    }()
    lazy var cancelSelectionButton: UIBarButtonItem = {
        let cancelSelectionButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelSelection))

        return cancelSelectionButton
    }()
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    var presenter: MainViewToPresenterProtocol?
    var savedCategories: [Category] = []{
        didSet{
            setTitleLabelText()
            updateLeftBarButtonText()
        }
    }
    var isSelectingRows: Bool = false{
        didSet{
            updateToolBar()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTitleLabelText()
        addContainerView()
        addLabel()
        addTableView()
        addButton()
        updateLeftBarButtonText()
        addToolBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    private func addContainerView(){
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: containerView, attribute: .top, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .leading, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .trailing, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: containerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    private func addLabel(){
        containerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: containerView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 20),
            NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        ])
        
        titleLabel.font = .boldSystemFont(ofSize: 24)
    }
    
    private func addTableView(){
        containerView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: titleLabel, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: -20),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
        
        addLongPressToDelete()
        
        func addLongPressToDelete(){
            let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
            tableView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    private func addButton(){
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(chooseOneButtonClicked))
        let selectButton = UIBarButtonItem(title: "select", style: .plain, target: self, action: #selector(startSelection))
        
        add.accessibilityIdentifier = "addCategoryButton"
        selectButton.accessibilityIdentifier = "selectButton"
        
        navigationItem.leftBarButtonItems = [selectButton]
        navigationItem.rightBarButtonItems = [add]

    }
    
    private func deleteRow(names: [String]){
        let indexes = savedCategories.enumerated().filter({
            let category = $0.element
            guard let name = category.name else{return false}
            return names.contains(name)
        }).map({IndexPath(row: $0.offset, section: 0)})
        let indexSet = IndexSet(indexes.map({$0.row}))
        
        savedCategories.remove(atOffsets: indexSet)
        self.tableView.performBatchUpdates({
            tableView.deleteRows(at: indexes, with: .left)
        }) { bool in
            self.cancelSelection()
        }
    }
    
    private func setTitleLabelText(){
        title = savedCategories.count > 0 ? "You have chosen":"You have no selected categories"
    }
    
    private func addToolBar(){
        view.addSubview(toolBar)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: toolBar, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBar, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: toolBar, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        
        updateToolBar()
    }
    
    @objc func longPress(sender:UILongPressGestureRecognizer)  {
        switch sender.state {
        case .began:
            guard !isSelectingRows else{return}
            tableView.allowsSelection = true
            tableView.allowsMultipleSelection = true
            let point = sender.location(in: tableView)
            isSelectingRows = true
            tableView.reloadData()
            selectCellFromPoint(point: point)
        default:break
        }
    }

    private func selectCellFromPoint(point:CGPoint) {
        if let indexPath = tableView.indexPathForRow(at: point) {
           tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            checkIfAnyCellIsSelected()
       }
    }
    
    private func checkIfAnyCellIsSelected(){
        if let indexPaths = tableView.indexPathsForSelectedRows,
           indexPaths.count == 0{
            isSelectingRows = false
            tableView.allowsMultipleSelection = false
            tableView.reloadData()
            cancelSelection()
        }
    }
    
    private func updateToolBar(){
        toolBar.isHidden = !isSelectingRows
    }
    
    @objc func deleteSelectedItems(){
        guard let indexPaths = tableView.indexPathsForSelectedRows else{return}
        let categories = indexPaths.map({savedCategories[$0.row]})
        presenter?.userDeleteSavedCategory(with: categories.map({$0.name ?? ""}))
    }
    
    @objc func cancelSelection(){
        tableView.allowsMultipleSelection = false
        tableView.reloadData()
        isSelectingRows = false
        updateLeftBarButtonText()
    }
    
    @objc func startSelection(){
        isSelectingRows = !isSelectingRows
        updateLeftBarButtonText()
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
        tableView.reloadData()
    }
    
    private func updateLeftBarButtonText(){
        guard let navigationItem = navigationItem.leftBarButtonItems?.first else{return}
        if savedCategories.count == 0{
            navigationItem.title = ""
            navigationItem.isEnabled = false
            return
        }
        navigationItem.isEnabled = true
        navigationItem.title = isSelectingRows ? "unselect":"select"
    }
    
    @objc func chooseOneButtonClicked(){
        presenter?.showSearchVC(view: self)
    }
}

//MARK: UITableView data and delegate
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SavedCategoryTableViewCell
        cell.accessibilityIdentifier = "cell\(indexPath.row)"
        cell.setupData(category: savedCategories[indexPath.row], isEditingMode: isSelectingRows)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCategories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isSelectingRows{
            let selectedCategory = savedCategories[indexPath.row]
            presenter?.userClickOnSavedCategories(category: selectedCategory.name ?? "")
        }else{
            guard let cell = tableView.cellForRow(at: indexPath) else{return}
            cell.accessibilityTraits = cell.isSelected ? [.selected]:[]
        }
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        return indexPath
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let item = UIContextualAction(style: .destructive, title: "Delete") {  [weak self] (contextualAction, view, boolValue) in
                guard let self = self, let categoryName = self.savedCategories[indexPath.row].name else{return}
                self.presenter?.userDeleteSavedCategory(with: [categoryName])
            }
            item.image = UIImage(named: "deleteIcon")

            let swipeActions = UISwipeActionsConfiguration(actions: [item])
        
            return swipeActions
        }
}

//MARK: Main presenter to view protocol
extension MainViewController: MainPresenterToViewProtocol{
    
    func result(result: Result<MainModuleSuccess, Error>) {
        switch result{
        case .success(let successType):
            handleSuccess(successType)
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    private func handleSuccess(_ type: MainModuleSuccess){
        switch type{
        case .successfullyDeleted(let names):
            deleteRow(names: names)
        case .successfullyRetrieveData(let categories):
            updateData(categories)
        case .successfullySavingData:
            handleSuccessSavingData()
        }
    }
    
    private func updateData(_ categories: [Category]){
        let currentEndIndex = savedCategories.count == 0 ? 0:savedCategories.count
        let temp: [Category] = categories.filter({
            let temp = $0
            let contain = !savedCategories.contains(where: { category in
                temp.name == category.name
            })
            return contain
        })
        let updateLastIndex = currentEndIndex + temp.count - 1
        
        //you can definitely jusr reload the last rows, but this code would be useful if in the future you want to be able to add multiple items at once
        guard currentEndIndex <= updateLastIndex else{return}
        self.tableView.performBatchUpdates({
            savedCategories.append(contentsOf: temp)
            let indexPaths = (currentEndIndex...updateLastIndex).map({IndexPath(row: $0, section: 0)})
            self.tableView.insertRows(at: indexPaths, with: .left)
        }, completion: nil)
    }
    
    private func handleSuccessSavingData(){
        tableView.scrollToRow(at: IndexPath(row: savedCategories.count - 1, section: 0), at: .bottom, animated: true)
        presentBubbleAlert(text: "Successfully saving data", with: 0.2, floating: 1)
    }
    
    private func handleError(error: Error) {
        guard let error = error as? CustomError,
              let errorDescription = error.errorDescription else{
            print(String(describing: error))
            return
        }
        switch error{
        case .dataAlreadyExist:
            presentBubbleAlert(text: errorDescription, with: 0.2, floating: 1)
        default:
            print(error.errorDescription)
        }
    }
}

extension MainViewController: SearchViewControllerProtocol{
    func didFinishPicking(category: Category) {
        dismiss(animated: true) {
            self.presenter?.userSaveCategory(category: category)
        }
    }
}
