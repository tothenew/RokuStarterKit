' ----------------------------------------------------------------
REM : This component contains some configuration & focus handling related code for Player Screen
' ----------------------------------------------------------------

' ----------------------------------------------------------------
REM : All UI components are being intialized here
' ----------------------------------------------------------------
sub init()
    m.top.setFocus(true)
end sub

' ----------------------------------------------------------------
REM : This method validates video url and configures video accordingly
' ----------------------------------------------------------------
sub onVideoScreenDataReceived()
    if m.top.videoScreenData <> invalid
        if m.top.videoScreenData.streamURL <> invalid and m.top.videoScreenData.streamURL.Len() <> 0
            confgureVideo()
        else
            showError("Video Url not found", "This video is not available")
        end if
    end if
end sub

' ----------------------------------------------------------------
REM : Video is configured and streamed in this method
' ----------------------------------------------------------------
sub confgureVideo()
    if m.videoPlayer <> invalid
        if m.videoPlayer.state = "playing" or m.videoPlayer.state = "buffering" or m.videoPlayer.state = "paused"
            m.videoPlayer.control = "stop"
            m.videoPlayer = invalid
        end if
    end if
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")

    videoContentData = getVideoData()
    
    ' compile into a VideoContent node
    content = CreateObject("roSGNode", "VideoContent")
    content.setFields(videoContentData)
    content.ad_url = "" 'Leaving it blank for this app. You should pass your url for live app

    m.videoPlayer.content = content
    m.videoPlayer.visible = false

    m.PlayerTask = CreateObject("roSGNode", "PlayerTask")
    m.PlayerTask.observeField("state", "taskStateChanged")
    m.PlayerTask.video = m.videoPlayer
    m.PlayerTask.control = "RUN"
    'm.videoPlayer.control = "play"
    'm.videoPlayer.setFocus(true)
end sub

' ----------------------------------------------------------------
REM : This method gets called when any remote key is pressed at Player Screen
' ----------------------------------------------------------------
function onKeyEvent(key as String, press as Boolean) as Boolean
    result = true
    if press
        if key = "back"
            goBackToHomeScreen()
        end if
    end if
    return result
end function
