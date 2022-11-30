import UIKit

//перша функія приймає імя строкою і принтить
//“wow, such a short name!” - якшо імя з 2 або 1 букви
//“wow, your name is so long” - якшо імя довше за 10 букв
//“hi Sam” - якшо норм імя (вставляти в прінт імя яке пепредаємо в функцію
//“name with no letters!? no way!” - якшо пупста строка

func nameMarker(_ name: String) {
    switch name.count {
    case 0:
        print("name with no letters!? no way!")
    case 1, 2:
        print("wow, such a short name!")
    case 3...10:
        print("hi \(name)!")
    default:
        print("wow, your name is so long")
    }
}


//друга функція яка приймає зріст людини як інтеджер і повертає строку яка характерезує зріст людини
//“teenager” - 13 to 19
//“adult” - 20 - 60
//“infant” - 0 to 3
//“child” - 5 to 12
//“ooops, looks like you dont exist yet” - minus number
//“old” - 61 and more

func stageByAge(howOldAreYou age: Int) -> String {
    switch age {
    case 13...19:
        return "teenager"
    case 20...60:
        return "adult"
    case 0...3:
        return "infant"
    case 5...12:
        return "child"
    case 61...1000:
        return "old"
    default:
        return "ooops, looks like you dont exist yet"
    }
}




//третя функція яка приймає масив тюплів (в тюплі імя та зріст) і повертає масив описів
//опис буде по типу “Sam is a child because it says Sam is 11 years old”
//можна використовувати другу функцію всережені цієі

func someFunc(_ nameAge: [(String, Int)]) -> [String] {
    var arrStr = [String]()
    for item in nameAge {
        let name = item.0
        let age = item.1
        let stage = stageByAge(howOldAreYou: age)
        arrStr.append("\(name) is a \(stage) because it says \(name) is \(age) years old")
    }
    return arrStr
}

