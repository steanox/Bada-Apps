//
//  ConfettiEmitter.swift
//  Bada-apps
//
//  Created by octavianus on 07/06/18.
//  Copyright © 2018 Bada. All rights reserved.
//

import UIKit
import SceneKit
import Foundation


class ConfettiEmitter{
    public var emitter = CAEmitterLayer()
    
    private let colorSet: [UIColor] = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1),#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
    private let imageSet: [UIImage] = [#imageLiteral(resourceName: "IconArrowUp"),#imageLiteral(resourceName: "Triangle"),#imageLiteral(resourceName: "Circle"),#imageLiteral(resourceName: "Box")]
    var cells: [CAEmitterCell] = []
    
    init(for view: UIView) {
        
        emitter.emitterShape = kCAEmitterLayerLine
        emitter.emitterPosition = CGPoint(x: view.frame.size.width/2, y: -view.frame.size.height/3)
        emitter.emitterSize = CGSize(width: view.frame.size.width, height: 2.0)
        emitter.emitterCells = generateParticle()
        emitter.birthRate = 2
        
        
        
    }
    
    public func startBirthDayConfetti(on view: UIView){
        view.layer.addSublayer(emitter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.emitter.birthRate = 0
        }

    }
    
    
    private func generateParticle()->[CAEmitterCell]{
        
        for index in 0...16{
            let cell = CAEmitterCell()
            cell.birthRate = 4.0
            cell.lifetime = 15.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(arc4random_uniform(UInt32(150)) + 100)
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat(Double.pi)
            cell.emissionRange = 0.5
            cell.spin = 1.5
            cell.spinRange = 0
            cell.color = colorSet[index % 8].cgColor
            cell.contents = imageSet[index % 4].cgImage
            cell.scaleRange = 0.25
            cell.scale = 0.1
            cells.append(cell)
        }
        
        return cells
    
    
    }
}



