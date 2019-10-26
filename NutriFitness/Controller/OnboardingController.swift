//
//  OnboardingController.swift
//  NutriFitness
//
//  Created by Alan Yan on 2019-10-26.
//  Copyright © 2019 Luke Liu. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

class OnboardingController: UIHostingController<OnboardingView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: OnboardingView());
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
