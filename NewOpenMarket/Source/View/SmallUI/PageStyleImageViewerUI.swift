//
//  PageStyleImageViewerUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/14.
//

import SwiftUI

struct PageStyleImageViewerUI: View {
    
    let itemImages: [ImageForResponse]?
    
    private static let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        TabView {
            if let itemImages = itemImages {
                ForEach(itemImages) { image in
                    AsyncImage(url: image.url) { eachImage in
                        eachImage.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                }
            } else {
                Color.secondary
                    .overlay {
                        VStack(spacing: 10) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFit()
                            Text("이미지가 없어요 🥺")
                        }
                        .foregroundColor(.black)
                        .font(.title)
                        .padding(.vertical, 40)
                    }
            }
        }
        .frame(width: Self.screenWidth, height: Self.screenWidth)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}