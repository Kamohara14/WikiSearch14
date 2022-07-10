//
//  ResultView.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/09.
//

import SwiftUI

struct ResultView: View {
    // MARK: - Inputs
    struct Input {
        // 記事のタイトル
        let title: String
        // 記事の説明文
        let extract: String
    }
    
    // MARK: - View
    
    // 受け取るプロパティ
    let input: Input
    
    var body: some View {
        VStack {
            // 記事のタイトルを表示する
            Text(input.title)
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            // 記事の内容を表示する
            Text(input.extract)
                .padding(3)
            
            Spacer()
        }
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(input: ResultView.Input(title: "タイトル", extract: "説明文"))
    }
}
