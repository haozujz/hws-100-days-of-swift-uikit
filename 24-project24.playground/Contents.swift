import UIKit

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

//error
//print(name[3])

let letter = name[name.index(name.startIndex, offsetBy: 3)]

//With this in place, we can now read name[3]. However, it creates the possibility that someone might write code that loops over a string reading individual letters, which they might not realize creates a loop within a loop and has the potential to be slow.
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

//name.count is slow, <Arr>.isEmpty is faster than <Arr>.count==0

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

extension String {
    //remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {return self}
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else {return self}
        return String(self.dropLast(suffix.count))
    }
}

let weather = "it's going to rain"
print(weather.capitalized)

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else {return ""}
        return firstLetter.uppercased() + self.dropFirst()
    }
}

print(weather.capitalizedFirst)


//Individual letters in strings aren’t instances of String, but are instead instances of Character – a dedicated type for holding single-letters of a string.
//uppercased() is actually method on Character rather than String.
//Character.uppercased() actually returns a string, not an uppercased Character.

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

//How can we check whether any string in our array exists in our input string?

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }

        return false
    }
}

input.containsAny(of: languages)

//but it’s not elegant – and Swift has a better solution

//arrays have a second contains() method called contains(where:). This lets us provide a closure that accepts an element from the array as its only parameter and returns true or false depending on whatever condition we decide we want. This closure gets run on all the items in the array until one returns true, at which point it stops.

//When used with an array of strings, the contains(where:) method wants to call a closure that accepts a string and returns true or false.
//The contains() method of String accepts a string as its parameter and returns true or false.
//Swift massively blurs the lines between functions, methods, closures, and more.

languages.contains(where: input.contains)

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let mAttributedString = NSMutableAttributedString(string: string)
mAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
mAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
mAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
mAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
mAttributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


