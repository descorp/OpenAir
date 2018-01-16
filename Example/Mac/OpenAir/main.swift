//
//  main.swift
//  OpenAir
//
//  Created by Sameh Mabrouk on 26/12/16.
//  Copyright © 2016 Sameh Mabrouk. All rights reserved.
//

import Foundation

let openair = Openair()
if CommandLine.argc < 2 {
    openair.interactiveMode()
}
