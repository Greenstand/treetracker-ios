//
//  ViewTreesViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 10/27/20.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class ViewTreesViewController: UIViewController {
    var viewModel: ViewTreesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
   @IBOutlet weak var viewTrees: UICollectionView!
   //private let treeMonitoringService: TreeMonitoringService

    override func viewDidLoad() {
        super.viewDidLoad()

         viewTrees.delegate = self
         viewTrees.dataSource = self
         viewTrees.register(ViewTreesCollectionViewCell.self, forCellWithReuseIdentifier: "ViewTreesCollectionViewCell")
         viewModel?.fetchTrees()

    }
}

extension ViewTreesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = viewTrees.dequeueReusableCell(withReuseIdentifier: "ViewTreesCollectionViewCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }

}

// MARK: - ViewTreesViewModelViewDelegate
extension ViewTreesViewController: ViewTreesViewModelViewDelegate {
    func viewTreesViewModel(_ viewTreesViewModel: ViewTreesViewModel, didReceiveError error: Error){
        
    }
    func viewTreesViewModel(_ viewTreesViewModel: ViewTreesViewModel, didUpdateTreeCount data: ViewTreesViewModel.TreeCountData){
        
    }
    
}
