print (" claimflag Loading ")
claimflag = {}

claimflag.node = "claimflag:locker"

minetest.register_craft({
	output = claimflag.node .. " 4",
	recipe = {
		{'default:steelblock', 'default:steelblock', 'default:steelblock'},
		{'default:steelblock', '', 'default:copper_ingot'},
		{'default:steelblock', 'default:steelblock', 'default:steelblock'},
	}
})


minetest.register_node(claimflag.node, {
	description = "Locker",
	drawtype = "mesh",
	mesh = "locker.obj",
	tiles = {"locker.png"},
	paramtype = "light",
	paramtype2 = "facedir",
	walkable = true,
	climbable = true,
	sunlight_propagates = true,
	inventory_image = "locker_inv.png",
	groups = {cracky= 3.5},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Locker(owned by "..
				meta:get_string("owner")..")")
	end,
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
meta:set_string("formspec",
				"size[8,9]"..
				default.gui_bg ..
				default.gui_bg_img ..
				default.gui_slots ..
				"list[current_name;main;0,0.3;8,4;]"..
				"list[current_player;main;0,4.85;8,1;]" ..
				"list[current_player;main;0,6.08;8,3;8]" ..
				"listring[current_name;main]"..
				"listring[current_player;main]" ..
				default.get_hotbar_bg(0,4.85))
		meta:set_string("infotext", "Locker")
		meta:set_string("owner", "")
		local inv = meta:get_inventory()
		inv:set_size("main", 8*4)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return inv:is_empty("main")
	end,
    on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_claimflag_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locker belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return
		end
		minetest.log("action", player:get_player_name()..
				" moves stuff in locker at "..minetest.pos_to_string(pos))
		return minetest.node_metadata_inventory_move_allow_all(
				pos, from_list, from_index, to_list, to_index, count, player)
	end,
    on_metadata_inventory_offer = function(pos, listname, index, stack, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_claimflag_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locker belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return stack
		end
		minetest.log("action", player:get_player_name()..
				" moves stuff to locker at "..minetest.pos_to_string(pos))
		return minetest.node_metadata_inventory_offer_allow_all(
				pos, listname, index, stack, player)
	end,
    on_metadata_inventory_take = function(pos, listname, index, count, player)
		local meta = minetest.env:get_meta(pos)
		if not has_locked_claimflag_privilege(meta, player) then
			minetest.log("action", player:get_player_name()..
					" tried to access a locker belonging to "..
					meta:get_string("owner").." at "..
					minetest.pos_to_string(pos))
			return
		end
		minetest.log("action", player:get_player_name()..
				" takes stuff from locker at "..minetest.pos_to_string(pos))
		return minetest.node_metadata_inventory_take_allow_all(
				pos, listname, index, count, player)
	end,
})


print (" locker Loaded!!! ")