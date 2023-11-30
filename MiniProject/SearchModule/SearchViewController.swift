//
//  ViewController.swift
//  MiniProject
//
//  Created by Nakama on 06/11/20.
//

import UIKit

class SearchViewController: UIViewController, SearchPresenterToViewProtocol {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        tableView.accessibilityIdentifier = "searchTable"
        return tableView
    }()
    
    lazy var searchBar:UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.accessibilityIdentifier = "searchBar"
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    var presenter: SearchViewToPresenterProtocol?
    private var categories: [Category] = []
    private var defaultRowHeight: CGFloat = 30
    private var defaultThumbImagesHeight: CGFloat = 60
    var delegate: SearchViewControllerProtocol?
    var searchKeyword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        addTableView()
        addSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func result(result: Result<SearchSuccessType, Error>) {
        switch result{
        case .success(let type):
            handleSuccess(type: type)
        case .failure(let error):
            handleError(error: error)
        }
    }
    
    private func addTableView(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    private func addSearchBar(){
        navigationItem.titleView = searchBar
        tableView.tableHeaderView = searchBar
        for subview in searchBar.subviews{
            for subsubView in subview.subviews{
                subsubView.backgroundColor = .systemBackground
            }
        }
        searchBar.backgroundColor = .secondarySystemBackground
        tableView.tableHeaderView?.backgroundColor = .black
    }
    
    private func getHeightOfCell(indexPath: IndexPath) -> CGFloat{
        guard categories.count - 1 >= indexPath.section,
              let children = categories[indexPath.section].child,
              children.count > indexPath.row
        else{return 0}
        var height = defaultRowHeight
        let category = children[indexPath.row]
        if category.isExpanded{
            height += defaultThumbImagesHeight + defaultRowHeight
        }
        return height
    }
    
    //When user select a section to expand, the app will scroll down until all the rows of that section is displayed, however the table won't scroll if the expanded area is already visible.
    private func scrollTableView(to section: Int){
        guard let childrenCount = categories[section].child?.count,
              let indexPathForVisibleRows = tableView.indexPathsForVisibleRows
        else{return}
        let row = childrenCount - 1
        let indexPath = IndexPath(row: row, section: section)
        guard !indexPathForVisibleRows.contains(where: {$0 == indexPath}) else{return}
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func scrollTableView(to indexPath: IndexPath){
        guard let indexPathForVisibleRows = tableView.indexPathsForVisibleRows
        else{return}
        if !indexPathForVisibleRows.contains(where: {$0 == indexPath}){
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }else{
            if let cell = tableView.cellForRow(at: indexPath){
                let cellRect = tableView.rectForRow(at: indexPath)
                let completelyVisible = tableView.bounds.contains(cellRect)
                print(completelyVisible)
                tableView.scrollRectToVisible(cellRect, animated: true)
            }
        }
    }
    
    func handleSuccess(type: SearchSuccessType){
        DispatchQueue.main.async {
            switch type{
            case .fetchData(let categories):
                self.categories = categories
                self.tableView.reloadData()
                guard let searchKeyword = self.searchKeyword else{return}
                self.searchBar.text = searchKeyword
                self.presenter?.userSearchFor(searchKeyword)
                self.searchKeyword = nil
            case .search(let categories):
                self.categories = categories
                self.tableView.reloadData()
            }
        }
    }
    
    func handleError(error: Error){
        if let error = error as? CustomError{
            //TODO: Break down each error if necessary
            print("\(String(describing: self)) \(error.errorDescription)")
        }else{
            print("\(String(describing: self)) \(error)")
        }
    }
}

//MARK: UISearchBarDelete
extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        presenter?.userSearchFor(textSearched)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        presenter?.shouldEndSearch()
        return true
    }
}

//MARK: TableView related code
extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryTableViewCell
        let searchCriteria = searchBar.text == "" ? nil:searchBar.text
        let parentCategory = categories[indexPath.section]
        guard let category = parentCategory.child?[indexPath.row] else{return cell}
        cell.delegate = self
        cell.setupData(category: category, searchCriteria: searchCriteria, depth: 2)
        cell.accessibilityIdentifier = "searchCellS\(indexPath.section)R\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isExpanded = categories[section].isExpanded
        return isExpanded ? categories[section].child?.count ?? 0:0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CategoryTableViewHeader(frame: .zero)
        let searchCriteria = searchBar.text == "" ? nil:searchBar.text
        view.setupData(category: categories[section], searchCriteria: searchCriteria, depth: 1)
        view.delegate = self
        view.accessibilityIdentifier = "searchHeader\(section)"
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 // Set your desired header height here
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHeightOfCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

//MARK: Section to handle any delegate call from CategoryCollectionViewCell or CategoryTableViewCell
extension SearchViewController: CategoryTableViewCellDelegate{
    func userSelectChildCategory(category: Category) {
        var indexPath: IndexPath?
        guard let _ = categories.enumerated().first(where: {
            let element = $0.element
            let section = $0.offset
            let children = element.child ?? []
            return (children.enumerated().first(where: {
                let contain = $0.element === category
                if contain{
                    indexPath = IndexPath(row: $0.offset, section: section)
                }
                return contain
            }) != nil)
            
        })?.offset,
              let indexPath = indexPath
        else{return}
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        guard category.isExpanded else{return}
        
        //FIXME: Currently hardcoded this delay to let tableView to update its data before we asked them to make certain cell fully visible by scrolling
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            self.scrollTableView(to: indexPath)
            
        })
    }
    
    func userSavedCategory(category: Category) {
        delegate?.didFinishPicking(category: category)
    }
    
    func userSelectParentCategory(category: Category){
        guard let index = categories.enumerated().first(where: {
            let element = $0.element
            if category === element{
                return true
            }else{
                let children = element.child ?? []
                return children.contains(where: {$0 === category})
            }
        })?.offset
        else{return}
        
        tableView.beginUpdates()
        tableView.reloadSections([index], with: .automatic)
        tableView.endUpdates()
        guard category.isExpanded else{return}
        scrollTableView(to: index)
    }
}
