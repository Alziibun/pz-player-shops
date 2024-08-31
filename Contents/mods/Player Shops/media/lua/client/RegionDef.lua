---@class RegionDef
RegionDef = {}

---@param square IsoGridSquare the square to initiate from
function RegionDef:new(square)
    local region = square:getIsoWorldRegion()
    if not region then return end -- skip if no region is provided
    self.id = region:getID()
end

---@param square IsoGridSquare square to originate from
function RegionDef:initSquares(square)
    local region = square:getIsoWorldRegion()
    local result = {}
    assert(region, "RegionHelper needs a square in a valid region to generate a square list!")
    local queue = {}
    local function removeFromQueue(coroutineInstance)
        for _, v in queue do
            if v == coroutineInstance then
                table.remove(queue, i)
            end
        end
        print("Coroutine queue:", #queue)
    end
    local function bloom(bSquare, coroutineInstance)
        print(coroutineInstance)
        assert(coroutineInstance, "Coroutine instance is somehow nil")
        table.insert(queue, coroutineInstance)
        assert(bSquare, "Bloom square is undefined in", coroutineInstance)
        print(bSquare)
        local x = bSquare:getX()
        local y = bSquare:getY()
        if bSquare:getIsoWorldRegion() == region then
            if not result[x] then
                print("adding", bSquare, "to list")
                -- add square to list since the x already doesn't exist
                result[x] = {}
                result[x][y] = bSquare
            elseif not result[x][y] then
                -- if not already added, add square to list
                print("adding", bSquare, "to list")
                result[x][y] = bSquare
            end
        else -- if bSquare is already in region
            return -- nothing else needs to happen
        end
        local cardinals = {bSquare:getN(), bSquare:getE(), bSquare:getS(), bSquare:getW()}
        for c in cardinals do
            print("Is wall to", c, "?")
            if not bSquare:isWallTo(c) and c ~= nil then
                local co = coroutine.create(bloom)
                table.insert(queue, co)
                coroutine.resume(co, c, co)
            end
        end
        removeFromQueue(coroutineInstance)
    end
    local cor = coroutine.create(bloom)
    print("Starting bloom sequence")
    coroutine.resume(cor, square, cor)
    while (#queue > 0) do
        -- make sure all coroutines are done
        wait()
    end
    return result
end

Events.OnPlayerMove.Add(function(player)
    -- update the current region
end)