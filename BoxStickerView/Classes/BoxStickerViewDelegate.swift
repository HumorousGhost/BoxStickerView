//
//  SEBagBoxStickerViewDelegate.swift
//  SynopsisEighth
//
//  Created by Humorous Ghost on 2025/9/22.
//


import Foundation

public protocol BoxStickerViewDelegate: NSObjectProtocol {
    func stickerView(didTapContent stickerView: BoxStickerView)
    func stickerView(didTapDelete stickerView: BoxStickerView)
}
