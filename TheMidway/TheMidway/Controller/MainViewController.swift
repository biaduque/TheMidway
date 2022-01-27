//
//  MainViewController.swift
//  TheMidway
//
//  Created by Gui Reis on 18/01/22.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController,
                          UICollectionViewDelegate, UICollectionViewDataSource,
                          UITableViewDelegate, UITableViewDataSource{

    /* MARK: - Atributos */
    
    /// View
    private let mainView = MainView()
    
    private let sugestionTypes: [String] = ["Restaurante", "Bar", "Cafeteria", "Cinema", "Padaria", "Shopping", "Teatro"]
    
    private var meetings: [Meetings] = []
    
    
    
    /* MARK: - Ciclo de Vida */
    
    public override func loadView() -> Void {
        super.loadView()
        
        self.view = self.mainView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
                
        self.mainView.setTitles(
            suggestionText: "Sugestões de Locais",
            meetingText: "Meus Encontros",
            sizeFont: 30,
            w: .bold
        )
        
        self.mainView.newMeetingButton.addTarget(self, action: #selector(self.newMeetingAction), for: .touchDown)
        
        // Empty View
        let emptyViewText: String = "Você ainda não possui nenhum encontro marcado. Clique em ”+” para marcar!"
        
        self.mainView.setEmptyViewInfo(
            img: "MeetingsEmptyView",
            label: LabelConfig(text: emptyViewText, sizeFont: 15, weight: .regular),
            button: LabelConfig(text: "Criar novo encontro", sizeFont: 15, weight: .medium))
        
        self.mainView.getEmptyViewButton().addTarget(self, action: #selector(self.newMeetingAction), for: .touchDown)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        self.mainView.meetingsTableView.delegate = self
        self.mainView.meetingsTableView.dataSource = self
        
        self.mainView.suggestionCollection.delegate = self
        self.mainView.suggestionCollection.dataSource = self
        
        self.reloadDataMeetingsTableView()
    }

    
    
    /* MARK: - Delegate (Collection) */
    
    /// Mostra quantas células vão ser mostradas
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sugestionTypes.count
    }
    
    
    /// Configura uma célula
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cria uma variácel para mexer com uma célula que foi criada
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCollectionCell.identifier, for: indexPath) as? MainViewCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.setContentView(text: self.sugestionTypes[indexPath.row], sizeFont: 20, w: .medium)
        
        return cell
    }
    
    
    /// Ação de quando clica em uma célula
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(self.sugestionTypes[indexPath.row]) selecionado.")
    }
    
    
    
    /* MARK: - Delegate (Table) */

    /// Quantidade de células que vai ter na table
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetings.count
    }
    
    
    /// Cria o conteúdo da célula
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Cria uma variável para mexer com uma célula que foi criada
        guard let cell = self.mainView.meetingsTableView.dequeueReusableCell(withIdentifier: MainViewTableCell.identifier, for: indexPath) as? MainViewTableCell else {
            return MainViewTableCell()
        }
        
        let infos = MeetingCreatedCellInfo(
            title: LabelConfig(
                text: self.meetings[indexPath.row].meetingName ?? "Título",
                sizeFont: 20, weight: .bold
            ),
            date: LabelConfig(
                text: self.meetings[indexPath.row].date ?? "",
                sizeFont: 14, weight: .regular
            ),
            hour: self.meetings[indexPath.row].hour ?? "",
            participants: ["Gui", "Anna", "Leh", "Bia", "Muza"],
            participantsConfig: LabelConfig(text: "", sizeFont: 11, weight: .regular)
        )
        
        cell.setCellInfo(info: infos)
        
        return cell
    }
    
    
    
    /* MARK: - Datasource */
    
    public func reloadDataTableView() -> Void {
        // self.meetings = MeetingCDManeger.shared.getMeetingsCreated()
        
        print("\nEncontros - \(self.meetings.count)")
        
        self.mainView.meetingsTableView.reloadData()
        // self.mainView.meetingsTableView.alwaysBounceVertical = false
    }
    
    
    
    /* MARK: - Ações dos botões */
    
    @objc private func newMeetingAction() -> Void {
        
        let vc = NewMeetingViewController()
        vc.modalPresentationStyle = .popover

        self.present(vc, animated: true)
        
        
//        let placeInfo = MapPlace(
//            name: "Olivio Bar",
//            coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0),
//            pin: nil,
//            type: .restaurant,
//            postalCode: "09770-299",
//            country: "BR",
//            city: "SP",
//            district: "Vila Madalena",
//            address: "Delfina Street",
//            number: "196"
//        )
//
//        let data = MeetingCreated(
//            placeInfo: placeInfo,
//            date: "01/02/22",
//            hour: "19:00",
//            meetingName: "Encontro Test",
//            participants: []
//        )
//
//        guard let _ = try? MeetingCDManeger.shared.newMeeting(data: data) else {
//            print("\n\nErro na hora de salvar o encontro no CoreData\n\n")
//            return
//        }
//
//        self.reloadDataMeetingsTableView()
    }
    
    
    
    /* MARK: - Configurações*/
    
    public func reloadDataMeetingsTableView() -> Void {
        self.meetings = MeetingCDManeger.shared.getMeetingsCreated()
        
        print("\nEncontros no core data: \(self.meetings.count)")
        
        self.mainView.meetingsTableView.reloadData()
        
        self.mainView.activateEmptyView(num: self.meetings.count)
    }
}
