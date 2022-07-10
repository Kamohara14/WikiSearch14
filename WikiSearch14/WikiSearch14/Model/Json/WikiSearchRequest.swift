//
//  WikiSearchRequest.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/08.
//

import Foundation

protocol APIRequestType {
    associatedtype Response: Decodable
    
    // プロパティ(getのみ)
    var path: String { get } // 計算型プロパティではない
    
    // URL組み立て用
    var queryItems: [URLQueryItem]? { get }
}

struct WikiSearchRequest: APIRequestType {
    typealias Response = WikiSearchResponse
    
    private let query: String
    
    // プロパティ(URLの基本部分)
    var path = "/w/api.php"
    
    var queryItems: [URLQueryItem]?
    
    // URL組み立て
    init(query: String) {
        self.query = query
        self.queryItems = [
            // JSON形式で受け取る
            .init(name: "format", value: "json"),
            // APIは閲覧に使用する
            .init(name: "action", value: "query"),
            // オプション
            .init(name: "prop", value: "extracts"),
            .init(name: "exintro", value: nil),
            .init(name: "explaintext", value: nil),
            .init(name: "redirects", value: "1"),
            // 検索ワード指定
            .init(name: "titles", value: query)
        ]
    }
}
