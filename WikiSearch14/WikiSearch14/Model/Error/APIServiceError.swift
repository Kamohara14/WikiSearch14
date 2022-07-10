//
//  APIServiceError.swift
//  WikiSearch14
//
//  Created by cmStudent on 2022/07/08.
//

import Foundation

// エラーに準拠した列挙型
enum APIServiceError: Error {
    // URLが不正である
    case invalidURL
    // APIレスポンスにエラーが発生
    case responseError
    // JSONのパース時にエラーが発生
    case parseError(Error)
}
