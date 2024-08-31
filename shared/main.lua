QBShared = QBShared or {}

local StringCharset = {}
local NumberCharset = {}

QBShared.StarterItems = {
    ['welcomeflyer'] = { amount = 1, item = 'welcomeflyer' },
    ['money'] = { amount = 500, item = 'money' },
}

for i = 48, 57 do NumberCharset[#NumberCharset + 1] = string.char(i) end
for i = 65, 90 do StringCharset[#StringCharset + 1] = string.char(i) end
for i = 97, 122 do StringCharset[#StringCharset + 1] = string.char(i) end

function QBShared.RandomStr(length)
    if length <= 0 then return '' end
    return QBShared.RandomStr(length - 1) .. StringCharset[math.random(1, #StringCharset)]
end

function QBShared.RandomInt(length)
    if length <= 0 then return '' end
    return QBShared.RandomInt(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
end

function QBShared.SplitStr(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    local timeout = GetGameTimer() + 2000
    while delim_from and GetGameTimer() < timeout do
        result[#result + 1] = string.sub(str, from, delim_from - 1)
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
    result[#result + 1] = string.sub(str, from)
    return result
end

function QBShared.Trim(value)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

function QBShared.FirstToUpper(value)
    if not value then return nil end
    return (value:gsub("^%l", string.upper))
end

function QBShared.Round(value, numDecimalPlaces)
    if not numDecimalPlaces then return math.floor(value + 0.5) end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

function QBShared.GroupDigits(value)
    value = QBShared.Round(value)
    local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ' '):reverse())..right
end

function QBShared.ChangeVehicleExtra(vehicle, extra, enable)
    if DoesExtraExist(vehicle, extra) then
        if enable then
            SetVehicleExtra(vehicle, extra, false)
            if not IsVehicleExtraTurnedOn(vehicle, extra) then
                QBShared.ChangeVehicleExtra(vehicle, extra, enable)
            end
        else
            SetVehicleExtra(vehicle, extra, true)
            if IsVehicleExtraTurnedOn(vehicle, extra) then
                QBShared.ChangeVehicleExtra(vehicle, extra, enable)
            end
        end
    end
end

function QBShared.SetDefaultVehicleExtras(vehicle, config)
    -- Clear Extras
    for i = 1, 20 do
        if DoesExtraExist(vehicle, i) then
            SetVehicleExtra(vehicle, i, 1)
        end
    end

    for id, enabled in pairs(config) do
        QBShared.ChangeVehicleExtra(vehicle, tonumber(id), type(enabled) == 'boolean' and enabled or true)
    end
end

function QBShared.CheckBlPlate(plate)
    if string.match(plate, 'MCE') or string.match(plate, 'MIS') or string.match(plate, 'REN') or string.match(plate, 'LSPD') then
        return true
    else
        return false
    end
end

QBShared.MaleGloves = {
    [16] = true,
    [17] = true,
    [19] = true,
    [20] = true,
    [21] = true,
    [22] = true,
    [23] = true,
    [24] = true,
    [25] = true,
    [26] = true,
    [27] = true,
    [28] = true,
    [29] = true,
    [30] = true,
    [31] = true,
    [32] = true,
    [33] = true,
    [34] = true,
    [35] = true,
    [36] = true,
    [37] = true,
    [38] = true,
    [39] = true,
    [40] = true,
    [41] = true,
    [42] = true,
    [43] = true,
    [44] = true,
    [45] = true,
    [46] = true,
    [47] = true,
    [48] = true,
    [49] = true,
    [50] = true,
    [51] = true,
    [63] = true,
    [64] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [72] = true,
    [73] = true,
    [74] = true,
    [75] = true,
    [76] = true,
    [77] = true,
    [78] = true,
    [79] = true,
    [80] = true,
    [81] = true,
    [82] = true,
    [83] = true,
    [84] = true,
    [85] = true,
    [86] = true,
    [87] = true,
    [88] = true,
    [89] = true,
    [90] = true,
    [91] = true,
    [92] = true,
    [93] = true,
    [94] = true,
    [95] = true,
    [96] = true,
    [97] = true,
    [98] = true,
    [99] = true,
    [100] = true,
    [101] = true,
    [102] = true,
    [103] = true,
    [104] = true,
    [105] = true,
    [106] = true,
    [107] = true,
    [108] = true,
    [109] = true,
    [110] = true,
    [111] = true,
    [115] = true,
    [116] = true,
    [117] = true,
    [119] = true,
    [120] = true,
    [121] = true,
    [122] = true,
    [123] = true,
    [124] = true,
    [126] = true,
    [127] = true,
    [128] = true,
    [129] = true,
    [130] = true,
    [131] = true,
    [133] = true,
    [134] = true,
    [135] = true,
    [136] = true,
    [137] = true,
    [138] = true,
    [139] = true,
    [140] = true,
    [141] = true,
    [142] = true,
    [143] = true,
    [144] = true,
    [145] = true,
    [146] = true,
    [147] = true,
    [148] = true,
    [149] = true,
    [150] = true,
    [151] = true,
    [152] = true,
    [153] = true,
    [154] = true,
    [155] = true,
    [156] = true,
    [157] = true,
    [158] = true,
    [159] = true,
    [160] = true,
    [161] = true,
    [162] = true,
    [163] = true,
    [164] = true,
    [165] = true,
    [166] = true,
    [167] = true,
    [168] = true,
    [169] = true,
    [170] = true,
    [171] = true,
    [172] = true,
    [173] = true,
    [174] = true,
    [175] = true,
    [176] = true,
    [177] = true,
    [178] = true,
    [179] = true,
    [180] = true,
    [181] = true,
    [182] = true,
    [183] = true,
    [185] = true,
    [186] = true,
    [187] = true,
    [189] = true,
    [190] = true,
    [191] = true,
    [192] = true,
    [193] = true,
    [194] = true,
    [195] = true,
    [197] = true,
    [199] = true,
    [200] = true,
    [201] = true,
    [203] = true,
    [204] = true,
    [205] = true,
    [206] = true,
    [207] = true,
    [208] = true,
    [209] = true,
    [210] = true,
    [211] = true,
    [212] = true,
    [213] = true,
    [223] = true,
    [224] = true,
    [225] = true,
    [226] = true,
    [227] = true,
    [228] = true,
    [229] = true,
    [230] = true,
    [231] = true,
    [232] = true,
    [233] = true,
}

QBShared.FemaleGloves = {
    [16] = true,
    [17] = true,
    [18] = true,
    [20] = true,
    [21] = true,
    [22] = true,
    [23] = true,
    [24] = true,
    [25] = true,
    [26] = true,
    [27] = true,
    [28] = true,
    [29] = true,
    [30] = true,
    [31] = true,
    [32] = true,
    [33] = true,
    [34] = true,
    [35] = true,
    [36] = true,
    [37] = true,
    [38] = true,
    [39] = true,
    [40] = true,
    [41] = true,
    [42] = true,
    [43] = true,
    [44] = true,
    [45] = true,
    [46] = true,
    [47] = true,
    [48] = true,
    [49] = true,
    [50] = true,
    [51] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [72] = true,
    [73] = true,
    [74] = true,
    [75] = true,
    [76] = true,
    [77] = true,
    [78] = true,
    [79] = true,
    [80] = true,
    [81] = true,
    [82] = true,
    [83] = true,
    [84] = true,
    [85] = true,
    [86] = true,
    [87] = true,
    [88] = true,
    [89] = true,
    [90] = true,
    [91] = true,
    [92] = true,
    [93] = true,
    [94] = true,
    [95] = true,
    [96] = true,
    [97] = true,
    [98] = true,
    [99] = true,
    [100] = true,
    [101] = true,
    [102] = true,
    [103] = true,
    [104] = true,
    [105] = true,
    [106] = true,
    [107] = true,
    [108] = true,
    [109] = true,
    [110] = true,
    [111] = true,
    [112] = true,
    [113] = true,
    [114] = true,
    [115] = true,
    [116] = true,
    [117] = true,
    [118] = true,
    [119] = true,
    [120] = true,
    [121] = true,
    [122] = true,
    [123] = true,
    [124] = true,
    [125] = true,
    [126] = true,
    [127] = true,
    [128] = true,
    [132] = true,
    [133] = true,
    [134] = true,
    [136] = true,
    [137] = true,
    [138] = true,
    [139] = true,
    [140] = true,
    [141] = true,
    [143] = true,
    [144] = true,
    [145] = true,
    [146] = true,
    [147] = true,
    [148] = true,
    [150] = true,
    [151] = true,
    [152] = true,
    [154] = true,
    [155] = true,
    [156] = true,
    [158] = true,
    [159] = true,
    [160] = true,
    [162] = true,
    [163] = true,
    [164] = true,
    [166] = true,
    [167] = true,
    [168] = true,
    [169] = true,
    [170] = true,
    [171] = true,
    [172] = true,
    [173] = true,
    [174] = true,
    [175] = true,
    [176] = true,
    [177] = true,
    [178] = true,
    [179] = true,
    [180] = true,
    [181] = true,
    [182] = true,
    [183] = true,
    [184] = true,
    [185] = true,
    [186] = true,
    [187] = true,
    [188] = true,
    [189] = true,
    [190] = true,
    [191] = true,
    [192] = true,
    [193] = true,
    [194] = true,
    [195] = true,
    [196] = true,
    [197] = true,
    [198] = true,
    [199] = true,
    [200] = true,
    [201] = true,
    [202] = true,
    [203] = true,
    [204] = true,
    [205] = true,
    [206] = true,
    [207] = true,
    [208] = true,
    [209] = true,
    [210] = true,
    [211] = true,
    [212] = true,
    [213] = true,
    [214] = true,
    [215] = true,
    [216] = true,
    [217] = true,
    [218] = true,
    [219] = true,
    [220] = true,
    [221] = true,
    [222] = true,
    [223] = true,
    [224] = true,
    [225] = true,
    [226] = true,
    [227] = true,
    [228] = true,
    [230] = true,
    [231] = true,
    [232] = true,
    [234] = true,
    [235] = true,
    [236] = true,
    [237] = true,
    [238] = true,
    [239] = true,
    [240] = true,
    [242] = true,
    [243] = true,
    [244] = true,
    [245] = true,
    [246] = true,
    [247] = true,
}

QBShared.MaleBulletproof = {
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [8] = true,
    [9] = true,
    [10] = true,
    [11] = true,
    [12] = true,
    [13] = true,
    [14] = true,
    [15] = true,
    [18] = true,
    [20] = true,
    [21] = true,
    [22] = true,
    [32] = true,
    [33] = true,
    [34] = true,
    [35] = true,
    [36] = true,
    [37] = true,
    [38] = true,
    [39] = true,
    [40] = true,
    [41] = true,
    [42] = true,
    [43] = true,
    [44] = true,
    [45] = true,
    [46] = true,
    [47] = true,
    [52] = true,
    [53] = true,
    [54] = true,
    [55] = true,
    [56] = true,
    [57] = true,
    [58] = true,
    [60] = true,
    [61] = true,
    [62] = true,
    [63] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [70] = true,
    [71] = true,
    [72] = true,
    [73] = true,
    [74] = true,
    [75] = true,
    [76] = true,
    [77] = true,
    [78] = true,
    [79] = true,
    [109] = true,
    [110] = true,
    [111] = true,
    [112] = true,
    [124] = true,
    [125] = true,
}

QBShared.FemaleBulletproof = {
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [7] = true,
    [9] = true,
    [11] = true,
    [13] = true,
    [15] = true,
    [16] = true,
    [17] = true,
    [18] = true,
    [19] = true,
    [20] = true,
    [21] = true,
    [25] = true,
    [26] = true,
    [27] = true,
    [28] = true,
    [29] = true,
    [30] = true,
    [31] = true,
    [32] = true,
    [33] = true,
    [34] = true,
    [35] = true,
    [36] = true,
    [37] = true,
    [38] = true,
    [39] = true,
    [40] = true,
    [65] = true,
    [66] = true,
    [67] = true,
    [68] = true,
    [69] = true,
    [75] = true,
    [76] = true,
}

QBShared.MaleBags = {

}

QBShared.FemaleBags = {

}

QBShared.SalaryPeriods = {
    { label = "Aucune", time = 0 },
    { label = "5 minutes", time = 5 * 60000 },
    { label = "10 minutes", time = 10 * 60000 },
    { label = "15 minutes", time = 15 * 60000 },
    { label = "20 minutes", time = 20 * 60000 },
    { label = "30 minutes", time = 30 * 60000 },
    { label = "1 heure", time = 60 * 60000 },
}