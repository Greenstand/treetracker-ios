//
//  ViewTreesViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 10/27/20.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class ViewTreesViewController: UIViewController, AlertPresenting {
    var trees: [Tree] = [] {
        didSet {
            viewTreesCollectionView.reloadData()
        }
    }
    var viewModel: ViewTreesViewModel? {
        didSet {
            viewModel?.viewDelegate = self
            title = viewModel?.title
        }
    }
    @IBOutlet weak var viewTreesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTreesCollectionView.dataSource = self
        viewModel?.fetchTrees()
    }
}
// MARK: - CollectionView cell implementation
extension ViewTreesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trees.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewTreesCollectionViewCell", for: indexPath) as? ViewTreesCollectionViewCell
        let tree = trees[indexPath.item]
        if let photoURL = tree.photoURL {
        let url = URL(string: photoURL)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    let image: UIImage = UIImage(data: data!)!
                    cell?.treesImage.image = image
                    }
                }
        }
    return cell!
    }
}
// MARK: - ViewTreesViewModelViewDelegate
extension ViewTreesViewController: ViewTreesViewModelViewDelegate {
    func viewTreesViewModel(_ viewTreesViewModel: ViewTreesViewModel, didUpdateTrees trees: [Tree]) {
        self.trees = trees
    }
    func viewTreesViewModel(_ viewTreesViewModel: ViewTreesViewModel, didReceiveError error: Error) {
        present(alert: .error(error))
    }
}
