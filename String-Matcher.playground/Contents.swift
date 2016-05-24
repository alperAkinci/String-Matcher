

// STRING MATCHER

//This project is about the string matching problem. String matching is the problem of finding the number of occurrences of a pattern in a given text.


import UIKit
import QuartzCore

let pattern : String = "automata"

let alphabet = Array("abcdefghijklmnopqrstuvwxyz0123456789 .,?!-+'\"".characters)
var text : String?
var states : [Int:Character] = [:]


//Reading Text File
let bundle = NSBundle.mainBundle()
let myFilePath = bundle.pathForResource("textFile", ofType: "txt")

do{
 text = try String(contentsOfFile:myFilePath!, encoding:NSUTF8StringEncoding)
} catch {
    print ("Couldnt find content : \(text)")
}
print("\(text!)\n")


// Seperating text to line by line strings
var textLinesArray = text!.componentsSeparatedByString("\n")


/***************************************************************/

// Naive String Matcher

func callNaiveMethod(arrayList :[String] , pattern : String ) {
    
    // get each line as a string
    for line in arrayList {
       let lineCharArray = Array(line.lowercaseString.characters)
       let patternCharArray = Array(pattern.lowercaseString.characters)
        
       let lineNumber = arrayList.indexOf(line)! + 1
       // lineCharArray has all the characters in x line
       let countOfFounded = NaiveMatcher(lineCharArray,pattern: patternCharArray)
        
       let resultText = "Line \(lineNumber): \(countOfFounded) occurence"
        if (countOfFounded > 1){
           print (resultText + "s")
        
        }else if (countOfFounded > 0) {
            print(resultText)
            }
        }
}




func NaiveMatcher(line : Array<Character> , pattern : Array<Character>) -> Int {
    let n = line.count
    let m = pattern.count
    var countOfFounded = 0
    var matched : Bool = false
    
    //starting from first character of line then switch the next character
    for index in 0...(n - m){
        var stringIndex = index
        matched = true
        for patternIndex in 0..<m {
            
            if(line[stringIndex] != pattern[patternIndex]){  // if characters is not matched, boolean matched will set false
                matched = false;
            }
            
            if (matched && patternIndex == (m - 1)){ // if boolean matched is true at the last character of reading pattern
                countOfFounded += 1	// integer countOfFounded will increase
            }
            stringIndex += 1;
        }
    }
    return countOfFounded
}

/***************************************************************/

// Finite Automata Matcher


// read character by character from pattern char array
// while comparing character of the pattern with character of the alphabet
// find a compatible character, call findState fuction with parameters
func computeTransitionFunction(pattern : Array<Character>)
{
    // read character by character from pattern char array
    for state in 0..<pattern.count {
        // read character by character from alphabet char array
        for i in 0..<alphabet.count{
            // if current pattern character is equal to current alphabet character
            // send to function pattern & current pattern character & current state to generate & current alphabet character
            if( pattern[state] == alphabet[i] ){
                findState(pattern, patternCharacter: pattern[state], currentState: state, alphabetCharacter: alphabet[i])
            }
        }
    }
}

// find next state related to current state & pattern character
// set next state to Dictionary<Int, Character>
func findState(pattern : Array<Character>,patternCharacter : Character, currentState : Int, alphabetCharacter : Character){
    var tempState = 0
    if (currentState < pattern.count)// control statement for current state & pattern.length
    {
        if(alphabetCharacter == patternCharacter){	// control statement for alphabetCharacter & patternCharacter
            tempState = currentState + 1;
            
        }
    }
    // This is what reaaly findState method does!!!!!!!
    states[tempState - 1] = patternCharacter	//
    //[0: "a", 1: "u", 2: "t", 3: "o", 4: "m", 5: "a", 6: "t", 7: "a"]
}



func callFiniteAutomataMethod(arrayList :[String] , pattern : String ) {
    let patternCharArray = Array(pattern.lowercaseString.characters)
    
    computeTransitionFunction(patternCharArray)
    
    // line  = each line as a string
    for line in arrayList {
        let lineCharArray = Array(line.lowercaseString.characters)
        
        
        let lineNumber = arrayList.indexOf(line)! + 1
        
        let countOfFounded = FiniteAutomataMatcher(lineCharArray,pattern: patternCharArray)
        
   /* below code commented out cause naive method is already printing the same */

//        let resultText = "Line \(lineNumber): \(countOfFounded) occurence"
//        if (countOfFounded > 1){
//            print (resultText + "s")
//            
//        }else if (countOfFounded > 0) {
//            print(resultText)
//        }
    
    
    }
    
}


// read character by character from char array
// if currentState == pattern.lenght,
// integer founded will increase by 1
// currentState will set 0
// if current character of the line equals to
// value of the dictionary which is paired with integer currentState
// integer currentState will increase by 1
// else integer currentState will set 0
func FiniteAutomataMatcher(line : Array<Character>, pattern : Array<Character>)->Int{
    
    var founded = 0;
    let M = pattern.count;
    let N = line.count;
    var currentState = 0;// there is totally 8 states for "automata" world so max is 7
    for i in  0..<N {
        
        // this is the condition when the world is found and reached the last last char of world so
        if (currentState == M){ // if currentState == pattern.lenght, founded will increase by 1
            founded += 1			// if pattern is founded in the line, integer founded will increase
            currentState = 0;	// current state will be 0 because of the search pattern again in the line
        }
        
        if ( states[currentState] == line[i] ){ // control statement for character of line & current states of value in dictionary
            currentState = currentState + 1;	// if current states of value in dictionary equals value of character, current state will increase
        }else{
            currentState = 0;		// if current states of value in dictionary does not equal value of character, current state will set 0
        }
    }
    return founded;
}

/***************************************************************/

func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
    let start = CACurrentMediaTime()
    block();
    let end = CACurrentMediaTime()
    return end - start
}

var naiveTime = executionTimeInterval {
    callNaiveMethod(textLinesArray, pattern: pattern)
}

var finiteAutomataTime = executionTimeInterval {
    callFiniteAutomataMethod(textLinesArray, pattern: pattern)
}

print("\nTime for Naive-String-Matching: \(naiveTime) s.")
print("Time for Finite-Automata-Matching: \(finiteAutomataTime) s.")


