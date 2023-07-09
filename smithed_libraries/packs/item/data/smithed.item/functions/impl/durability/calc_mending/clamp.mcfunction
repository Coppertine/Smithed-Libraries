from bolt_expressions import Data, Scoreboard
data_obj = Scoreboard("smithed.data")
xp_temp = data_obj["$xp.temp"]
xp_temp1 = data_obj["$xp.temp1"]

data_obj["$temp1"] += xp_temp
xp_temp1 = data_obj["$temp"] + data_obj["$temp1"]

max_mending = data_obj["$temp3"]
if score var xp_temp1 > var max_mending:
    function ./return_overflow:
        xp_temp1 -= max_mending
        data_obj["$temp1"] -= xp_temp1
        xp_temp -= xp_temp1
x = 256
xp_remove = 0
while x >= 2:
    if score var xp_temp matches f"{x}..":
        xp add @s int(-1 * (x / 2)) points
        xp_temp -= int(x)
    x /= 2