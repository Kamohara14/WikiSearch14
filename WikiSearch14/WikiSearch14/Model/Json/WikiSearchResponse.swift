//
//  WikiSearchResponse.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/08.
//

import Foundation

// 使用するURL
// https://ja.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=(検索ワード)

// MARK: - WikiSearchResponse
struct WikiSearchResponse: Codable {
    let batchcomplete: String
    let query: Query
}

// MARK: - Query
struct Query: Codable {
    // 記事によって存在したりしなかったりする
    let redirects: [Redirect]?
    let normalized: [Normalized]?
    
    // 記事が見つからない場合は存在しない可能性がある
    let pages: [String:Pages]?
}

// MARK: - Pages
struct Pages: Codable {
    let pageid: Int?
    let ns: Int
    // 記事のタイトル
    let title: String
    // 記事の内容
    let extract: String?
}

// MARK: - Redirect
struct Redirect: Codable {
    let from, to: String
}

// MARK: - Normalized
struct Normalized: Codable {
    let from, to: String
}
