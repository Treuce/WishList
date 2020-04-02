WishList = WishList or {}
local WL = WishList

------------------------------------------------
--- Addon data
------------------------------------------------
WL.addonVars =  {}
WL.addonVars.addonRealVersion		= 2.92
WL.addonVars.addonSavedVarsVersion	= 2.0 --Changing this will reset the SavedVariables!!!
WL.addonVars.addonName				= "WishList"
WL.addonVars.addonSavedVars			= "WishList_Data"
WL.addonVars.settingsName   		= "WishList"
WL.addonVars.settingsDisplayName   	= WL.addonVars.settingsName
WL.addonVars.addonAuthor			= "Meai & Baertram"
WL.addonVars.addonWebsite			= "http://www.esoui.com/downloads/info1641-WishList.html"
WL.addonVars.addonDonation			= "https://www.esoui.com/portal.php?id=136&a=faq&faqid=131"
WL.addonVars.addonFeedback			= "https://www.esoui.com/downloads/info1641-WishList.html#comments"

--Libraries
WL.addonMenu = LibAddonMenu2
WL.LMM2 = LibMainMenu2
WL.LibSets = LibSets
--[[
--Check if the version is found and >= 0.06
local libSets = WL.LibSets
local libSetsVersionExists = libSets.version ~= nil
local libSetsVersionIsGreaterEqualNeededValue = libSets.version >= 0.06
local libSetsHTTPLinkEsoui = "https://www.esoui.com/downloads/info2241-LibSets.html"
assert(libSetsVersionExists and libSetsVersionIsGreaterEqualNeededValue, "[WishList] ERROR - Needed library \'LibSets\' is not found or not loaded with the needed version 0.06 or higher!\nPlease download the newest version: " .. libSetsHTTPLinkEsoui)
]]

