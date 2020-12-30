//
//  ViewTreesViewController.swift
//  TreeTracker
//
//  Created by Remi Varghese on 10/27/20.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class ViewTreesViewController: UIViewController {

   // @IBOutlet weak var viewTrees: UICollectionView!
  //  private let treeMonitoringService: TreeMonitoringService

    override func viewDidLoad() {
        super.viewDidLoad()

//         viewTrees.delegate = self
//         viewTrees.dataSource = self
//         viewTrees.register(ViewTreesCollectionViewCell.self, forCellWithReuseIdentifier: "ViewTreesCollectionViewCell")
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension ViewTreesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let sections = VC.fetchedResultsController.sections else {
//        // error
//
//        }
//        let sectionInfo = sections[section]
//        return sectionInfo.numberOfObjects
//    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
//
//        let cell = viewTrees.dequeueReusableCell(withReuseIdentifier: "ViewTreesCollectionViewCell", for: indexPath)
//        guard let object = VC.fetchedResultsController.object(at:indexPath) else {
//            //show error
//        }
//        return cell
//    }
//
//}
