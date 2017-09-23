//
//  SwinjectAssembler.swift
//  EcocoinWallet
//
//  Created by Kirill Kirikov on 9/23/17.
//  Copyright © 2017 Seductive-Mobile. All rights reserved.
//

import Foundation
import Swinject
import SwinjectStoryboard

final class SwinjectAssembler {
    fileprivate let assembler: Assembler
    
    init() {
        let container = SwinjectStoryboard.defaultContainer
        let assemblies: [Assembly] = [
            WalletAssembly()            
        ]
        assembler = Assembler(assemblies, container: container)
    }
    
}
