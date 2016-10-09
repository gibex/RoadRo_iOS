//
//  HistoryViewController.swift
//  RoadRo
//
//  Created by Mihai Dumitrache on 09/10/2016.
//  Copyright © 2016 Work In Progress. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
  
  fileprivate var dataProvider: HistoryDataProvider!
  fileprivate var dataSource: ObjectsTableViewDataSource<ReportTableViewCell, ReportViewModel>!
  fileprivate var delegate: ObjectsTableViewDelegate<ReportTableViewCell>!
  
  fileprivate var contentView: HistoryView { get { return self.view as! HistoryView } }
  fileprivate var config: Config
  
  var onSelectReport: ((_ model: ReportViewModel) -> Void)?
  
  init(config: Config) {
    self.config = config
    super.init(nibName: nil, bundle: nil)
    
    self.title = NSLocalizedString("Istoric", comment: "")
    self.tabBarItem = UITabBarItem(
      title: NSLocalizedString("Istoric", comment: ""),
      image: UIImage(named: "istoricDisabled"),
      selectedImage: UIImage(named: "istoricEnabled"))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    let view = HistoryView()
    self.view = view
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Data source
    self.setupDatasource()
  }
  
  fileprivate func setupDatasource() {
    let tableView = self.contentView.tableView
    self.dataProvider = HistoryDataProvider(config: config)
    
    // Init data source
    let dataSource = ObjectsTableViewDataSource<ReportTableViewCell, ReportViewModel>(
      tableView: self.contentView.tableView,
      cellReuseIdentifier: "cell",
      objectsProvider: dataProvider
    ) {(cell, object) in
      cell.configure(model: object)
    }
    self.dataSource = dataSource
    
    let delegate = ObjectsTableViewDelegate<ReportTableViewCell>(
      tableView: self.contentView.tableView,
      heightConfiguration: {(indexPath, width) -> CGFloat in
        return 60
      })
    delegate.selectionHandler = {[weak self] indexPath in
      if let object = self?.dataProvider.objectAtIndexPath(indexPath: indexPath) as? ReportViewModel {
        self?.onSelectReport?(object)
      }
    }
    
    self.delegate = delegate
    self.dataProvider.delegate = delegate
    
    tableView.dataSource = dataSource
    tableView.delegate = delegate
    tableView.refreshHandler = {[weak self] in
      self?.doRefresh()
    }
  }
  
  fileprivate func doRefresh() {
    print("do refresh")
    
    self.contentView.tableView.endRefreshing(animated: true)
  }
}
