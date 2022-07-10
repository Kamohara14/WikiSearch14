//
//  SearchView.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/09.
//

import SwiftUI

struct SearchView: View {
    
    @ObservedObject var viewModel: WikiSearchViewModel
    
    // 入力された文字を受け取る
    @State var text: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("検索ワード：\(text)")
                    Spacer()
                }
                Spacer()
                if viewModel.isLoading {
                    // ロード開始
                    Text("検索中...")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .offset(x: 0, y: -200)
                } else {
                    // ロード終了
                    ResultView(input: viewModel.resultViewInoput)
                }
                Spacer()
                
            } // VS
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    TextField("検索キーワードを入力", text: $text) {
                        // スペースを取り除く
                        text = text.trimmingCharacters(in: .whitespaces)
                        // 検索欄が入力されていない場合は無を表示
                        if text != "" {
                            // 編集完了後、検索ワードをapplyへ
                            viewModel.apply(inputs: .onCommit(text: text))
                        } else {
                            // 無の検索結果が表示される
                            viewModel.apply(inputs: .onCommit(text: "無"))
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.asciiCapable)
                    .frame(width: UIScreen.main.bounds.width - 40)
                    
                } // ToolBarItem
            } // toolbar
        } // Navi
        
    } // body
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(viewModel: WikiSearchViewModel(wikiSearchCall: WikiSearchCall()))
    }
}
