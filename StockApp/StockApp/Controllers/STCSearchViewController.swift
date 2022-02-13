//
//  ViewController.swift
//  StockApp
//
//  Created by Paolo Prodossimo Lopes on 08/10/21.
//

import UIKit
import Combine

private let REUSE_IDENTIFIER = "STCSearchViewCell"

final class STCSearchViewController: STCCustomTableViewControllerProtocol, UIAnimatable {
    
    //MARK: - Properties
    
    private let apiService = APIService()
    
    private var assets: [AssetModel] = []
    
    private let searchController = STCSearchController()
    private let refreshController = UIRefreshControl()
    private let footerActivityIndicator = UIActivityIndicatorView()
    private let placeholderImage = SearchPlaceholderView()
    
    private var cancelables = Set<AnyCancellable>()
    
    @Published private var searchQuery = String()
    @Published private var mode: StateMode = .onboarding
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "FIND YOUR ASSET"
        
        configureTableView()
        observerForm()
        commonInit()
    }
    
    //MARK: - Helpers
    
    func configureHierarchy() {
        navigationItem.searchController = searchController
    }
    
    func configureConstraints() { }
    
    func configureStyle() {
        let customCollorApp: UIColor = .init(red: 35/255, green: 84/255, blue: 177/255, alpha: 1)
        
        navigationController?.navigationBar.barStyle = .black

        navigationController?.navigationBar.barTintColor = customCollorApp
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        view.backgroundColor = customCollorApp
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.hidesBarsOnSwipe = true
        
        // For especifc objc became transparent
        //        navBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //           navBar.shadowImage = UIImage()
        //           navBar.navigationBar.isTranslucent = true
        
        refreshController.tintColor = .white
    }
    
    private func configureTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchBarDelegate = self
        
        tableView.refreshControl = refreshController
        tableView.tableFooterView = UIView()
        tableView.backgroundView = footerActivityIndicator
        
        tableView.register(STCSearchViewCell.self, forCellReuseIdentifier: REUSE_IDENTIFIER)
        
        refreshController.addTarget(self, action: #selector(swipeHandle), for: .valueChanged)
    }
    
    private func observerForm() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [weak self] (searchText) in
                self?.performSearch(text: searchText)
                
            }.store(in: &cancelables)
        
        $mode.sink { [weak self] (mode) in
            switch mode {
            case .onboarding:
                self?.tableView.backgroundView = self?.placeholderImage
                
            case .searching:
                self?.tableView.backgroundView = self?.footerActivityIndicator
            }
            
        }.store(in: &cancelables)
    }
    
    
    //MARK: - API
    private func performSearch(text: String = "S&P500") {
        
        if !searchController.isActive { return }
        
        mode = .searching
        
        if !text.isEmpty {
            self.footerActivityIndicator.center = self.tableView.center
            self.footerActivityIndicator.startAnimating()
            self.footerActivityIndicator.isHidden = false

        }
        
        assets.removeAll()
        
        DispatchQueue.main.async { self.tableView.reloadData() }
        
        let keyword: String = text
        apiService.fetchSymbolsPublisher(keyword)
            .sink(receiveCompletion: { (completion) in
                
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: ",error.localizedDescription)
                }
                
            }, receiveValue: { [weak self] (results) in
                
                results.bestMatches.forEach { self?.assets.append($0) }
                
                DispatchQueue.main.async {
                    
                    if results.bestMatches.isEmpty {
                        print("nada foi encontrado")
                    }
                    
                    self?.refreshController.endRefreshing()
                    
                    self?.footerActivityIndicator.stopAnimating()
                    self?.footerActivityIndicator.isHidden = true
                    
                    self?.tableView.reloadData()
                }
                
            }).store(in: &cancelables)
    }
    
    private func handleSeletion(for symbol: String, completiono: @escaping ((_ Offer: TimeSerieMonthyAdjust)->())) {
        
        apiService.fetchTimeSeriesMonthlyAdjustedPublisher(symbol).sink { [weak self] (completionResult) in
            self?.hideShowAnimating()
            switch completionResult {
                case .failure(let error):
                    print(error)
                case .finished: break
            }
            
        } receiveValue: { [weak self] (timeSeriesMonthlyAdjusted) in
            self?.hideShowAnimating()
            completiono(timeSeriesMonthlyAdjusted)
            
        }.store(in: &cancelables)
    }
    
    //MARK: - Selectors
    
    @objc private func swipeHandle() {
        if !(searchController.isActive) { performSearch() }
    }
    
}

//MARK: - Delegate & DataSource

extension STCSearchViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: REUSE_IDENTIFIER, for: indexPath) as! STCSearchViewCell
        cell.assetModel = assets[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assetModel = assets[indexPath.row]
        
        var offer: TimeSerieMonthyAdjust?
        let symbol = assetModel.symbol
        
        handleSeletion(for: symbol) { (offers) in
            offer = offers
        }
        
        let assetOffer = AssetOffer(assetsModel: assetModel, assetsOffers: offer)
        let vc = STCAssetDetailViewController(assetModel: assetOffer)
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//MARK: - STCSearchControllerDelegate

extension STCSearchViewController: STCSearchControllerDelegate {
    func willDismissSearchController(_ searchController: UISearchController) {
        let searchBarDisable = !searchController.isActive,
            emptyAssets = assets.isEmpty
        
        if searchBarDisable && emptyAssets { tableView.backgroundView = placeholderImage }
    }
    
    func updateSearchResults(_ searchController: UISearchController) {
        guard let scQuery = searchController.searchBar.text, (!scQuery.isEmpty) else { return }
        self.searchQuery = scQuery
    }
}



