extends Node
class_name FamilyRaidShop

const SHOP_ITEMS = {
    "golden_wisp_trail": {"name": "Golden Wisp Trail", "cost": 1, "type": "cosmetic"},
    "rainbow_portal": {"name": "Rainbow Portal Color", "cost": 2, "type": "cosmetic"},
    "ignavarr_hat": {"name": "Ignavarr's Party Hat", "cost": 1, "type": "cosmetic"},
    "sparkle_hud": {"name": "Sparkle HUD Theme", "cost": 3, "type": "cosmetic"}
}

func get_available_items() -> Array:
    return SHOP_ITEMS.keys()

func purchase(item_id: String, profile: PlayerProfile) -> bool:
    if not SHOP_ITEMS.has(item_id): return false
    var cost = SHOP_ITEMS[item_id]["cost"]
    if profile.raid_points < cost: return false
    
    profile.raid_points -= cost
    if not "cosmetics" in profile.quest_completion:
        profile.quest_completion["cosmetics"] = []
    profile.quest_completion["cosmetics"].append(item_id)
    SaveManager.save_current_profile()
    return true
