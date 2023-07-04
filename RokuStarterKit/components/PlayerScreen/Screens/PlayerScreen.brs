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
sub onScreenDataReceived()
    m.top.getScene().currrentScreenReference = m.top
    if m.top.screenData <> invalid
        if m.top.screenData.streamURL <> invalid and m.top.screenData.streamURL.Len() <> 0
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

    videoContent = CreateObject("roSGNode", "ContentNode")

    if m.top.screenData.licenseURL <> invalid and m.top.screenData.licenseURL.Len() <> 0
        drmParams = {
            keySystem: "widevine"
            licenseServerURL: m.top.screenData.licenseURL
        }
        videoContent.drmParams = drmParams
    end if

    videoContent.AdaptiveMaxStartBitrate = 564000
    videoContent.AdaptiveMinStartBitrate = 16000

    videoContent.url = m.top.screenData.streamURL
    videoContent.streamFormat = getStreamFormat()
    videoContent.title = m.top.screenData.title

    m.videoPlayer.content = videoContent
    m.videoPlayer.visible = true
    m.videoPlayer.control = "play"
    m.videoPlayer.setFocus(true)
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
