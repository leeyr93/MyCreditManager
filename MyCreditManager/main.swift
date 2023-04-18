//
//  main.swift
//  MyCreditManager
//
//  Created by 이유란 on 2023/04/18.
//

import Foundation

///메뉴
enum MenuType: String {
    case studentAdd = "1"    //1:학생추가
    case studentDelete = "2" //2:학생삭제
    case gradeAdd = "3"      //3:성적추가(변경)
    case gradeDelete = "4"   //4:성적삭제
    case averageGrade = "5"  //5:평점보기
    case exit = "X"          //X:종료
}

///성적
enum ScoreType: String {
    case aPlus = "A+" //(4.5점)
    case a = "A"      //(4점)
    case bPlus = "B+" //(3.5점)
    case b = "B"      //(3점)
    case cPlus = "C+" //(2.5점)
    case c = "C"      //(2점)
    case dPlus = "D+" //(1.5점)
    case d = "D"      //(1점)
    case f = "F"      //(0점)
}

///동작
enum ActionType: String {
    case add    //추가,변경
    case delete //삭제
}

///에러 메세지 타입
enum ErrorMessageType: String {
    case inputError = "입력이 잘못되었습니다. 다시 확인해주세요."
}

private var isContinue: Bool = true //메뉴 입력 여부 체크. X입력 전까지는 계속 입력 받음.
private var students: [String: [String: String]] = [:] //학생 데이터 - [이름: [과목이름: 성적]]

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
            getAverageGrade()
        case .exit:
            isContinue = false
            print("프로그램을 종료합니다...")
        }
    } else { //메뉴의 잘못된 입력 처리
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
            if students[name] != nil { //학생이 존재하는 경우 - 추가하지 않음
                print("\(name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
            } else { //학생이 존재하지 않는 경우 - 추가함
                students[name] = [:]
                print("\(name) 학생을 추가했습니다.")
            }
        } else {
            print("\(ErrorMessageType.inputError.rawValue)")
        }
    case .delete:
        print("삭제할 학생의 이름을 입력해주세요")
        
        let input = readLine()
        if let name = input, !name.isEmpty {
            if students[name] != nil { //학생이 존재하는 경우 - 삭제함
                students.removeValue(forKey: name)
                print("\(name) 학생을 삭제했습니다.")
            } else { //학생이 존재하지 않는 경우 - 삭제하지 않음
                print("\(name) 학생을 찾지 못했습니다.")
            }
        } else {
            print("\(ErrorMessageType.inputError.rawValue)")
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
                let name: String = gradeArr[0]
                let subject: String = gradeArr[1]
                let grade: String = gradeArr[2]
                
                if ScoreType(rawValue: grade) != nil {
                    if let grades = students[name] { //학생이 존재하는 경우
                        var updateGrades = grades
                        updateGrades[subject] = grade
                        students[name] = updateGrades
                        print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
                    } else { //학생이 존재하지 않는 경우
                        print("\(name) 학생을 찾지 못했습니다.")
                    }
                    
                    return
                }
            }
        }
        
        print("\(ErrorMessageType.inputError.rawValue)") //input이 올바르지 않은 경우(empty 값, 입력형식에 맞지 않는 값, 올바르지 않은 성적 값)
    case .delete:
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.\n입력예) Mickey Swift")
        
        let input = readLine()
        if let gradeStr = input, !gradeStr.isEmpty {
            let gradeArr = gradeStr.components(separatedBy: " ")
            
            if gradeArr.count == 2 {
                let name = gradeArr[0]
                let subject = gradeArr[1]
                
                if let grades = students[name] { //학생이 존재하는 경우
                    if grades[subject] != nil { //학생의 과목 성적이 존재하는 경우
                        var updateGrades = grades
                        updateGrades.removeValue(forKey: subject)
                        students[name] = updateGrades
                        print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
                    } else { //학생의 과목 성적이 존재하지 않는 경우
                        print("\(name) 학생의 \(subject) 과목의 성적을 찾지 못했습니다.")
                    }
                } else { //학생이 존재하지 않는 경우
                    print("\(name) 학생을 찾지 못했습니다.")
                }
                
                return
            }
        }
        
        print("\(ErrorMessageType.inputError.rawValue)") //input이 올바르지 않은 경우(empty 값, 입력형식에 맞지 않는 값)
    }
}

///String으로 받은 score값 -> Double로 변환하여 반환
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
        if let grades = students[name] { //학생이 존재하는 경우.
            if grades.count > 0 {
                var avg: Double = 0
                
                for grade in grades {
                    let score = getScore(ScoreType(rawValue: grade.value)!)
                    print("\(grade.key): \(grade.value)")
                    avg += score
                }
                
                avg /= Double(grades.count)
                print("평점 : \(avg.decimalString(0, 2))")
            } else { //과목이 존재하지 않는 경우.
                print("\(name) 학생의 과목을 찾지 못했습니다.")
            }
        } else { //학생이 존재하지 않는 경우.
            print("\(name) 학생을 찾지 못했습니다.")
        }
    } else {
        print("\(ErrorMessageType.inputError.rawValue)")
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
