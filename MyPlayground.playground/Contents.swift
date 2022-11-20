import UIKit

func makeItCool(_ string: String) -> String {
    var coolString = ""
    for char in string {
        switch char {
        case "A","a":
            coolString += "@"
        case "I","i":
            coolString += "1"
        case "S","s":
            coolString += "$"
        case "O","o":
            coolString += "0"
        case "T","t":
            coolString += "+"
        default:
            coolString += String(char)
        }
    }
    return coolString
}

makeItCool("today")
//a - @; i - 1; s - $; o - 0; t - +
