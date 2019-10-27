//
//  dataInterface.swift
//  NutriFitness
//
//  Created by Luke Liu on 2019-10-27.
//  Copyright © 2019 Luke Liu. All rights reserved.
//
import UIKit

protocol dataInterface {
    func dismissCameraView()
    func passDataBack(data: NSDictionary)
}
