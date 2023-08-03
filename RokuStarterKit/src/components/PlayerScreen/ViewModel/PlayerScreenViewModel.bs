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
    m.PlayerTask = invalid
    m.top.removePlayerScreen = true
end sub

' ----------------------------------------------------------------
REM : This method identifies the stram format and returns the same
' ----------------------------------------------------------------
function getStreamFormat() as String
    streamFormat = ""
    if m.top.videoScreenData.format <> invalid and m.top.videoScreenData.format.Len() <> 0
        streamFormat = m.top.videoScreenData.format
    else
        if m.top.videoScreenData.streamURL.InStr(".mp4") <> - 1
            if m.top.videoScreenData.streamURL.InStr(".m3u8") <> - 1
                streamFormat = "hls"
            else
                streamFormat = "mp4"
            end if
        else if m.top.videoScreenData.streamURL.InStr("mpd") <> - 1
            streamFormat = "dash"
        end if
    end if
    return streamFormat
end Function

' ----------------------------------------------------------------
REM : This method creates data for video 
' ----------------------------------------------------------------
function getVideoData() as object
    videoUrl = m.top.videoScreenData.streamURL
    videoStreamFormat = getStreamFormat()

    drmParams = {}
    if m.top.videoScreenData.licenseURL <> invalid and m.top.videoScreenData.licenseURL.Len() <> 0
        drmParams = {
            keySystem: "widevine"
            licenseServerURL: m.top.videoScreenData.licenseURL
        }
    end if

    videoContentData = {
        streamFormat: videoStreamFormat,
        titleSeason: "Art21 Season 3",
        title: "Place",
        url: videoUrl,

        'used for raf.setContentGenre(). For ads provided by the Roku ad service, see docs on 'Roku Genre Tags'
        categories: ["Documentary"]

        'Roku mandates that all channels enable Nielsen DAR
        nielsen_app_id: "P2871BBFF-1A28-44AA-AF68-C7DE4B148C32" 'required, put "P2871BBFF-1A28-44AA-AF68-C7DE4B148C32", Roku's default appId if not having ID from Nielsen
        nielsen_genre: "DO" 'required, put "GV" if dynamic genre or special circumstances (e.g. games)
        nielsen_program_id: "Art21" 'movie title or series name
        length: 3220 'in seconds;
        AdaptiveMaxStartBitrate: 564000
        AdaptiveMinStartBitrate: 16000
        drmParams: drmParams
    }
    return videoContentData
end function

' ----------------------------------------------------------------
REM : This method gets called whenever state of video player is changed
' ----------------------------------------------------------------
sub taskStateChanged(event as Object)
    print "Player: taskStateChanged(), id = "; event.getNode(); ", "; event.getField(); " = "; event.getData()
    state = event.GetData()
    if state = "done" or state = "stop"
        goBackToHomeScreen()
    end if
end sub