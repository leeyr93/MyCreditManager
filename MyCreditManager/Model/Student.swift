//
//  Student.swift
//  MyCreditManager
//
//  Created by 이유란 on 2023/04/18.
//

struct Student {
    let name: String
    var grades: [Grade]?
    
    struct Grade {
        let subject: String
        let grade: String
        let score: Double
    }
}
