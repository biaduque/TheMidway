//
//  EncontrosViewController.swift
//  TheMidway
//
//  Created by Beatriz Duque on 24/11/21.
//

import UIKit
import CoreData


class EncontrosViewController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var collectionEncontro: [Encontro] = []
    
    
    private lazy var fetchResultController: NSFetchedResultsController<Encontro> = {
        let request: NSFetchRequest<Encontro> = Encontro.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Encontro.data, ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: EncontroData.shared.contenxt,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //self.collectionEncontro = EncontroData.shared.getEncontro()

        
        ///atualizacao da collection
        do {
            try fetchResultController.performFetch()
            self.collectionEncontro = fetchResultController.fetchedObjects ?? []
        } catch {
            fatalError("erro")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let vc = storyboard?.instantiateViewController(identifier: "novoEncontro") as?
            NovoEncontroViewController {
            vc.delegate = self
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let nemEncontro = controller.fetchedObjects as? [Encontro] else { return }
        self.collectionEncontro = nemEncontro
        tableView.reloadData()
    }

}

// MARK: TableView

extension EncontrosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            ///clique na celula
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadInputViews()
            print(collectionEncontro[indexPath.row].amigos as Any)
        }
}
extension EncontrosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionEncontro.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EncontroCell", for: IndexPath(index: indexPath.row)) as! EncontrosTableViewCell
        if collectionEncontro.count != 0 {
            cell.style(encontro: collectionEncontro[indexPath.row])
    
        }
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                   // Deleta esse item aqui
                   completionHandler(true)
            try! EncontroData.shared.deleta(item: (self.collectionEncontro[indexPath.row]))
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}


extension EncontrosViewController: NovoEncontroViewControllerDelegate{
    func didReload() {
        collectionEncontro = EncontroData.shared.getEncontro()
        self.tableView.reloadData()
    }
}
