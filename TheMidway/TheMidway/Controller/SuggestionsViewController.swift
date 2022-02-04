//
//  SuggestionsViewController.swift
//  TheMidway
//
//  Created by Leticia Utsunomiya on 01/02/22.
//

import UIKit
import CoreLocation

class SuggestionsViewController: UIViewController, SuggestionsControllerDelegate {

    /* MARK: - Atributos */
    
    private let mainView = SuggestionsView()
    private var mainWord: String = ""
    
    private let apiManeger = ApiManeger()
    
    private var suggestionsPlaces: [MapPlace] = []
    private var placeSelected: MapPlace!
    
    private let formsLink: String = "https://forms.gle/VFw6XT9vC7c2DUCdA"
    
    // Delegate e DataSources
    private var mainProtocol: MainControllerDelegate
    
    private let suggestionsCollectionDelegate = SuggestionsCollectionDelegate()
    private let suggestionsCollectionDataSource = SuggestionsCollectionDataSource()
    
    
    
    /* MARK: -  */
    
    init(mainWord: String, delegate: MainControllerDelegate) {
        self.mainProtocol = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        self.mainWord = mainWord
        
        // self.getSuggestions()
    }

    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}


    
    /* MARK: - Ciclo de Vida */
    
    public override func loadView() -> Void {
        super.loadView()
        
        self.view = self.mainView
    }
    
    
    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        self.isModalInPresentation = true
        
        
        self.configureNavBar()
        
        self.mainView.setImage(name: self.mainWord)
        
        
        // Empty View
        let emptyViewText: String = "Poxa, não foi possível te mandar as nossas sugestões. Tente novamente mais tarde"
        
        self.mainView.setEmptyViewInfo(
            img: "PlacesEmptyView",
            label: LabelConfig(text: emptyViewText, sizeFont: 20, weight: .regular),
            button: LabelConfig(text: "", sizeFont: 15, weight: .medium)
        )
        self.mainView.activateEmptyView(num: 0)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) -> Void {
        super.viewWillAppear(animated)
        
        self.suggestionsCollectionDataSource.setPlacesFound(self.suggestionsPlaces)
        
        // Define os protocolos
        self.suggestionsCollectionDelegate.setProtocol(self)
        self.suggestionsCollectionDataSource.setProtocol(self)
        
        // Define o delegate e dataSource
        self.mainView.setSuggestionsCollectionDelegate(self.suggestionsCollectionDelegate)
        self.mainView.setSuggestionsCollectionDataSource(self.suggestionsCollectionDataSource)
    }
 
    
    
    /* MARK: - Delegate (Protocol) */
    
    /// Recarrega os dados da CollectionView
    internal func reloadCollectionData() -> Void {
        self.suggestionsCollectionDataSource.setPlacesFound(self.suggestionsPlaces)
        self.mainView.updateSuggestionsCollectionData()
    }
    
    
    /// Pega a lista de lugares sugeridos
    internal func getSuggestionsPlaces() -> [MapPlace] {
        return self.suggestionsPlaces
    }
    
    
    /// Pega a lista de lugares sugeridos
    internal func createNewMeeting(with place: MapPlace) -> Void {
        self.placeSelected = place
        
        let ac = UIAlertController(
            title: "Novo encontro",
            message: "Deseja criar um novo encontro a partir do local sugerido",
            preferredStyle: .actionSheet
        )
        ac.addAction(UIAlertAction(title: "Cancelar", style: .destructive) {[] action in
            self.dismiss(animated: true)}
        )
        
        ac.addAction(UIAlertAction(title: "Criar encontro", style: .cancel) {[] action in
            self.createNewMeetingAction()}
        )
        
        self.present(ac, animated: true)
    }
    
    
    /// Botão para abrir o safari
    @objc internal func setWebButtonAction(_ button: UIButton) -> Void {
        button.addTarget(self, action: #selector(self.webButtonAction(sender:)), for: .touchDown)
    }
    
    
    
    /* MARK: - Ações dos botões */
    
    @objc private func cancelAction() -> Void {
        self.dismiss(animated: true)
    }
    
    
    @objc private func createNewMeetingAction() -> Void {
        let vc = NewMeetingViewController(delegate: self.mainProtocol, place: self.placeSelected)
        self.showViewController(with: vc)
    }
    
    
    /// Abre a tela web
    @objc private func webButtonAction(sender: UIButton) -> Void {
        let vc = WebViewController(placeQuery: self.suggestionsPlaces[sender.tag])
        self.showViewController(with: vc)
    }
    
    
    /// Abre a tela de formulário para novo encontro
    @objc private func openNewSuggestionForms(sender: UIButton) -> Void {
        let vc = WebViewController(placeQuery: self.formsLink)
        self.showViewController(with: vc)
    }
        
    
    
    
    /* MARK: - Configurações */
        
    
    /// Configura a NavBar da classe
    private func configureNavBar() -> Void {
        // self.title = "Sugestões"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancelar",
            style: .plain,
            target: self,
            action: #selector(self.cancelAction)
        )
        self.navigationItem.leftBarButtonItem?.tintColor = .systemRed
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Nova sugestão",
            style: .plain,
            target: self,
            action: #selector(self.openNewSuggestionForms)
        )
    }
    
    
    /// Pega os lugares de sugestão da API a partir da palavra chave
