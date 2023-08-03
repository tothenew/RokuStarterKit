REM : **** This class contains some utilities methods which are to be used throughout the application for savinng & fetching data into/from Device Registry ****

REM : **** This method initializes the Registry class object ****
sub init()
    m.registryObject = CreateObject("roRegistrySection","CommonReg")
end sub

REM : **** This method saves data in Registry ****
Sub saveDataInRegistry()
    keyValue = m.top.setKeyValue
    key = keyValue.key
    value = keyValue.value
    
    '    Going to save the data into registry
    m.registryObject.Write(key,value)
    m.registryObject.Flush() 'commit it      
End Sub

REM : **** This method fetches data from Registry ****
Sub getDataFromRegistry()
    key = m.top.getValueOfKey
    value=""
    
    If m.registryObject.Exists(key) Then
          value = m.registryObject.read(key)
    End IF 
    m.top.returnValueOfKey=value
End Sub

REM : **** This method removes all saved data from Registry ****
sub onDeleteAllData()
        registry = CreateObject("roRegistry")
        sectionsList = registry.GetSectionList()
        for each section in sectionsList
                deleted =  registry.Delete(section)
        end for
end sub

REM : **** This method removes a specific key from Registry ****
Function deleteKeyFromRegistry()
    m.registryObject.delete(m.top.keyToBeDeleted)    
End Function