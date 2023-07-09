from bolt_expressions import Data, Scoreboard
data_obj = Scoreboard("smithed.data")
xp_obj = Scoreboard("smithed.xp")
prev_xp_obj = Scoreboard("smithed.xp")
storage_data = Data.storage(smithed.item:main)
item_durability = data_obj["$temp"]
durability_damage = data_obj["$temp1"]
item_damage = data_obj["$temp2"]
max_durability = data_obj["$temp3"]
base_max_durability = data_obj["$temp4"]

item_durability = storage_data.item.tag.smithed.durability.dur
durability_damage = storage_data.item.tag.smithed.durability.damage
item_damage = storage_data.item.tag.Damage
max_durability = storage_data.item.tag.smithed.durability.max

function smithed.item:impl/durability/get_max

# change internal dur value
durability_damage -= item_damage

if score var durability_damage matches 1.. if data var storage_data.item.tag.Enchantments[{"id":"minecraft:mending"}]:
    function smithed.item:impl/durability/calc_mending:
        data_obj["$xp.temp"] = (xp_obj["@s"] - prev_xp_obj["@s"]) * 2
        if score var data_obj["$xp.temp"] matches 1..:
            function smithed.item:impl/durability/calc_mending/clamp

item_durability += durability_damage
durability_damage += item_damage

# if (base.MaxDur > 1 && durability.dur > durability.max) then durability.dur = durability.max
if score var base_max_durability matches 1..:
    if score var item_durability > var max_durability:
        item_durability = max_durability

if score var item_durability matches ..-1:
    item_durability = -1

# if (base.MaxDur >= 1) then item.tag.smithed.durability.dur = durability.dur
if score var base_max_durability matches 1..:
    storage_data.item.tag.smithed.durability.dur = item_durability

# Set durability bar
temp5 = data_obj["temp5"]
temp6 = data_obj["temp6"]

temp5 = base_max_durability
temp6 = base_max_durability - 8

temp5 *= item_durability
temp5 /= max_durability

base_max_durability -= temp5

# if (base.MaxDur > 1 && base.MaxDur > temp6) then base.MaxDur = temp6 
if score var base_max_durability matches 1..:
    if score var base_max_durability > var temp6:
        base_max_durability = temp6

# execute if score $temp4 smithed.data matches 1.. store result storage smithed.item:main item.tag.Damage int 1 run scoreboard players get $temp4 smithed.data
# execute if score $temp4 smithed.data matches 1.. store result storage smithed.item:main item.tag.smithed.durability.damage int 1 run scoreboard players get $temp4 smithed.data
if score var base_max_durability matches 1..:
    storage_data.item.tag.Damage = base_max_durability
    storage_data.item.tag.smithed.durability.damage = base_max_durability

# change durability of unbreakable items
# execute if score $temp4 smithed.data matches 0 store result score $temp smithed.data run data get storage smithed.item:main item.tag.smithed.durability.dur
# execute if score $temp4 smithed.data matches 0 run scoreboard players remove $temp smithed.data 1
# execute if score $temp4 smithed.data matches 0 store result storage smithed.item:main item.tag.smithed.durability.dur int 1 run scoreboard players get $temp smithed.data

if score var base_max_durability matches 0:
    item_durability = storage_data.item.tag.smithed.durability.dur
    item_durability -= 1
    storage_data.item.tag.smithed.durability.dur = item_durability

function smithed.item:impl/lore/build

# output state
output = data_obj["$out"]
output = 1
if score var item_durability matches ..-1:
    if data var storage_data.item.tag.smithed.durability:
        output = 0
    if data var storage_data.item.tag.smithed.durability({no_break:1b}):
        output = -1

# scoreboard players set $out smithed.data 1
# execute if score $temp smithed.data matches ..-1 if data storage smithed.item:main item.tag.smithed.durability run scoreboard players set $out smithed.data 0
# execute if score $temp smithed.data matches ..-1 if data storage smithed.item:main item.tag.smithed.durability{no_break:1b} run scoreboard players set $out smithed.data -1
