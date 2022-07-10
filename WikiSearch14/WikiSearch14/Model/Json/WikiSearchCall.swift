//
//  WikiSearchCall.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/08.
//

import Foundation
import Combine

protocol APIServiceType {
    // リクエスト
    func request<Request>(with request: Request)
    // パブリッシャー(Deocdableを返す、エラーはAPIServiceError型)
    -> AnyPublisher<Request.Response, APIServiceError>
    where Request: APIRequestType
}

final class WikiSearchCall: APIServiceType {
    
    // ベースとなるURL
    private let baseURLString: String
    
    // インスタンス生成時にURLをセット
    init(baseURLString: String = "https://ja.wikipedia.org") {
        self.baseURLString = baseURLString
    }
    
    // リクエストの結果を返す
    func request<Request>(with request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request : APIRequestType{
        
        guard let url = URL(string:request.path, relativeTo: URL(string: baseURLString)) else {
            // URLが正しくない
            return Fail(error: APIServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        // guard let でURLが正しいことが証明されているので必ずアクセスできるはず
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        // 取ってきたqueryItemsを代入
        urlComponents.queryItems = request.queryItems
        
        // URL確認
        print("\(urlComponents)")
        
        // パラメータが付いた状態のURLをリクエストとして受け取る
        var request = URLRequest(url: urlComponents.url!)
        
        // Content-Typeをjsonにする(urlでjson指定しているが一応)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // デコーダー
        let decorder = JSONDecoder()
        // JSONのスネークケースをキャメルケースにparse
        decorder.keyDecodingStrategy = .convertFromSnakeCase
        
        // URLSessionのPublisherを実行
        return URLSession.shared.dataTaskPublisher(for: request)
        // mapでレスポンスデータのストリームに変換(レスポンスデータは使わない)
        .map { data, urlResponse in
            return data
        }
        .mapError { _ in
            // APIレスポンスにエラーが発生
            APIServiceError.responseError
        }
        
        // JSONからデータオブジェクトにデコード
        .decode(type: Request.Response.self, decoder: decorder)
        .mapError{ error in
            // JSONのパース時のエラーが発生
            APIServiceError.parseError(error)
        }
        // ストリームをメインスレッドへ
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
