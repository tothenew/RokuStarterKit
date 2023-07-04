' ----------------------------------------------------------------
REM : All the business logic for Player Screen has been written here
' ----------------------------------------------------------------

' ----------------------------------------------------------------
REM : This method gets called whenever state of video player is changed
' ----------------------------------------------------------------
sub OnVideoPlayerStateChange()
    if m.videoPlayer.state = "error"
        showError("Oops", "There's some technical issue with this video. Please try later")
    else if m.videoPlayer.state = "finished"
        goBackToHomeScreen()
    end if
end sub

' ----------------------------------------------------------------
REM : This method presents error dialog
' ----------------------------------------------------------------
sub showError(errorTitle as String, errorMessage as String)
    m.top.getScene().errorTitle = errorTitle
    m.top.getScene().errorMessage = errorMessage
    m.top.getScene().showErrorDialog = true
end sub

' ----------------------------------------------------------------
REM : This method gets called when OK button is tapped from UI Alert Pop Up at Player Screen
' ----------------------------------------------------------------
sub onAlertOkButtonTapped()
    goBackToHomeScreen()
end sub

' ----------------------------------------------------------------
REM : This method takes useer to Movie Screen
' ----------------------------------------------------------------
sub goBackToHomeScreen()
    if m.videoPlayer <> invalid
        m.videoPlayer.unobserveField("state")
        m.videoPlayer.control = "stop"
        m.videoPlayer = invalid
    end if
    m.top.removePlayerScreen = true
end sub

' ----------------------------------------------------------------
REM : This method identifies the stram format and returns the same
' ----------------------------------------------------------------
function getStreamFormat() as String
    streamFormat = ""
    if m.top.screenData.format <> invalid and m.top.screenData.format.Len() <> 0
        streamFormat = m.top.screenData.format
    else
        if m.top.screenData.streamURL.InStr(".mp4") <> - 1
            if m.top.screenData.streamURL.InStr(".m3u8") <> - 1
                streamFormat = "hls"
            else
                streamFormat = "mp4"
            end if
        else if m.top.screenData.streamURL.InStr("mpd") <> - 1
            streamFormat = "dash"
        end if
    end if
    return streamFormat
end Function