//
//  PageStyleImageViewer.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/14.
//

import SwiftUI

struct PageStyleImageViewer: View {
    
    let itemImages: [ImageForResponse]?
    
    var body: some View {
        TabView {
            if let itemImages = itemImages {
                ForEach(itemImages) { image in
                    AsyncImage(url: image.url) { eachImage in
                        eachImage
                            .resizable()
                            .scaledToFill() // !!!: 여기에 scaledToFill 걸어주면, height 늘릴 때에도 비율이 유지됨. PageStyle 에서도 문제 없음!
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
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
