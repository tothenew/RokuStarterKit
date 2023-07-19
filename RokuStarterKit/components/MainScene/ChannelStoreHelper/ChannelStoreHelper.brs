REM: **** This method is the starting point for roku pay flow ****
sub CheckSubscriptionAndStartPlayback()
    REM: *** To handle Roku Pay we need to create channelStore object in the global node ***
    REM: *** add the following to your mainscene ***
    REM: **** MAKE SURE TO INCLUDE THIS FILE IN SCRIPT TAG OF MAINSCENE ****

    ' In Mainscene.xml ->
    ' <script type="text/brightscript" uri="pkg:/components/MainScene/ChannelStoreHelper/ChannelStoreHelper.brs" />

    ' In main.brs ->
    ' m.global.AddField("channelStore", "node", false)

    ' In Mainscene.brs ->
    ' m.global.channelStore = CreateObject("roSGNode", "ChannelStore")

    initiateRFIConsentForUserdata()
end sub

function initiateRFIConsentForUserdata()
    print "Request sign-in RFI"
    if (m.global.channelStore.userData <> invalid)
        RunSubscriptionFlow()
    else
        info = CreateObject("roSGNode", "ContentNode")
        info.addFields({ context : "signin" })
        m.global.channelStore.requestedUserDataInfo = info
        m.global.channelStore.requestedUserData = "email"
        m.global.channelStore.command = "getUserData"
        m.global.channelStore.ObserveField("userData", "onGetUserData")
    end if
end function

function onGetUserData()
    if (m.global.channelStore.userData <> invalid)
        email = m.global.channelStore.userData.email
        ? "email of user is: " email
        RunSubscriptionFlow()
    else
        ? "[user cancelled obtaining email, returning to displaying channel UI]"
        email = ""
    end if
    m.global.channelStore.UnobserveField("userData")
end function

sub RunSubscriptionFlow()
    ' flag needed to show the trial for a new user
    m.isProductWithExpiredTrial = true

    ' show a progressive dialog while retrieving an user's purchases
    dialogCheckSubs = CreateObject("roSGNode", "ProgressDialog")
    dialogCheckSubs.title = "Checking subscriptions..."
    ' to show a dialog set it to the interface field of MainScene
    m.top.dialog = dialogCheckSubs

    ' retrieve purchases by calling channelStore command
    m.global.channelStore.command = "getPurchases"
    ' set an observer to be able to handle actions once loaded
    m.global.channelStore.ObserveField("purchases", "OnGetPurchases")
end sub

sub OnGetPurchases(event as object)
    m.global.channelStore.UnobserveField("purchases")
    purchases = event.GetData() ' extract loaded purchases

    ' check if dialog hasn't been closed before by a user
    if m.top.dialog <> invalid
        m.top.dialog.close = true ' close previous dialog
    else
        return
    end if

    ' purchases are appended as children, so we need to check if there are some
    if purchases.GetChildCount() > 0
        ' there are some subscriptions

        ' check if there are some active subscriptions among the purchases
        allPurchases = purchases.GetChildren(-1, 0)

        ' retrieve current time in seconds
        datetime = CreateObject("roDateTime")
        utimeNow = datetime.AsSeconds()

        ' check expiration date of each purchased subscription
        for each purchase in allPurchases
            ' retrieve expiration time in seconds from the string
            datetime.FromISO8601String(purchase.expirationDate)
            utimeExpire = datetime.AsSeconds()

            ' if user has active subscription then show content
            ' otherwise navigate to purchase option
            if utimeExpire > utimeNow
                REM: **** subscription already active ****
                ''' resume point
                ?"resume point"
                return
            else
                ' if user already has expired trial subscription then we need to
                ' show catalog without trial option
                if purchase.freeTrialQuantity > 0
                    m.isProductWithExpiredTrial = true
                end if
            end if
        end for
    end if

    ''' no subscription at all, thus show catalog to get one
    ' show a progressive dialog while retrieving a catalog
    dialogCheckProducts = CreateObject("roSGNode", "ProgressDialog")
    dialogCheckProducts.title = "Retrieving available products..."
    m.top.dialog = dialogCheckProducts ' set dialog to MainScene

    ' retrieve a catalog by calling channelStore command
    m.global.channelStore.command = "getCatalog"
    ' set an observer to be able to handle actions once loaded
    m.global.channelStore.ObserveField("catalog", "OnGetCatalog")
