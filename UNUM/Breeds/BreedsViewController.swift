//
//  BreedViewController.swift
//  UNUM
//
//  Created by Matthew Pileggi on 4/11/18.
//  Copyright © 2018 Matthew Pileggi. All rights reserved.
//

import UIKit

class BreedsViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var breedTable: UITableView!
    
    
    //MARK: Properties
    
    fileprivate var viewModel: BreedsViewModel!
    
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupBreedTable()
        setupData()
    }
    
    
    //MARK: Setup
    
    private func setupViewModel() {
        viewModel = BreedsViewModel()
        viewModel.delegate = self
    }
    
    private func setupBreedTable() {
        breedTable.delegate = self
        breedTable.dataSource = self
        
        breedTable.estimatedRowHeight = 80
        breedTable.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupData() {
        viewModel.getBreeds()
    }
    
}

extension BreedsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "breed", for: indexPath) as! BreedsTableViewCell
        let modelData = viewModel.getModelData(forIndex: indexPath.row)
        cell.load(name: modelData.0, image: modelData.1)
        return cell
    }
}

extension BreedsViewController: BreedsAvailableDelegate {
    
    func breedsAvailable() {
        DispatchQueue.main.async {
            self.breedTable.reloadData()
        }
    }
    
    func imageAvailable(atIndex index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        
        DispatchQueue.main.async {
            let image = self.viewModel.getModelData(forIndex: index).1
            guard let cell = self.breedTable.cellForRow(at: indexPath) as? BreedsTableViewCell else { return }
            cell.breedImage.image = image
        }
    }
    
}



