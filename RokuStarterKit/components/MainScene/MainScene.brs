' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    initComponents()
End sub

sub goToPlayerScreen()
    movieData = {}
    'http://roku.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/decbe34b64ea4ca281dc09997d0f23fd/aac0cfc54ae74fdfbb3ba9a2ef4c7080/117_segment_2_twitch__nw_060515.mp4
    movieData.AddReplace("streamURL", "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")
    m.playerScreen = m.top.createChild("PlayerScreen")
    m.playerScreen.ObserveField("removePlayerScreen", "onRemovePlayerScreen")
    m.playerScreen.visible = true
    m.playerScreen.setFocus(true)
    m.playerScreen.videoScreenData = movieData
end sub

' ----------------------------------------------------------------
REM : This method gets called when back remote key is pressed at Player Screen
' ----------------------------------------------------------------
sub onRemovePlayerScreen()
    if m.playerScreen <> invalid
        m.top.removeChild(m.playerScreen)
        m.playerScreen = invalid
        m.top.setFocus(true)
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false
    if press
        if key = "OK"
            goToPlayerScreen()
            result = true
        end if
    end if
    return result 
end function