end sub

sub OnGetCatalog(event as object)
    m.global.channelStore.UnobserveField("catalog")
    catalog = event.GetData() ' extract loaded catalog
    ' check if dialog hasn't been closed before by a user
    if m.top.dialog <> invalid
        m.top.dialog.close = true ' close previous dialog
    else
        return
    end if

    dialog = CreateObject("roSGNode", "Dialog")

    ' catalog items are appended as children, so we need to check if there are some
    if catalog.GetChildCount() > 0
        ' there are some available subscription to get
        dialog.title = "Subscriptions"
        dialog.message = "Please select subscription type:"

        ' create buttons on dialog with products info
        ' to create buttons we need to create an array of strings
        subscriptions = []
        m.activeCatalogItems = []
        for each product in catalog.GetChildren(-1, 0)
            if m.isProductWithExpiredTrial ' if trial has been already used
                ' then show only products without trial
                if product.freeTrialQuantity = 0
                    subscriptions.Push(product.name + " " + product.cost)
                    m.activeCatalogItems.Push({
                        code : product.code,
                        name : product.name
                    })
                end if
            else ' if trial hasn't been already used
                ' then show only products with trial
                if product.freeTrialQuantity > 0
                    subscriptions.Push(product.name + " " + product.cost)
                    m.activeCatalogItems.Push({
                        code : product.code,
                        name : product.name
                    })
                end if
            end if
        end for

        dialog.buttons = subscriptions ' set buttons to dialog field
        ' set an observer to handle actions on button press
        dialog.ObserveField("buttonSelected", "DoSubscriptionOrder")
    else
        ' no available subscription to get some
        dialog.title = "Error"
        dialog.message = "There are not any available subscriptions for now..."
    end if

    m.top.dialog = dialog ' Set dialog to MainScene
end sub

' handle button press on purchase dialog
sub DoSubscriptionOrder(event as object)
    ' extract buttonSelected index from the dialog
    buttonSelectedIndex = m.top.dialog.buttonSelected
    ' extract catalog item as child by index from the channelStore node
    catalogItem = m.activeCatalogItems[buttonSelectedIndex]

    ' to create an order we need to create a ContentNode with children as products to purchase
    order = CreateObject("roSGNode", "ContentNode")
    product = order.CreateChild("ContentNode")
    ' also we need to set required info as code, name and quantity
    product.AddFields({ code : catalogItem.code, name : catalogItem.name, qty : 1 })

    ' do an order by setting order to channelStore field and calling its command
    m.global.channelStore.order = order
    m.global.channelStore.command = "doOrder"
    ' observe orderStatus to be able to handle order response
    m.global.channelStore.ObserveField("orderStatus", "OnOrderStatus")
end sub

sub OnOrderStatus(event as object)
    orderStatus = event.GetData()
    if orderStatus <> invalid and orderStatus.status = 1
        ' if order has been processed successfully
        dialog = CreateObject("roSGNode", "Dialog")
        dialog.title = "Success!"
        dialog.message = "You are now subscribed."
        m.top.dialog = dialog

        REM: **** Purchase via Roku Pay was successful ****
        REM: **** Initiate api call to BE for validate ****
        '''
    else
        ' otherwise show error dialog
        dialog = CreateObject("roSGNode", "Dialog")
        dialog.title = "Error"
        dialog.message = "Failed to process your payment. Please try again."
        m.top.dialog = dialog
        REM: **** Error occurred during purchase ****
        '''
    end if
    m.global.channelStore.UnobserveField("orderStatus")
end sub
