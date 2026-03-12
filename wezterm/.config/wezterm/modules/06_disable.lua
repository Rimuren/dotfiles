local wezterm = require("wezterm")
local disable = wezterm.action.DisableDefaultAssignment

return function(config)

local list = {
	{key='n',mods='SUPER'},
	{key='t',mods='SUPER'},
	{key='w',mods='SUPER'},
	{key='f',mods='SUPER'},
	{key='r',mods='SUPER'},
	{key='-',mods='SUPER'},
	{key='=',mods='SUPER'},
	{key='0',mods='SUPER'},
	{key='Enter',mods='ALT'},
	{key='t',mods='CTRL|SHIFT'},
	{key='w',mods='CTRL|SHIFT'},
	{key='f',mods='CTRL|SHIFT'},
	{key='x',mods='CTRL|SHIFT'},
	{key='p',mods='CTRL|SHIFT'},

	{key='_',mods='CTRL|SHIFT'},
	{key='+',mods='CTRL|SHIFT'},
	{key='0',mods='CTRL|SHIFT'},
	{key=')',mods='CTRL|SHIFT'},
}

for _,k in ipairs(list) do
  table.insert(config.keys,{key=k.key,mods=k.mods,action=disable})
end

for i=1,9 do
  table.insert(config.keys,{
    key=tostring(i),mods='SUPER',action=disable
  })
end

end
