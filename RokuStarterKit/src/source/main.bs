' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

sub Main()
    showChannelSGScreen()
end sub

sub showChannelSGScreen()
    screen = CreateObject("roSGScreen")

    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("MainScene")

    m.global = screen.getGlobalNode()

    m.global.id = "GlobalNode"
    m.global.addFields({ adID : "" })
    m.global.addFields({ deviceName : "" })
    m.global.addFields({ uid : "" })
    m.global.addFields({ locale : "" })
    m.global.addFields({ networkType : "" })
    m.global.addFields({ memoryLevel : "" })
    m.global.addFields({ deviceID : "" })
    m.global.addFields({ osVersion : "" })
    m.global.addFields({ appVersion : "" })
    m.global.addFields({ buildNo : "" })
    m.global.addFields({ uidValue : "" })
    m.global.addFields({ modelName : "" })
    m.global.addFields({ isPaidUser : false })
    m.global.addField("channelStore", "node", false)
    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub
