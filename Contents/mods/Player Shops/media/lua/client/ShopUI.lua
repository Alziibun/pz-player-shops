---@class ShopUI : ISPanel
ShopMenu = ISPanel:derive("ShopUI")
ShopMenu

local good = {
    r = getCore():getGoodHighlitedColor():getR(),
    g = getCore():getGoodHighlitedColor():getG(),
    b = getCore():getGoodHighlitedColor():getB(),
}

local bad = {
    r = getCore():getBadHighlitedColor():getR(),
    g = getCore():getBadHighlitedColor():getG(),
    b = getCore():getBadHighlitedColor():getB()
}

function ShopMenu:initialise()
    ISPanel.initialise(self)

    -- style
    -- syntax borrowed from various IS (Indie Stone) scripts
    local buttonWidth = 100
    local buttonHeight = 25
    local padding = {
        top = 10,
        bottom = 10,
        left = 10,
        right = 10
    }
    local listWidth = (self.width / 2) - 15
    local listHeight = 250
    local tabWidth = 40
    local tabHeight = 18
    local defaultZomboidBorder = {r=1, g=1, b=1, a=0.4} -- the familiar off-white border Zomboid uses

    -- cancel menu button
    self.no = ISButton:new(10, self:getHeight() - padding.bottom - buttonHeight, buttonWidth, buttonHeight,"Cancel", self, ShopMenu.onClick)
    self.no.internal = "CANCEL"
    self.no:initialise()
    self.no:instantiate()
    self.no.borderColor = defaultZomboidBorder
    self:addChild(self.no)

    -- the confirm button buy/sell
    self.yes = ISButton:new(120, self:getHeight() - padding.bottom - buttonHeight, buttonWidth, buttonHeight, "Checkout", self, ShopMenu.onClick)
    self.yes.internal = "CONFIRM"
    self.yes:initialise()
    self.yes:instantiate()
    self.yes.borderColor = defaultZomboidBorder
    self:addChild(self.yes)

    -- the item listing
    self.offers = ISScrollingListBox:new(10, 70, listWidth, listHeight)
    self.offers:initialise()
    self.offers:instantiate()
    self.offers.itemheight = 25
    self.offers.selected = 0
    self.offers.joypadParent = self
    self.offers.font = UIFont.NewSmall
    self.offers.drawBorder = true
    self:addChild(self.offers)

    -- the cart
    self.cart = ISScrollingListBox:new(self.offers.x + self.offers.width + 10, self.offers.y, listWidth, listHeight)
    self.cart:initialise()
    self.cart:instantiate()
    self.cart.itemheight = 25
    self.cart.selected = 0
    self.cart.joypadParent = self
    self.cart.font = UIFont.NewSmall
    self:addChild(self.cart)

    -- edit listing tab
    self.edititems = ISButton:new(
            self.offers.x,
            self.offers.y + self.offers:getHeight() + tabHeight + padding.top,
            tabWidth,
            tabHeight,
            "Edit",
            self, ShopMenu.onClick)
    self.edititems:initialise()
    self.edititems:instantiate()
    self.edititems.borderColor = defaultZomboidBorder

    self:addChild(self.edititems)

    -- shows how much money the player has total
    local mon = Economy.getWorth(self.player)
    print(mon)
    self.myCash = ISLabel:new(
            self.cart.x + self.cart:getWidth() - padding.right - getTextManager():MeasureStringX(UIFont.Medium, "$" .. mon),
            self.cart.y + self.cart:getHeight(),
            tabHeight,
            "$" .. mon,
            good.r, good.g, good.b, 1,
            UIFont.Medium)
    self.myCash:initialise()
    self.myCash:instantiate()
    self:addChild(self.myCash)

    self.cost = nil -- how much the cart costs total
end

function ShopMenu:new(x, y, width, height)
    local o = {}
    -- center UI
    o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self
    -- use vanilla zomboid parameters
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.listHeaderColor = {r=0.4, g=0.4, b=0.4, a=0.3};
    o.width = 350
    o.height = 450
    o.moveWithMouse = true
    return o
end

function ShopMenu:prerender()
    -- draw shop border
    self:drawRect(self.x, self.y, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    -- draw the shop name
    self:drawText(
            "Shop",
            self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, "Shop") / 2),
            z, 1, 1,1, 1, UIFont.Medium)
    -- TODO: register icon space
    -- TODO: line break under title
    -- TODO: slogan space (paragraph area)
    -- TODO: listing section (to be decided)
end