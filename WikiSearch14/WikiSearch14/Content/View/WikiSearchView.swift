//
//  WikiSearchView.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/08.
//

import SwiftUI

struct WikiSearchView: View {
    
    // ViewModel
    @StateObject var viewModel = WikiSearchViewModel(wikiSearchCall: WikiSearchCall())
    
    var body: some View {
        SearchView(viewModel: viewModel)
    }
}

struct WikiSearchView_Previews: PreviewProvider {
    static var previews: some View {
        WikiSearchView()
    }
}
