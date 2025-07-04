local requiredItems = {
    ['hookfunction'] = {'hookfunction','hookfunc','debug.hookfunction','debug.hookfunc','hook'},
    ['getrawmetatable'] = {'getrawmetatable','debug.getmetatable'},
    ['setreadonly'] = {'setreadonly','set_readonly','make_readonly'},
    ['getnamecallmethod'] = {'getnamecallmethod','get_namecall_method'},

    ['httpget'] = {'httpget','httpgetasync','HttpGet','HttpGetAsync','game.HttpGet','game.HttpGetAsync'},
    ['httppost'] = {'httppost','HttpPostAsync','HttpPost','http_post','game.HttpPost','game.HttpPostAsync'},
    ['request'] = {'syn.request','request','http_request','fetch','fluxus.request'},
}
local suggestedItems = {
    ['clipboard'] = {'toclipboard','setclipboard','setrbxclipboard','clipboard.set','writeclipboard','copyclipboard'},
    ['getcustomasset'] = {'getcustomasset','get_custom_asset','getsynasset'},
    ['writefile'] = {'writefile','WriteFile','write_file','syn_io_write'},
    ['isfile'] = {'isfile'},
    ['delfile'] = {'delfile','delFile','deletefile','delete_file'},
    ['cloneref'] = {'cloneref','cloneRef','clone_ref'},
}
local gotItems = {}

local function exists(names,_type,msg)
    local items = {}
    local itemNames = {}
    local got = false

    for _,name in names do
        local success, item = pcall(function()
            return loadstring('return '..tostring(name))()
        end)
        
        if success and item and (typeof(item) == _type or type(item) == _type) then
            table.insert(items,item)
            itemNames[name] = item
            got = true
        end
    end

    if got then
        return true, items, itemNames
    else
        warn(msg)
        return false, items, itemNames
    end
end

for i,v in suggestedItems do
    local result = table.pack(exists(v,'function','Suggested item \''..i..'\' couldn\'t be found.')) 
    gotItems[i] = result
end

for i,v in requiredItems do
    local result = table.pack(exists(v,'function','Required item \''..i..'\' couldn\'t be found.')) 
    if result[1] ~= true then
        return false,'Required item \''..i..'\' couldn\'t be found.'
    end
    gotItems[i] = result
end

return gotItems
