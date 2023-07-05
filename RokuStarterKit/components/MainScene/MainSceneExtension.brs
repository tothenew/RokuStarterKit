REM : **** This file contains all the utility code used in Main Scene class **** 

REM : **** Functions Related to Initialisation of varaibles ****
function initComponents()
       getDeviceInformation()
end function

REM : **** This method gets invoked to retain all deivce & app info ****//
sub getDeviceInformation()
       deviceDetails = CreateObject("roDeviceInfo")
       advId = deviceDetails.GetRIDA()
       m.global.adID = advId

       deviceName = deviceDetails.GetModelDisplayName()
       m.global.deviceName = deviceName

       language = deviceDetails.GetCurrentLocale()
       m.global.locale = language

       networkType = deviceDetails.GetConnectionType()
       m.global.networkType = networkType

       memoryLevel = deviceDetails.GetGeneralMemoryLevel()
       m.global.memoryLevel = memoryLevel
       
       deviceID = deviceDetails.GetChannelClientId()
       m.global.deviceID = deviceID

       osVersion = deviceDetails.GetOSVersion()
       osStr = osVersion.major + "." + osVersion.minor
       m.global.osVersion = osStr
       
       modelName = deviceDetails.GetModel()
       m.global.modelName = modelName
       
       appInfo = CreateObject("roAppInfo")

       appVersion = appInfo.GetVersion()
       m.global.appVersion = appVersion

       buildNo = appInfo.GetValue("build_version")
       m.global.buildNo = buildNo.toStr()
       m.top.setFocus(true)        
end sub

REM : **** This method presents Error Dialog ****
sub onErrorDialogShown()
    if m.rokuAlert = invalid
           m.rokuAlert =  m.top.createChild("DialogUtility")
    end if
    m.rokuAlert.errorTitle = m.top.errorTitle
    m.rokuAlert.errorMessage = m.top.errorMessage
    m.rokuAlert.enableErrorDialog = true
end sub 

REM : **** This method hides Error Dialog ****
sub onErrorDialogHidden()
       if m.top.dialog <> invalid
            m.top.dialog.close = true
       end if
       m.rokuAlert = invalid
       m.CTAButton1.setFocus(true)
end sub

REM : **** This method presents Progress Dialog ****
sub onProgressDialogShown()
       if m.rokuAlert = invalid
           m.rokuAlert =  m.top.createChild("DialogUtility")
       end if
       m.rokuAlert.enableProgressDialog = true
end sub

REM : **** This method hides Progress Dialog ****
sub onProgressDialogHidden()
        m.rokuAlert.disableProgressDialog = true 
        m.rokuAlert = invalid
end sub
