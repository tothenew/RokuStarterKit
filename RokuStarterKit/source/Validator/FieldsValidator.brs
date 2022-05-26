REM : **** This file contains all the validation code **** 

REM : **** This method validates Email field **** 
Function emailValidation(textToDisplay as String)
     checkRegex = CreateObject("roRegex", "[_A-Za-z0-9-\\+]+(.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(.[A-Za-z0-9]+)*(.[A-Za-z]{2,})","i")
     arrayForValidation =[]
     arrayForValidation = checkRegex.Match(textToDisplay)
     return arrayForValidation
End Function

REM : **** This method validates spacial characters in a string **** 
Function specialCharValidation(textToDisplay as String)
     checkRegex = CreateObject("roRegex", "^[A-Za-z ]+$", "i")
     arrayForValidation =[]
     arrayForValidation = checkRegex.Match(textToDisplay)
     return arrayForValidation
End Function

REM : **** This method validates Phone Number **** 
Function phoneValidation(textToDisplay as String)
    checkRegex = CreateObject("roRegex", "[0-9]+", "i")
    arrayForValidation =[]
    arrayForValidation = checkRegex.Match(textToDisplay)
    return arrayForValidation
End Function

REM : **** This method validates Pin **** 
Function pinValidation(textToDisplay as String)
    checkRegex = CreateObject("roRegex", "[0-9]+", "i")
    arrayForValidation =[]
    arrayForValidation = checkRegex.Match(textToDisplay)
    return arrayForValidation
End Function

REM : **** This method validates a string for numeric values **** 
Function validateNumericText(textToDisplay as String) as Boolean
    otherCharFound = false
    componentsArray =  textToDisplay.Split("")
    for index = 0 to componentsArray.Count()-1
            inputIntValue = componentsArray[index].toInt()
            if inputIntValue = 0
                   if componentsArray[index] = "0"
                   else
                         otherCharFound = true
                         exit for
                   end if
            end if
    end for
    return otherCharFound
End Function