--Constants
WISHLIST_SCENE_NAME = "WishListScene"
--For the ZO_SortList row, the datatpye
WISHLIST_DATA = 1
--The tabs of the scene multitab control
WISHLIST_TAB_SEARCH             = 1
WISHLIST_TAB_WISHLIST           = 2
WISHLIST_TAB_HISTORY            = 3
--The state of the multitab's search tab
WISHLIST_TAB_STATE_NO_SETS      = 1
WISHLIST_TAB_STATE_SETS_LOADING = 2
WISHLIST_TAB_STATE_SETS_LOADED  = 3
--The search types
WISHLIST_SEARCH_TYPE_BY_NAME                = 1
WISHLIST_SEARCH_TYPE_BY_SET_BONUS           = 2
WISHLIST_SEARCH_TYPE_BY_ARMORANDWEAPONTYPE  = 3
WISHLIST_SEARCH_TYPE_BY_SLOT                = 4
WISHLIST_SEARCH_TYPE_BY_TRAIT               = 5
WISHLIST_SEARCH_TYPE_BY_ITEMID              = 6
WISHLIST_SEARCH_TYPE_BY_DATE                = 7
WISHLIST_SEARCH_TYPE_BY_LOCATION            = 8
WISHLIST_SEARCH_TYPE_BY_USERNAME            = 9
WISHLIST_SEARCH_TYPE_BY_LIBSETSSETTYPE      = 10
WISHLIST_SEARCH_TYPE_BY_LIBSETSDLCID        = 11
WISHLIST_SEARCH_TYPE_BY_LIBSETSTRAITSNEEDED = 12
WISHLIST_SEARCH_TYPE_BY_LIBSETSZONEID       = 13
WISHLIST_SEARCH_TYPE_BY_LIBSETSWAYSHRINENODEINDEX = 14
WISHLIST_SEARCH_TYPE_BY_ARMORTYPE           = 15
--WISHLIST_SEARCH_TYPE_BY_TYPE                = 10 -- disabled
--Constants for the number of search dropdown entries at each tab:
WISHLIST_TAB_SEARCH_ENTRY_COUNT     = 15
WISHLIST_TAB_WHISLIST_ENTRY_COUNT   = 15
WISHLIST_TAB_HISTORY_ENTRY_COUNT    = 15
--The add dialog set part types
WISHLIST_ADD_TYPE_WHOLE_SET                             = 1
WISHLIST_ADD_TYPE_BY_ITEMTYPE                           = 2
WISHLIST_ADD_TYPE_BY_ITEMTYPE_AND_ARMOR_WEAPON_TYPE     = 3
WISHLIST_ADD_ONE_HANDED_WEAPONS                         = 4
WISHLIST_ADD_TWO_HANDED_WEAPONS                         = 5
WISHLIST_ADD_BODY_PARTS_ARMOR                           = 6
WISHLIST_ADD_MONSTER_SET_PARTS_ARMOR                    = 7
--The different types for the remove item dialog
WISHLIST_REMOVE_ITEM_TYPE_NORMAL                        = 1
WISHLIST_REMOVE_ITEM_TYPE_DATEANDTIME                   = 2
WISHLIST_REMOVE_ITEM_TYPE                               = 3
WISHLIST_REMOVE_ITEM_TYPE_ARMORANDWEAPONTYPE            = 4
WISHLIST_REMOVE_ITEM_TYPE_SLOT                          = 5
WISHLIST_REMOVE_ITEM_TYPE_TRAIT                         = 6
--The prefix for the character dropdown entries
WISHLIST_SEARCHDROP_PREFIX= "WISHLIST_SEARCHDROP"
WISHLIST_CHARSDROP_PREFIX = "WISHLIST_CHARSDROP"
--Qualities
WL.ESOquality2WLqualityAdd = 2 --Add this number to the ESO quality retuened by GetItemLinkQuality to get the appropriate WishList quality constant
WISHLIST_QUALITY_ALL = 1
WISHLIST_QUALITY_TRASH = 2
WISHLIST_QUALITY_NORMAL = 3
WISHLIST_QUALITY_MAGIC = 4
WISHLIST_QUALITY_ARCANE = 5
WISHLIST_QUALITY_ARTIFACT = 6
WISHLIST_QUALITY_LEGENDARY = 7
WISHLIST_QUALITY_MAGIC_OR_ARCANE = 8
WISHLIST_QUALITY_ARCANE_OR_ARTIFACT = 9
WISHLIST_QUALITY_ARTIFACT_OR_LEGENDARY = 10
WISHLIST_QUALITY_MAGIC_TO_LEGENDARY = 11
WISHLIST_QUALITY_ARCANE_TO_LEGENDARY = 12
--ZoneIds for LibSets data
WISHLIST_ZONEID_BATTLEGROUNDS = 999999
WISHLIST_ZONEID_SPECIAL       = 999998

--Sort header names
local sortTiebrakerChoicesWithSortHeaderKeys = {
    [-1] = "!None",
    [1] = "name",
    [2] = "armorOrWeaponTypeName",
    [3] = "slotName",
    [4] = "traitName",
    [5] = "quality",
    [6] = "username",
    [7] = "locality",
    [8] = "timestamp",
}
WL.sortTiebrakerChoicesWithSortHeaderKeys = sortTiebrakerChoicesWithSortHeaderKeys

--LAM dropdown box entries for the possible tiebraker choices
local sortTiebrakerChoices = {
    [1] = GetString(WISHLIST_LAM_SORT_USE_TIEBRAKER_NONE),
    [2] = GetString(WISHLIST_HEADER_NAME),
    [3] = GetString(WISHLIST_HEADER_TYPE),
    [4] = GetString(WISHLIST_HEADER_SLOT),
    [5] = GetString(WISHLIST_HEADER_TRAIT),
    [6] = GetString(WISHLIST_HEADER_QUALITY),
    [7] = GetString(WISHLIST_HEADER_USERNAME),
    [8] = GetString(WISHLIST_HEADER_LOCALITY),
    [9] = GetString(WISHLIST_HEADER_DATE),
}
WL.sortTiebrakerChoices = sortTiebrakerChoices

--LAM dropdown box entries for the possible tiebraker choices values
local sortTiebrakerChoicesValues = {}
table.insert(sortTiebrakerChoicesValues, -1)
for value=1, #sortTiebrakerChoices-1 do
    table.insert(sortTiebrakerChoicesValues, value)
end
WL.sortTiebrakerChoicesValues = sortTiebrakerChoicesValues
