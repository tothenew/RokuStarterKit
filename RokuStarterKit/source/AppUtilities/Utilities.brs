REM : **** This class contains some utilities methods which are to be used throughout the application ****

REM : **** This method validates device's internet status and returns flag accordingly ****
Function checkInternetConection() as Boolean
    isInternetAvailable = false
    
    deviceInfo = CreateObject("roDeviceInfo")
    if(deviceInfo.GetLinkStatus())
            isInternetAvailable = true
    else
            isInternetAvailable = false        
    end if     
        
    return isInternetAvailable     
End Function

REM : **** HMAC SHA1 Encryption ****
Function generateHMAC(sUrlAsMessage as String,secretKey as String) as String
    If sUrlAsMessage=invalid Then
        return "Not A Valid Encryption"
    End IF
    hmac = CreateObject("roHMAC")
    privateKey = CreateObject("roByteArray")
    privateKey.fromAsciiString(secretKey)
    result = hmac.Setup("sha1", privateKey)
    If result = 0 Then
        message = CreateObject("roByteArray")
        message.fromAsciiString(sUrlAsMessage)
        result = hmac.Process(message)
        return result.toBase64String()
    else
        return "Not A Valid Encryption"
    End if
End Function

REM : **** This Method Returns X-ATV-UTKN HEADER for API ****
function getXAtvUTKNValue(signature as String,token as string,uid as String) as String
    token = generateHMAC(signature, token)
    return uid + ":" + token 
end function

REM : **** This Method Returns EpochTimeStamp in String ****
Function getTimeStamp() as String
            dateObj = CreateObject("roDateTime")
            todaysDateEpochTime = dateObj.asSeconds() * 1000
            return todaysDateEpochTime.toStr()
end Function

REM : **** This Method Returns EpochTimeStamp in Integer ****
Function getTimeInMillis() as Integer
            dateObj = CreateObject("roDateTime")
            todaysDateEpochTime = dateObj.asSeconds() * 1000
            return todaysDateEpochTime
end Function

REM : **** This Method converts days into seconds ****
function convertDaysToSeconds(days as Integer)
    return days*24*60*60
end function

REM : **** This Method converts seconds into days ****
function convertSecondsToDays(seconds as Integer) as Integer
    return seconds/(24*60*60)
end function

REM : **** This Method returns Device ID ****
Function getIDValue() as String
            return m.global.deviceID
End Function

REM : **** This Method Returns Build no for API ****s
Function getBnValue() as String
    return m.global.buildNo
end function

REM : **** This Method Returns App Version for API ****
Function getVersionNumber() as String
    return m.global.appVersion
end Function

REM : **** This Method Returns device type ****
Function getDeviceType() as String
    return "ROKU"
End Function

REM : **** This Method Returns Device name ****
Function getDeviceName() as String
    return m.global.deviceName
End Function

REM : **** This Method Returns Device Model Name ****
Function getDeviceModel() as String
    return m.global.modelName
End Function

REM : **** This Method Returns Device ID ****
Function getDeviceId() as String
    return m.global.deviceID
End Function

REM : **** This method returns top parent scene. It can be used for displaying dialogs over the scene etc. **** 
function GetParentScene() as Object
    m.parentScene = m.top.GetParent()
    while m.parentScene <> invalid
        grandParent = m.parentScene.GetParent()
        if grandParent = invalid then
            exit while
        end if
        m.parentScene = grandParent
    end while
    return m.parentScene
end function

REM : **** This Method Returns a Hours/Minutes TimeString from seconds ****
Function GetDurationStringFromSeconds(totalSeconds = 0 As Integer) As String
    remaining = totalSeconds
    hours = Int(remaining / 3600).ToStr()
    remaining = remaining Mod 3600
    minutes = Int(remaining / 60).ToStr()
    remaining = remaining Mod 60
    seconds = remaining.ToStr()

    If hours <> "0" Then
        Return hours + " hr " + minutes + " min"
    Else
        Return minutes + " min"
    End If
End Function

