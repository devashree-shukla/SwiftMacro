//
//  File.swift
//  
//
//  Created by devashree shukla on 18/12/23.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct AsyncAwaitPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AsyncAwaitMacro.self,
    ]
}
