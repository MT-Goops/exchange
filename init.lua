local modpath = minetest.get_modpath(minetest.get_current_modname())
dofile(modpath.."/glooptest.lua")

local metals = {
  akalin    = "goops_exchange:akalin_ingot",
  alatro    = "goops_exchange:alatro_ingot",
  arol      = "goops_exchange:arol_ingot",
  talinite  = "goops_exchange:talinite_ingot"
}

-- Trade

local banknote = "currency:minegeld_5"

local Formspec = {
  "size[8,7.25]",
  "label[2.5,0.15; _National Central Stock_ ]",
  "label[2.8,0.5; we buy rare metals ]",
  "button_exit[7,1;1,2.5;Quit;Quit]",
  "field[0.25,1;1,2.5;quantity;;1]",
  "item_image[2,1;1,1;".. metals.akalin .."]",
  "item_image[3,1;1,1;".. metals.alatro .."]",
  "item_image[4,1;1,1;".. metals.arol .."]",
  "item_image[5,1;1,1;".. metals.talinite .."]",
  "item_image_button[2,2;1,1;".. banknote ..";o1;]",
  "item_image_button[3,2;1,1;".. banknote ..";o2;]",
  "item_image_button[4,2;1,1;".. banknote ..";o3;]",
  "item_image_button[5,2;1,1;".. banknote ..";o4;]",
  "list[current_player;main;0,3;8,1;]",
  "list[current_player;main;0,4.25;8,3;8]",
  "listring[]"
}

local function trade(player, stackin, stackout)
  local playername = player:get_player_name()
  local inv=player:get_inventory()
  if inv:contains_item("main", stackin) then
    inv:remove_item("main", stackin)
    if inv:room_for_item("main", stackout) then
      inv:add_item("main", stackout)
    else
      inv:add_item("main", stackin)
      minetest.chat_send_player(playername, "Not enough room in your inventory")
    end
  else
    minetest.chat_send_player(playername, "Not enough metal in your inventory")
  end
end


-- Counter


minetest.register_node("goops_exchange:counter", {
  description = "Trade counter",
  tiles = {
    "goops_exchange_side.png",
    "goops_exchange_side.png",
    "goops_exchange_side.png",
    "goops_exchange_side.png",
    "goops_exchange_side.png",
    "goops_exchange_front.png"
  },
  paramtype2 = "facedir",
  groups = {cracky=2},
  after_place_node = function(pos, placer)
    minetest.get_meta(pos):set_string("formspec", table.concat(Formspec, ""))
  end,
  on_receive_fields = function(pos, formname, fields, player)
    local playername = player:get_player_name()
    if fields.o1 then
      local stackin = metals.akalin.." "..fields.quantity
      local stackout = banknote.." "..fields.quantity
      trade(player,stackin,stackout)
    elseif fields.o2 then
      local stackin = metals.alatro.." "..fields.quantity
      local stackout = banknote.." "..fields.quantity
      trade(player,stackin,stackout)
    elseif fields.o3 then
      local stackin = metals.arol.." "..fields.quantity
      local stackout = banknote.." "..fields.quantity
      trade(player,stackin,stackout)
    elseif fields.o4 then
      local stackin = metals.talinite.." "..fields.quantity
      local stackout = banknote.." "..fields.quantity
      trade(player,stackin,stackout)
    end
    if fields.quit then
      minetest.chat_send_player(playername, "Thanks for trading with the National Central Stock")
      minetest.chat_send_player(playername, "See you soon !")
      return
    end
  end
})

minetest.register_craft({
  output = "goops_exchange:counter",
  recipe = {
    {"default:gold_ingot", "default:mese_crystal", "default:gold_ingot"},
    {"default:gold_ingot", "group:glooptest_ingot", "default:gold_ingot"},
    {"default:gold_ingot", "default:mese_crystal", "default:gold_ingot"}
  }
})
