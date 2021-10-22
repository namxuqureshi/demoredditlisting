//
//  DemoListingVC.swift
//  RedditDemo
//
//  Created by Muhammad Usman on 22/10/2021.
//

import UIKit

class DemoListingVC: UIViewController {

    var mData = [ListingsItems]()
    var mItem:RedditData? = nil
    var spinner = UIActivityIndicatorView.init(style: .large)
    var pullRefresher:UIRefreshControl = UIRefreshControl()
    private let tableView:UITableView = {
        let tbl = UITableView.init(frame: .zero)
        tbl.backgroundColor = .white
        tbl.allowsSelection = true
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.showsVerticalScrollIndicator = false
        tbl.layer.backgroundColor = UIColor.white.cgColor
        tbl.register(DemoItemCell.self, forCellReuseIdentifier: DemoItemCell.identifier)
        tbl.tableFooterView = UIView(frame: .zero)
        tbl.separatorStyle = .none
        tbl.sectionHeaderHeight = 0
        tbl.sectionFooterHeight = 0
        tbl.tableHeaderView = UIView()
        tbl.contentInsetAdjustmentBehavior = .never
        return tbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pullRefresher.tintColor = .black
        self.pullRefresher.shadowColorOverAll = .black
        spinner.color = UIColor.black
        spinner.hidesWhenStopped = true
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor)
        tableView.delegate = self
        tableView.dataSource = self
        self.pullRefresher.isHidden = false
        self.pullRefresher.tintColor = .black
        self.pullRefresher.addTarget(self, action: #selector(self.onSwipeRefresh), for: .valueChanged)
        self.pullRefresher.tintColor = .black
        self.tableView.refreshControl = self.pullRefresher
        self.pullRefresher.tintColor = .black
        self.tableView.tableHeaderView = self.spinner
        self.spinner.startAnimating()
        self.getItems()
    }
    
    @objc func onSwipeRefresh() {
        self.getItems()
    }
    // For getting api call with same func for paging call again
    func getItems(after:String? = nil){
        APIManager.sharedInstance.opertationWithRequest(withApi: API.getListing(after: after)) { APIResponse in
            self.pullRefresher.endRefreshing()
            self.spinner.stopAnimating()
            self.tableView.tableHeaderView = nil
            switch APIResponse{
                
            case .Success(let data):
                self.mItem = data?.data as? RedditData ?? nil
                if after == nil{
                    self.mData.removeAll()
                }
                self.mData.append(contentsOf: self.mItem?.children ??  ArrayList())
                self.tableView.reloadData()
                break
            case .Failure(let error):
                print(error?.message ?? "")
                break
            case .Progress(_):
                break
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

extension DemoListingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = mData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: DemoItemCell.identifier, for: indexPath) as! DemoItemCell
        
        cell.setupCell(item.data)
        if (mData.count - 1) == indexPath.row{
            self.callPaging()
        }

        return cell
    }
    
    
    func callPaging(){
        if self.mData.count > 10 && !self.spinner.isAnimating{
            self.tableView.tableFooterView = self.spinner
            self.spinner.startAnimating()
            self.getItems(after: self.mItem?.after)
        }
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maximumOffset - currentOffset) < 5{
            self.callPaging()
        }
    }
    
}
