//
//  SearchExtensions.swift
//  volgMe
//
//  Created by Toine Schnabel on 06/10/2018.
//  Copyright © 2018 Toine Schnabel. All rights reserved.
//

import Foundation
import UIKit
extension LogBoekVC: UISearchResultsUpdating {
    
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
    }
    func initiateSearchBar()
    {
        let searchController = UISearchController(searchResultsController: nil)
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Mijn DagBoek"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        // Stop doing the search stuff
//        // and clear the text in the search bar
//        searchBar.text = ""
//        // Hide the cancel button
//        searchBar.showsCancelButton = false
//        // You could also change the position, frame etc of the searchBar
     zoekende = false
        tableViewDatum.reloadData()
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchText.count < 2 {zoekende = false
            tableViewDatum.reloadData()
            return
        }
        let adressen = fetchAdressen(containing: searchText)
        if let x = tabelData
        {
            x.zoekResultaten = [Date_70]()
            for adres in adressen {if (adres.bezocht?.count)! > 0
            {
                for bezoek in Array(adres.bezocht!) as! [Bezoek] {
                    x.zoekResultaten.append(bezoek.arrival_1970)
                    zoekende = true
                }
                }
            }
        }
        tableViewDatum.reloadData()
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
}