REM : **** This Method Returns a Hours/Minutes/Seconds TimeString from seconds ****
Function GetCompleteDurationStringFromSeconds(totalSeconds = 0 As Integer) As String
    remaining = totalSeconds
    hours = Int(remaining / 3600).ToStr()
    remaining = remaining Mod 3600
    minutes = Int(remaining / 60).ToStr()
    remaining = remaining Mod 60
    seconds = remaining.ToStr()

    If hours <> "0" Then
        Return PadLeft(hours, "0", 2) + ":" + PadLeft(minutes, "0", 2) + ":" + PadLeft(seconds, "0", 2)
    Else
        Return PadLeft(minutes, "0", 2) + ":" + PadLeft(seconds, "0", 2)
    End If
End Function

REM : **** This Method converts seconds into a time string ****
function getMediaTimeFromSeconds(totalSeconds as Integer) as String   
    seconds = totalSeconds MOD 60
    minutes = (totalSeconds \ 60) MOD 60
    hours = totalSeconds \ 3600
    
    hoursStr = hours.toStr()
    if hours > 9
        hoursStr = hoursStr
    else
        hoursStr = "0"+hoursStr
    end if
    
    
    minutesStr = minutes.toStr()
     if minutes > 9
        minutesStr = minutesStr
     else
        minutesStr = "0"+minutesStr
     end if
    
    secondsStr = seconds.toStr()
    if seconds > 9
        secondsStr = secondsStr
    else
        secondsStr = "0"+secondsStr
    end if 

    if hours > 0 
        return  hoursStr + ":" +  minutesStr + ":" + secondsStr
    else if  minutes > 0 
        return minutesStr + ":" + secondsStr
    else  
        return "00:" + secondsStr
    end if
end function

REM : **** This Method returns the current Date & Time ****
function findDateTime()
  date = CreateObject("roDateTime")
  date.ToLocalTime()
  return date.ToISOString()
end function

REM : **** This Method adds border to a given Rectanngle object ****
function addBorderToRectangle(rectangle as object,color as String)
    removeBorderFromRectangle(rectangle)
    m.rectTop=createObject("roSGNode", "Rectangle")
    m.rectTop.id = "border1"
    m.rectTop.width = rectangle.width
    m.rectTop.height = 2
    m.rectTop.color = color
    m.rectTop.translation = [0, 0]
    
    m.rectBottom=createObject("roSGNode", "Rectangle")
    m.rectBottom.id = "border2"
    m.rectBottom.width = rectangle.width
    m.rectBottom.height = 2
    m.rectBottom.color = color
    m.rectBottom.translation = [0, rectangle.height-2]
    
    m.rectLeft=createObject("roSGNode", "Rectangle")
    m.rectLeft.id = "border3"
    m.rectLeft.width = 2
    m.rectLeft.height = rectangle.height
    m.rectLeft.color = color
    m.rectLeft.translation = [0, 0]
    
    m.rectRight=createObject("roSGNode", "Rectangle")
    m.rectRight.id = "border4"
    m.rectRight.width = 2
    m.rectRight.height = rectangle.height
    m.rectRight.color = color
    m.rectRight.translation = [rectangle.width-2,0]


    m.rectMain = createObject("roSGNode", "Rectangle")
    m.rectMain.id = "mainBorder"
    m.rectMain.width = rectangle.width
    m.rectMain.height = rectangle.height
    m.rectMain.color = "#ffffff00"
    m.rectMain.appendChild(m.rectTop)
    m.rectMain.appendChild(m.rectBottom)
    m.rectMain.appendChild(m.rectLeft)
    m.rectMain.appendChild(m.rectRight)

    rectangle.appendChild(m.rectMain)
end function