//    private func getSuggestions() -> Void {
//        self.apiManeger.getSuggetions(with: self.mainWord) { result in
//            switch result {
//            case .success(let suggestionsPlaces):
//                self.suggestionsPlaces = suggestionsPlaces
//
//                self.reloadCollectionData()
//
//            case .failure(let error):
//                self.mainView.setEmptyViewText(error.localizedDescription)
//            }
//        }
//    }
    
    
    private func getSuggestions() -> Void {
        self.suggestionsPlaces = [
            MapPlace(
                name: "Muza",
                coordinates: CLLocationCoordinate2D(latitude: -23.495333, longitude: -46.868243),
                pin: nil,
                type: .restaurant,
                addressInfo: AddressInfo(
                    postalCode: "06414-007",
                    country: "BR",
                    city: "SP",
                    district: "Barueri",
                    address: "Avenida Sebastião Davino dos Reis",
                    number: "101"
                )
            ),
            MapPlace(
                name: "Gui Reis",
                coordinates: CLLocationCoordinate2D(latitude: -23.713213, longitude: -46.536622),
                pin: nil,
                type: .nightlife,
                addressInfo: AddressInfo(
                    postalCode: "09770-200",
                    country: "BR",
                    city: "SP",
                    district: "São Bernardo do Campo",
                    address: "Rua Nicola Spinelli",
                    number: "469"
                )
            ),
            MapPlace(
                name: "Leh",
                coordinates: CLLocationCoordinate2D(latitude: -23.627604, longitude: -46.637000),
                pin: nil,
                type: .cafe,
                addressInfo: AddressInfo(
                    postalCode: "04304-000",
                    country: "BR",
                    city: "SP",
                    district: "São Paulo",
                    address: "Avenida Fagundes Filho",
                    number: "470"
                )
            ),
            MapPlace(
                name: "Muza",
                coordinates: CLLocationCoordinate2D(latitude: -23.495333, longitude: -46.868243),
                pin: nil,
                type: .restaurant,
                addressInfo: AddressInfo(
                    postalCode: "06414-007",
                    country: "BR",
                    city: "SP",
                    district: "Barueri",
                    address: "Avenida Sebastião Davino dos Reis",
                    number: "101"
                )
            ),
            MapPlace(
                name: "Gui Reis",
                coordinates: CLLocationCoordinate2D(latitude: -23.713213, longitude: -46.536622),
                pin: nil,
                type: .nightlife,
                addressInfo: AddressInfo(
                    postalCode: "09770-200",
                    country: "BR",
                    city: "SP",
                    district: "São Bernardo do Campo",
                    address: "Rua Nicola Spinelli",
                    number: "469"
                )
            ),
            MapPlace(
                name: "Leh",
                coordinates: CLLocationCoordinate2D(latitude: -23.627604, longitude: -46.637000),
                pin: nil,
                type: .cafe,
                addressInfo: AddressInfo(
                    postalCode: "04304-000",
                    country: "BR",
                    city: "SP",
                    district: "São Paulo",
                    address: "Avenida Fagundes Filho",
                    number: "470"
                )
            ),
            MapPlace(
                name: "Muza",
                coordinates: CLLocationCoordinate2D(latitude: -23.495333, longitude: -46.868243),
                pin: nil,
                type: .restaurant,
                addressInfo: AddressInfo(
                    postalCode: "06414-007",
                    country: "BR",
                    city: "SP",
                    district: "Barueri",
                    address: "Avenida Sebastião Davino dos Reis",
                    number: "101"
                )
            ),
            MapPlace(
                name: "Gui Reis",
                coordinates: CLLocationCoordinate2D(latitude: -23.713213, longitude: -46.536622),
                pin: nil,
                type: .nightlife,
                addressInfo: AddressInfo(
                    postalCode: "09770-200",
                    country: "BR",
                    city: "SP",
                    district: "São Bernardo do Campo",
                    address: "Rua Nicola Spinelli",
                    number: "469"
                )
            ),
            MapPlace(
                name: "Leh",
                coordinates: CLLocationCoordinate2D(latitude: -23.627604, longitude: -46.637000),
                pin: nil,
                type: .cafe,
                addressInfo: AddressInfo(
                    postalCode: "04304-000",
                    country: "BR",
                    city: "SP",
                    district: "São Paulo",
                    address: "Avenida Fagundes Filho",
                    number: "470"
                )
            )
        ]
        
        self.suggestionsCollectionDataSource.setPlacesFound(self.suggestionsPlaces)
        self.reloadCollectionData()
    }
}
