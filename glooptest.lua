if minetest.get_modpath("glooptest") then
  local metals = {
    akalin    = "glooptest:akalin_ingot",
    alatro    = "glooptest:alatro_ingot",
    arol      = "glooptest:arol_ingot",
    talinite  = "glooptest:talinite_ingot"
  }
  for n,m in pairs(metals) do
    -- compatibility with backup items
    minetest.register_alias_force("goops_exchange:mineral_"..n, "glooptest:mineral_"..n)
    minetest.register_alias_force("goops_exchange:"..n.."_lump", "glooptest:"..n.."_lump")
    minetest.register_alias_force("goops_exchange:"..n.."_ingot", "glooptest:"..n.."_ingot")
    -- add the glooptest_ingot group
    local groups = table.copy(minetest.registered_craftitems[m].groups)
    groups.glooptest_ingot = 1
    minetest.override_item(m, { groups=groups })
  end

else 
  -- Backup items : copied from glooptest mod

  local function register_ore(name, uses)
    -- ore
    minetest.register_node("goops_exchange:mineral_"..name, {
      description = name:gsub("^%l",string.upper).." Ore",
      tiles = {uses.base_texture.."^gloopores_mineral_"..name..".png"},
      is_ground_content = true,
      drop = "goops_exchange:"..name.."_lump",
      light_source = uses.light or 0,
      groups = uses.groups,
      sounds = default.node_sound_stone_defaults()
    })
    minetest.register_ore({
      ore_type       = "scatter",
      ore            = "goops_exchange:mineral_"..name,
      wherein        = uses.generate.generate_inside_of,
      clust_scarcity = uses.generate.chunks_per_mapblock,
      clust_num_ores = uses.generate.max_blocks_per_chunk,
      clust_size     = uses.generate.chunk_size,
      y_min     = uses.generate.miny,
      y_max     = uses.generate.maxy,
    })
    -- lump & ingot
    minetest.register_craftitem("goops_exchange:"..name.."_lump", {
      description = name:gsub("^%l",string.upper).." Lump",
      inventory_image = "gloopores_"..name.."_lump.png",
    })
    minetest.register_craftitem("goops_exchange:"..name.."_ingot", {
      description = name:gsub("^%l",string.upper).." Ingot",
      inventory_image = "gloopores_"..name.."_ingot.png",
      group = { glooptest_ingot = 1 }
    })
    minetest.register_craft({
      type = "cooking",
      output = "goops_exchange:"..name.."_ingot",
      recipe = "goops_exchange:"..name.."_lump",
    })
  end


  register_ore( "alatro", {
    base_texture = "default_stone.png",
    groups = {cracky=2},
    generate = {
      generate_inside_of = "default:stone",
      chunks_per_mapblock = 9*9*9,
      chunk_size = 2,
      max_blocks_per_chunk = 6,
      miny = 0,
      maxy = 256
    },
  })

  register_ore("talinite", {
    base_texture = "default_stone.png",
    groups = {cracky=1},
    light = 6,
    generate = {
      generate_inside_of = "default:stone",
      chunks_per_mapblock = 12*12*12,
      chunk_size = 2,
      max_blocks_per_chunk = 4,
      miny = -31000,
      maxy = -250
    }
  })

  register_ore("akalin", {
    base_texture = "default_desert_stone.png",
    groups = {cracky=3},
    generate = {
      generate_inside_of = "default:desert_stone",
      chunks_per_mapblock = 7*7*7,
      chunk_size = 3,
      max_blocks_per_chunk = 9,
      miny = 0,
      maxy = 256
    }
  })

  register_ore("arol", {
    base_texture = "default_stone.png",
    groups = {cracky=1},
    generate = {
      generate_inside_of = "default:stone",
      chunks_per_mapblock = 10*10*10,
      chunk_size = 2,
      max_blocks_per_chunk = 2,
      miny = -31000,
      maxy = -20
    }
  })

  -- NOTE from Glooptest mod:
  -- I did not make the textures. celeron55/erlehmann made the textures which were licensed under CC-BY-SA, and then edited by me.
  -- The textures for non-gem ores are thus CC-BY-SA, with respect to celeron55/erlehmann

end
