//
//  WikiSearchViewModel.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/08.
//

import SwiftUI
import Combine

class WikiSearchViewModel: ObservableObject {
    // MARK: - Inputs
    enum Inputs {
        // ユーザの入力操作が終了した場合
        case onCommit(text: String)
    }
    
    // MARK: - Outputs
    // 表示するデータ
    @Published private(set) var resultViewInoput = ResultView.Input(title: "", extract: "")
    // ローディング
    @Published var isLoading = false
    // 記事のタイトル
    @Published var title: String = ""
    // 記事の内容
    @Published var extract: String = ""
    
    // MARK: - Private
    // API呼び出し
    private let wikiSearchCall: WikiSearchCall
    // Publisherを動かす
    // ユーザーの入力操作終了時に発行するSubject
    private let onCommitSubject = PassthroughSubject<String, Never>()
    // APIリクエストが完了時に発行するSubject(JSONを分解したものを受け取って処理をする)
    private let responseSubject = PassthroughSubject<WikiSearchRequest, Never>()
    // エラー時に発行するSubject
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    // Cancellable
    private var cancellable = Set<AnyCancellable>()
    
    
    init(wikiSearchCall: WikiSearchCall) {
        self.wikiSearchCall = wikiSearchCall
        bind()
    }
    
    func bind(){
        onCommitSubject
        // 検索文字を受け取る
            .flatMap { query in
                self.wikiSearchCall.request(with: WikiSearchRequest(query: query))
            }
        // 空のPublisherを返す
            .catch { error -> Empty<WikiSearchResponse, Never> in
                // エラーSubject
                print("")
                print(error)
                
                // ロード初期化
                self.isLoading = false
                
                self.errorSubject.send(error)
                return Empty()
            }
            .map { $0.query }
        // Subscriber
            .sink { response in
                // 結果画面を取得する
                self.resultViewInoput = self.convertInput(response: response)
                // ロード完了
                self.isLoading = false
            }
            .store(in: &cancellable)
        
        // 読み込み処理
        onCommitSubject
            .map { _ in true }
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellable)
    }
    
    func convertInput(response: Query) -> ResultView.Input {
        // 取ってきたデータ(基本1件しか戻らない)
        guard let titleResult = response.pages?.compactMap({ $0.value.title })[safe: 0],
              let extractResult = response.pages?.compactMap({ $0.value.extract })[safe: 0] else {
            // 記事が存在しない
            return ResultView.Input(title: "記事が存在しません", extract: "検索のヒント\nひらがなをカタカナに変更したり、日本語を英語を変更して検索してみて下さい。")
        }
        
        // データを代入
        let inputs = ResultView.Input(title: titleResult, extract: extractResult)
        
        return inputs
    }
    
    func apply(inputs: Inputs) {
        switch inputs {
        case .onCommit(text: let text):
            // 検索をする
            onCommitSubject.send(text)
        }
    }
}

// 配列から安全に取り出すためのextension
extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
