//
//  PageStyleImageViewerUI.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/14.
//

import SwiftUI

struct PageStyleImageViewerUI: View {
    
    let itemImages: [ImageForResponse]?
    
    var body: some View {
        TabView {
            if let itemImages = itemImages {
                ForEach(itemImages) { image in
                    AsyncImage(url: image.url) { eachImage in
                        eachImage.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .border(.red, width: 3) // TODO: 다음 리팩토링
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
        .scaledToFit()
        .border(.blue, width: 3) // TODO: 다음 리팩토링
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
