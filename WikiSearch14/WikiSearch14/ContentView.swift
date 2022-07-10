//
//  ContentView.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/08.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        // iOSのバージョンが15.0以降なら実行
        if #available(iOS 15.0, *) {
            // 昔の表示に変える
            UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
        }
    }
    
    var body: some View {
        WikiSearchView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
