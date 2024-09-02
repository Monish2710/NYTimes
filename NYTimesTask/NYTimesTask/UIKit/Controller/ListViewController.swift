//
//  ListViewController.swift
//  NYTimesTask
//
//  Created by Monish Kumar on 02/09/24.
//

import CoreData
import SwiftUI
import UIKit

struct ListViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: ListViewController())
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Update the view controller if needed
    }
}

class ListViewController: UIViewController, ActivityIndicatorViewable {
    lazy var fetchController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: NYTimesDataModel.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "newsPublishedDate", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistenceManager.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        return controller
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.insetsContentViewsToSafeArea = true
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .lightGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        return tableView
    }()

    private var dataViewModel = DataViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        initViewModel()
    }

    private func setupUI() {
        startAnimating(CGSize(width: 150, height: 150), message: "Loading...", type: .ballScaleMultiple, fadeInAnimation: nil)
        setupNavigation()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.spaceAround()
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ListTableViewCell.self))
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupNavigation() {
        title = "NY Times"
        navigationController?.navigationBar.isHidden = false
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
    }

    private func initViewModel() {
        do {
            try fetchController.performFetch()
        } catch let error {
            print("ERROR: \(error)")
        }
        dataViewModel.showError = {
            DispatchQueue.main.async {
                self.showAlert("Ups, Something Went Wrong")
            }
        }
        dataViewModel.showLoading = {
            DispatchQueue.main.async { ActivityIndicatorPresenter.sharedInstance.setMessage("Fetching...") }
        }
        dataViewModel.hideLoading = { }
        dataViewModel.getResponseData { response in
            self.clearData()
            self.saveInCoreDataWith(array: response)
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.sections?.first?.numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ListTableViewCell.self), for: indexPath) as? ListTableViewCell else {
            stopAnimating()
            fatalError("The dequeued cell is not an instance of TableViewCell.")
        }
        if let response = fetchController.object(at: indexPath) as? NYTimesDataModel {
            cell.configue(data: response)
        }
        stopAnimating()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let response = fetchController.object(at: indexPath) as? NYTimesDataModel {
            let viewController = DetailsViewController(urlString: response.url ?? "www.google.com")
            let navController = UINavigationController(rootViewController: viewController)
            navController.modalPresentationStyle = .formSheet
            present(navController, animated: true, completion: nil)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

