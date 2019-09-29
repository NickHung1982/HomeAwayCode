//
//  MainTableViewController.swift
//  HomeAwayCode
//
//  Created by Nick on 9/28/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    //init view model
    let viewModel = MainViewModel(Source: .All)
    //create a indicator
    lazy var loadingIdicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    fileprivate var isFilterring = false
    fileprivate var filtered = [EventItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add indicator
        let leftButton = UIBarButtonItem(customView: loadingIdicator)
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
        //add type change
        let rightButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(changeSource))
        self.navigationItem.setRightBarButton(rightButton, animated: true)
        
        //use large title
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //add search bar
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
        initBinding()
        viewModel.start()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let favlist = Helper.readFavList() {
            if favlist != viewModel.favList {
                viewModel.rebindDataWithFav()
            }
        }
    }
    
    private func initBinding() {
        viewModel.eventList.addObserver(fireNow: false) { [weak self] ([EventItem]) in
            self?.tableView.reloadData()
        }
        
        viewModel.isTableViewHidden.addObserver { [weak self] (isHidden) in
            self?.tableView.isHidden = isHidden
        }
        
        viewModel.title.addObserver { [weak self] (title) in
            print("now title: \(title)")
            self?.navigationItem.title = title
        }
        
        viewModel.isLoading.addObserver { [weak self] (isLoading) in
            if isLoading {
                self?.loadingIdicator.startAnimating()
            } else {
                self?.loadingIdicator.stopAnimating()
            }
        }
        
    }
    
    @objc func changeSource() {
        let alertController = UIAlertController(title: "Change game source", message: nil, preferredStyle: .actionSheet)
        
        for name in Source.allCases {
            alertController.addAction(UIAlertAction(title: "\(name)",
                style: .default,
                handler: { (action) in
                    self.viewModel.changeSource(source: name)
            }))
        }
        
        let cancel = UIAlertAction(title: "DISMISS", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isFilterring) {
            return filtered.count
        }
        return viewModel.eventList.value.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainTableViewCell
        
        let item: EventItem
        if (isFilterring) {
            item = filtered[indexPath.row]
        }else{
            item = viewModel.eventList.value[indexPath.row]
        }
        
        cell.setupTextData(feed: item)
        //get image from link
        for li in item.performers {
            if let imgLink = li.image {
                viewModel.getImage(withURL: URL(string: imgLink)!, completion: { img in
                    DispatchQueue.main.async {
                        cell.thumbImageView.image = img
                    }
                })
                break
            }
        }
        //check isFav
        
        
        
        return cell
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let item = viewModel.eventList.value[indexPath.row]
         self.performSegue(withIdentifier: "pushToDetail", sender: item)
    }
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToDetail" {
            let dist = segue.destination as! DetailViewController
            if let data = sender as? EventItem {
                dist.viewModel = DetailViewModel(item: data)
            }
            
        }
    }
}


extension MainTableViewController: UISearchResultsUpdating {

    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = viewModel.eventList.value.filter({ (event) -> Bool in
                return event.title.lowercased().contains(text.lowercased())
            })
            self.isFilterring = true
            
        }
        else {
            //clean filter data
            self.isFilterring = false
            self.filtered = [EventItem]()
        }
        
        self.tableView.reloadData()
    }
}

