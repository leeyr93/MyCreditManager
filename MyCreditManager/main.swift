//
//  main.swift
//  MyCreditManager
//
//  Created by 이유란 on 2023/04/18.
//

import Foundation

///메뉴 (1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료)
enum MenuType: String {
    case studentAdd = "1"     //학생추가
    case studentDelete = "2"  //학생삭제
    case gradeAdd = "3"       //성적추가(변경)
    case gradeDelete = "4"    //성적삭제
    case averageGrade = "5"   //평점보기
    case exit = "X"           //종료
}

///성적
enum ScoreType: String {
    case aPlus = "A+" //(4.5점)
    case a = "A"  //(4점)
    case bPlus = "B+" //(3.5점)
    case b = "B"  //(3점)
    case cPlus = "C+" //(2.5점)
    case c = "C"  //(2점)
    case dPlus = "D+" //(1.5점)
    case d = "D"  //(1점)
    case f = "F"  //(0점)
}

///동작
enum ActionType: String {
    case add    //추가,변경
    case delete //삭제
}

private var isContinue: Bool = true //메뉴 입력 여부 체크. X입력 전까지는 계속 입력 받음.
private var students: [Student] = [] //학생 데이터

while isContinue {
    print("원하는 기능을 입력해주세요\n1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
    
    let input = readLine()
    if let input = input, let menu = MenuType(rawValue: input) {
        switch menu {
        case .studentAdd:
            setStudent(.add)
        case .studentDelete:
            setStudent(.delete)
        case .gradeAdd:
            setGrade(.add)
        case .gradeDelete:
            setGrade(.delete)
        case .averageGrade:
            break
        case .exit:
            isContinue = false
            print("프로그램을 종료합니다...")
        }
    } else {
        //메뉴의 잘못된 입력 처리
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
}

///학생 관련 action
private func setStudent(_ action: ActionType) {
    switch action {
    case .add:
        print("추가할 학생의 이름을 입력해주세요")
        
        let input = readLine()
        if let name = input, !name.isEmpty {
            let isExist: Bool = students.filter{ $0.name == name }.count > 0 //기존 학생에 존재여부 체크
            
            if isExist { //학생이 존재하는 경우(추가하지 않음)
                print("\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
            } else { //학생이 존재하지 않는 경우(추가함)
                students.append(Student(name: "\(name)", grades: nil))
                print("\(name) 학생을 추가했습니다.")
            }
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    case .delete:
        print("삭제할 학생의 이름을 입력해주세요")
        
        let input = readLine()
        if let name = input, !name.isEmpty {
            for i in 0..<students.count {
                if students[i].name == name { //학생이 존재하는 경우
                    students.remove(at: i)
                    print("\(name) 학생을 삭제했습니다.")
                    return
                }
            }
            
            print("\(name) 학생을 찾지 못했습니다.") //학생이 존재하지 않는 경우.
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    }
}

///성적 관련 action
private func setGrade(_ action: ActionType) {
    switch action {
    case .add:
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift A+\n만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        
        let input = readLine()
        if let gradeStr = input, !gradeStr.isEmpty {
            let gradeArr = gradeStr.components(separatedBy: " ")
            
            if gradeArr.count == 3 {
                let name = gradeArr[0]
                let subject = gradeArr[1]
                let grade = gradeArr[2]
                
                guard let scoreValue = ScoreType(rawValue: grade) else {
                    print("입력이 잘못되었습니다. 다시 확인해주세요.")
                    return
                }
                
                let score = getScore(scoreValue)
                
                for i in 0..<students.count {
                    if students[i].name == name {
                        if var grades = students[i].grades {
                            for j in 0..<grades.count {
                                if subject == grades[j].subject { //해당 학생의 과목 성적이 존재하는 경우
                                    grades[j] = .init(subject: subject, grade: grade, score: score)
                                    students[i].grades = grades
                                    print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
                                    return
                                }
                            }
                            
                            //해당 학생은 존재하지만 과목 성적이 존재하지 않는 경우 - 기존에 과목이 존재하는 경우
                            grades.append(.init(subject: subject, grade: grade, score: score))
                            students[i].grades = grades
                            print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
                        } else {
                            //해당 학생은 존재하지만 과목 성적이 존재하지 않는 경우 - 기존 과목이 존재하지 않는 경우
                            students[i].grades = [.init(subject: subject, grade: grade, score: score)]
                            print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
                        }
                        return
                    }
                }
                
                print("\(name) 학생을 찾지 못했습니다.")
            } else {
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            }
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    case .delete:
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
        
        let input = readLine()
        if let gradeStr = input, !gradeStr.isEmpty {
            let gradeArr = gradeStr.components(separatedBy: " ")
            
            if gradeArr.count == 2 {
                let name = gradeArr[0]
                let subject = gradeArr[1]
                
                for i in 0..<students.count {
                    if students[i].name == name {
                        if let grades = students[i].grades {
                            for j in 0..<grades.count {
                                if subject == grades[j].subject { //해당 학생의 과목 성적이 존재하는 경우ㅇ
                                    students[i].grades?.remove(at: j)
                                    print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
                                    return
                                }
                            }
                        }
                        
                        //해당 학생의 과목이 존재하지 않는 경우
                        print("\(name) 학생의 \(subject) 과목의 성적을 찾지 못했습니다.")
                        return
                    }
                }
                
                print("\(name) 학생을 찾지 못했습니다.")
            } else {
                print("입력이 잘못되었습니다. 다시 확인해주세요.")
            }
        } else {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
        }
    }
}

private func getScore(_ score: ScoreType) -> Double {
    switch score {
    case .aPlus:
        return 4.5
    case .a:
        return 4
    case .bPlus:
        return 3.5
    case .b:
        return 3
    case .cPlus:
        return 2.5
    case .c:
        return 2
    case .dPlus:
        return 1.5
    case .d:
        return 1
    case .f:
        return 0
    }
}

///평점보기
private func getAverageGrade() {
    print("평점을 알고 싶은 학생의 이름을 입력해주세요.")
    
    let input = readLine()
    if let name = input, !name.isEmpty {
        for i in 0..<students.count {
            if students[i].name == name { //학생이 존재하는 경우.
                if let grades = students[i].grades, grades.count > 0 { //과목이 존재하는 경우.
                    var avg: Double = 0
                    
                    for j in 0..<grades.count {
                        avg += grades[j].score
                        print("\(grades[j].subject): \(grades[j].grade)")
                    }
                    
                    avg /= Double(grades.count)
                    print("평점 : \(avg.decimalString(0, 2))")
                } else {
                    print("\(name) 학생의 과목을 찾지 못했습니다.") //과목이 존재하지 않는 경우.
                }
                return
            }
        }
        
        print("\(name) 학생을 찾지 못했습니다.") //학생이 존재하지 않는 경우.
    } else {
        print("입력이 잘못되었습니다. 다시 확인해주세요.")
    }
}

extension Double {
    func decimalString(_ minimumFractionDigitis: Int = 0, _ maximumFractionDigitis: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = minimumFractionDigitis
        numberFormatter.maximumFractionDigits = maximumFractionDigitis
        let result = numberFormatter.string(from: NSNumber(value: self))!
        return result
    }
}
