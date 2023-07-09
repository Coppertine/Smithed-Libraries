from bolt_expressions import Data, Scoreboard
data_obj = Scoreboard("smithed.data")
storage_data = Data.storage(smithed.item:main) 

item_durability = storage_data.item.tag.smithed.durability

if not item_durability.dur:
    function smithed.item:impl/durability/init:
        item_durability.dur = item_durability.max
        item_durability.damage = 0

function smithed.item:impl/durability/calc_durability

if score var data_obj["$out"] matches -1..0:
    playsound entity.item.break player @a[distance=..16]

if score var data_obj["$out"] matches 0:
    storage_data.item = "null"