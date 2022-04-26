//
//  SwipeBackGesture.swift
//  NewOpenMarket
//
//  Created by 유재호 on 2022/04/27.
//

import UIKit

// NavigationLink 를 타고 들어간 ItemDetailView 에서, navigationBarBackButtonHidden(true) 적용하면
// 멀쩡하게 잘 되던 Swipe-Back-Gesture 가 비활성화 되는 이슈가 있음
// 아래 코드를 만들어주면, 다시 제스처가 작동하게 만들 수 있음
extension UINavigationController: UIGestureRecognizerDelegate {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}