REM : **** This Method adds border to a given Rectanngle object with given width & color ****
function addBorderToRectangleWithBorderWidth(rectangle as object,borderWidth as Integer,color as String)
    removeBorderFromRectangle(rectangle)
    m.rectTop=createObject("roSGNode", "Rectangle")
    m.rectTop.id = "border1"
    m.rectTop.width = rectangle.width
    m.rectTop.height = borderWidth
    m.rectTop.color = color
    m.rectTop.translation = [0, 0]
    
    m.rectBottom=createObject("roSGNode", "Rectangle")
    m.rectBottom.id = "border2"
    m.rectBottom.width = rectangle.width
    m.rectBottom.height = borderWidth
    m.rectBottom.color = color
    m.rectBottom.translation = [0, rectangle.height-borderWidth]
    
    m.rectLeft=createObject("roSGNode", "Rectangle")
    m.rectLeft.id = "border3"
    m.rectLeft.width = borderWidth
    m.rectLeft.height = rectangle.height
    m.rectLeft.color = color
    m.rectLeft.translation = [0, 0]
    
    m.rectRight=createObject("roSGNode", "Rectangle")
    m.rectRight.id = "border4"
    m.rectRight.width = borderWidth
    m.rectRight.height = rectangle.height
    m.rectRight.color = color
    m.rectRight.translation = [rectangle.width-borderWidth,0]


    m.rectMain = createObject("roSGNode", "Rectangle")
    m.rectMain.id = "mainBorder"
    m.rectMain.width = rectangle.width
    m.rectMain.height = rectangle.height
    m.rectMain.color = "#ffffff00"
    m.rectMain.appendChild(m.rectTop)
    m.rectMain.appendChild(m.rectBottom)
    m.rectMain.appendChild(m.rectLeft)
    m.rectMain.appendChild(m.rectRight)

    rectangle.appendChild(m.rectMain)
end function

REM : **** This Method removes border from a given Rectanngle object ****
function removeBorderFromRectangle(rectangle as object)
    if rectangle <> invalid
        for index = 0 to rectangle.getChildCount() - 1
            rect = rectangle.getChild(index)
            if rect <> invalid and (rect.id = "mainBorder")
                rectangle.removeChild(rect)
            end if
        end for
    end if
end function

REM : **** Set value in RegistryData ****
Function setValue(key as String, value as String)
     registryData = createObject("roSGNode","RegistryHandler")
     registryData.setKeyValue={"key":key,"value":value}
End Function

REM : **** Get value from RegistryData ****
Function getValue(key as String) as String
     registryData = createObject("roSGNode","RegistryHandler")
     registryData.getValueOfKey=key
     return registryData.returnValueOfKey
End Function

REM : **** Deletes a specific key from RegistryData ****
Function deleteThisKey(key as String) as Boolean
     registryData = createObject("roSGNode","RegistryHandler")
     registryData.keyToBeDeleted = key
     return true
End Function

REM : **** Deletes All Data from RegistryData ****
Function deleteAllDataFromRegistry()
     registryData = createObject("roSGNode","RegistryHandler")
     registryData.deleteAllData = true
End Function

REM : **** This method  copies contents from one object to another without keeping referecne ****
function deepCopy(v as object) as object
    v = box(v)
    vType = type(v)
    if vType = "roArray"
        n = CreateObject(vType, v.count(), true)
        for each sv in v
            n.push(deepCopy(sv))
        end for
    else if vType = "roList"
        n = CreateObject(vType)
        for each sv in v
            n.push(deepCopy(sv))
        end for
    else if vType = "roAssociativeArray"
        n = CreateObject(vType)
        for each k in v
            n[k] = deepCopy(v[k])
        end for
    else if vType = "roByteArray"
        n = CreateObject(vType)
        n.fromHexString(v.toHexString())
    else if vType = "roXMLElement"
        n = CreateObject(vType)
        n.parse(v.genXML(true))
        
    else if vType = "roSGNode"
            n = CreateObject("roSGNode", "ContentNode")
            n = v.clone(true)
            
    else if vType = "roInt" or vType = "roFloat" or vType = "roString" or vType = "roBoolean" or vType = "roFunction" or vType = "roInvalid"
        n = v
    else
        print "skipping deep copy of component type " + vType
        n = invalid
        'n = v
    end if
    return n
end function
