REM : **** This class hanldes all Api calls and contains all the Apis related code ****

REM : **** This method returns the timeout duration for any Api call ****
function getPortConnectionTime() as integer
    return 30000 'time in seconds
end function

REM : **** This method initiates api call with GET request ****
function apiCallWithGetRequest(apiUrl as string, headers as object) as object
    return invokeApiCall(apiUrl, "", headers, "")
end function

REM : **** This method initiates api call with POST request ****
function apiCallWithPostRequest(apiUrl as string, params as string, headers as object) as object
    return invokeApiCall(apiUrl, params, headers, "")
end function

REM : **** This method initiates api call with PUT request ****
function apiCallWithPutRequest(apiUrl as string, params as string, headers as object)
            return invokeApiCall(apiUrl, params, headers, "PUT")
End Function

REM : **** This method initiates api call with DELETE request ****
function apiCallWithDeleteRequest(apiUrl as string, params as string, headers as object)
            return invokeApiCall(apiUrl, params, headers, "DELETE")
End Function


REM : **** This method initiates api call ****
function invokeApiCall(apiUrl as string, params as string, headers as object, apiRequestType as String)

    request = getRequest(apiUrl, headers, apiRequestType)
    
    if checkInternetConection()
          if(params <> "" Or apiRequestType = "PUT")
                requestType = request.AsyncPostFromString(params)
          else
                requestType = request.AsyncGetToString()
          end if
          
          timer = createobject("roTimeSpan")
          timer.Mark()
          
          if (requestType)
               while (true)
                     msg = wait(getPortConnectionTime(), m.port)
                     
                     if (type(msg) = "roUrlEvent")
                             code = msg.GetResponseCode()
                             responseString = msg.GetString()
                    
                             if (code = 200)
                                    if responseString <> invalid
                                           json = ParseJSON(responseString)
                                           if json <> invalid
                                                 return json
                                           else
                                                  return { "errMsg": "Error" }
                                           end if
                                    else
                                           return { "errMsg": "Error" }
                                    end if
                             else
                                    if responseString <> invalid
                                           json = ParseJSON(responseString)
                                           if json <> invalid
                                                  return { "errMsg": "Error", "errorDetails": json }
                                           end if
                                    end if
                                    return { "errMsg": "Error" }
                             end if
                      else
                           request.AsyncCancel()
                           return { "errMsg": "Error" }
                      end if
              end while
        end if
    else
        return { "errMsg": "Error" }
    end if
end function

REM : **** This method generates Request for Api call ****
Function getRequest(apiUrl as String, headers as object, requestType as String) as Object
    request = CreateObject("roUrlTransfer")
    m.port = CreateObject("roMessagePort")
    request.SetMessagePort(m.port)
    request.EnableEncodings(true)
    request.SetUrl(apiUrl)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.AddHeader("Content-type", "application/json")
    
    if requestType.len() <> 0
          request.SetRequest(requestType)
    end if
    
    if type(headers) = "roAssociativeArray"
            For Each key in headers
                   request.AddHeader(key, headers[key])
            end for
    end if
    
    request.InitClientCertificates()
    request.RetainBodyOnError(true)
    
    return request
End Function