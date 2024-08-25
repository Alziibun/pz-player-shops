---@class ShopUI : ISPanel
ShopUI = ISPanel:derive("ShopUI")

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

function ShopUI:initialise()
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
    -- TODO: start writing buttons code
end

function ShopUI:new(x, y, width, height)
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

function ShopUI:prerender()
    -- draw the base components of the GUI like background and names
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

function ShopUI.onGameStart()
    -- develop the GUI after the game starts
    local width, height = 350, 480
    -- center the UI
    local x = getCore():getScreenHeight() / 2 - (height / 2)
    local y = getCore():getScreenWidth() / 2 - (width / 2)
    local s = ShopUI:new(x, y, width, height)
    s:prerender()
    s:initialise()
    s:setEnabled(true)
end

Events.OnGameStart.Add(ShopUI.onGameStart)