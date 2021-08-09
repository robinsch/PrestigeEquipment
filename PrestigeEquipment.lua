local itemSlotTable = {
    -- Source: http://wowwiki.wikia.com/wiki/ItemEquipLoc
    ["INVTYPE_AMMO"] =           { 0 },
    ["INVTYPE_HEAD"] =           { 1 },
    ["INVTYPE_NECK"] =           { 2 },
    ["INVTYPE_SHOULDER"] =       { 3 },
    ["INVTYPE_BODY"] =           { 4 },
    ["INVTYPE_CHEST"] =          { 5 },
    ["INVTYPE_ROBE"] =           { 5 },
    ["INVTYPE_WAIST"] =          { 6 },
    ["INVTYPE_LEGS"] =           { 7 },
    ["INVTYPE_FEET"] =           { 8 },
    ["INVTYPE_WRIST"] =          { 9 },
    ["INVTYPE_HAND"] =           { 10 },
    ["INVTYPE_FINGER"] =         { 11, 12 },
    ["INVTYPE_TRINKET"] =        { 13, 14 },
    ["INVTYPE_CLOAK"] =          { 15 },
    ["INVTYPE_WEAPON"] =         { 16, 17 },
    ["INVTYPE_SHIELD"] =         { 17 },
    ["INVTYPE_2HWEAPON"] =       { 16 },
    ["INVTYPE_WEAPONMAINHAND"] = { 16 },
    ["INVTYPE_WEAPONOFFHAND"] =  { 17 },
    ["INVTYPE_HOLDABLE"] =       { 17 },
    ["INVTYPE_RANGED"] =         { 18 },
    ["INVTYPE_THROWN"] =         { 18 },
    ["INVTYPE_RANGEDRIGHT"] =    { 18 },
    ["INVTYPE_RELIC"] =          { 18 },
    ["INVTYPE_TABARD"] =         { 19 },
    ["INVTYPE_BAG"] =            { 20, 21, 22, 23 },
    ["INVTYPE_QUIVER"] =         { 20, 21, 22, 23 }
};

local function usableSlotID ( itemEquipLoc )
    return itemSlotTable[itemEquipLoc] or nil
end

local f = CreateFrame("FRAME", "Listener");
f:RegisterEvent("ITEM_LOCKED");
local function eventHandler(self, event, bagOrSlotIndex, slotIndex)
    if bagOrSlotIndex > 4 then return end

    local slotNum = GetContainerNumSlots(bagOrSlotIndex)

    if _G["ContainerFrame"..(bagOrSlotIndex+1).."Item"..(slotNum - slotIndex + 1)..".UpgradeFrame"] ~= nil then
        _G["ContainerFrame"..(bagOrSlotIndex+1).."Item"..(slotNum - slotIndex + 1)..".UpgradeFrame"]:Hide()
    end
end
f:SetScript("OnEvent", eventHandler)

hooksecurefunc("SetItemButtonTextureVertexColor", function (button, _)
    local _, _, _, _, _, _, itemLink = GetContainerItemInfo(button:GetParent():GetID(), button:GetID())
    if itemLink == nil then return end
    local _, _, _, itemLevel, itemMinLevel, itemType, _, itemStackCount, itemEquipLoc = GetItemInfo(itemLink)
    if itemMinLevel  > UnitLevel("player") then
        _G[button:GetName().."IconTexture"]:SetVertexColor(1, 0, 0)
        return
    end

    if (itemType ~= "Armor" and itemType ~= "Weapon") or itemStackCount ~= 1 then return end

    for _, slotId in ipairs(usableSlotID(itemEquipLoc)) do
        local equippedItemLink = GetInventoryItemLink("player", slotId)
        local _, _, _, equippedItemLevel = GetItemInfo(equippedItemLink)
        if equippedItemLevel == nil or equippedItemLevel < itemLevel then
            if button.UpgradeFrame == nil then
                button.UpgradeFrame = CreateFrame("BUTTON", button:GetName()..".UpgradeFrame", button, nil)
                button.UpgradeFrame:SetPoint("BOTTOMRIGHT", 4, 0)
                button.UpgradeFrame:SetSize(20, 20)
                button.UpgradeFrame:EnableMouse(true)
                button.UpgradeFrame:SetNormalTexture("Interface\\AddOns\\AwAddons\\Textures\\CAOverhaul\\RankUp")
                button.UpgradeFrame:SetHighlightTexture("Interface\\AddOns\\AwAddons\\Textures\\CAOverhaul\\RankUp")
                break
            else
                button.UpgradeFrame:Show()
                break
            end
        end
    end
end);
