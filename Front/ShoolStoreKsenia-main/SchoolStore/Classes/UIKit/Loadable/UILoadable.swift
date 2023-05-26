//
//  UILoadable.swift
//
//  Created by Ксения Дураева
//

import Foundation

protocol UILoadable: AnyObject {
    func startLoading(with parameters: LoaderParameters)
    func stopLoadingProgress()
}
