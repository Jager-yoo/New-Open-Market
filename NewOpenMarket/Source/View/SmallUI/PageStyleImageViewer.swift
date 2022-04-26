//
//  PageStyleImageViewer.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/14.
//

import SwiftUI

struct PageStyleImageViewer: View {
    
    let itemImages: [ImageForResponse]?
    let width: CGFloat
    
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
        .frame(width: width, height: width)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}
