print(os.date())

local function file_exists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

local function get_workdir()
    local info = debug.getinfo(1, "S")
    --for k,v in pairs(info) do
    --    print(k, ":", v)
    --end
    local path = info.source
    path = string.sub(path, 2, -1) -- remove begin '@'
    path = string.match(path, '^.*\\')
    return path
end

local workdir = get_workdir()
local plug_dir = 'vendor'


---
-- autosuggestions {{{
---
rl.setbinding([["\C-k"]], [["\e[F"]])


---
-- z.lua {{{
---
local z_lua_path = clink.get_env('z_lua_path')..'/z.lua'
if file_exists(z_lua_path) then
    --dofile(z_lua_path)  --pcall(debug.getlocal, 4, 1) not nil
    local z_lua = loadfile(z_lua_path)
    z_lua()
end


---
-- clink-completions {{{
---
plug_dir = workdir .. '/vendor/clink-completions/'
-- Execute '.init.lua' first to ensure package.path is set properly
if file_exists(plug_dir..'.init.lua') == false then
    os.execute('git clone --depth 1 https://github.com/vladimir-kotikov/clink-completions ' .. plug_dir)
end
if file_exists(plug_dir..'.init.lua') == true then
    dofile(plug_dir..'.init.lua')
    for _,lua_module in ipairs(clink.find_files(plug_dir..'*.lua')) do
        -- Skip files that starts with _. This could be useful if some files should be ignored
        if not string.match(lua_module, '^_.*') then
            local filename = plug_dir..lua_module
            -- use dofile instead of require because require caches loaded modules
            -- so config reloading using Alt-Q won't reload updated modules.
            dofile(filename)
        end
    end
end


---
-- fzf {{{
---
_FZF = 'fzf --reverse --height 40% '
_FZF_HISTORY_OPT = '--tac'
_FZF_HISTORY_NUMBER = 1
---@diagnostic disable-next-line
function fzf_file(rl_buffer)
    local f = assert(io.popen(_FZF))
    local str = f:read('*all')
    f:close()
    if #str > 0 then
        str = string.sub(str,1,-2)
        rl_buffer:insert(str)
    end
    rl_buffer:refreshline()
end
---@diagnostic disable-next-line
function fzf_history(rl_buffer)
    local cmd = ''
    if _FZF_HISTORY_NUMBER == 1 then
        cmd = 'clink history | '.._FZF.._FZF_HISTORY_OPT
    else
        cmd = 'clink history --bare | '.._FZF.._FZF_HISTORY_OPT
    end
    local f = assert(io.popen(cmd))
    local str = f:read('*all')
    f:close()
    str = string.sub(str,1,-2)
    if #str > 0 then
        if _FZF_HISTORY_NUMBER == 1 then
            --delete history line number
            str = string.gsub(str, "%s+%d+%s+", "")
        end
        rl_buffer:insert(str)
    end
    rl_buffer:refreshline()
end
rl.setbinding([["\C-t"]], [["luafunc:fzf_file"]])
rl.setbinding([["\C-r"]], [["luafunc:fzf_history"]])


---
-- prompt {{{
---
---@diagnostic disable
local NORMAL    = "\x1b[m"
local RED       = "\x1b[31m"
local GREEN     = "\x1b[32m"
local YELLOW    = "\x1b[33m"
local BLUE      = "\x1b[34m"
local MAGENTA   = "\x1b[35m"
local CYAN      = "\x1b[36m"
local WHITE     = "\x1b[37m"
---@diagnostic enable

local function git_prompt_info()
    local f = io.popen('git symbolic-ref HEAD 2>NUL')
    local str = f:read('*line')
    f:close()
    if str then
        str = str:match('refs/heads/(.+)')
    else
        f = io.popen('git rev-parse --short HEAD 2>NUL')
        str = f:read('*line')
        f:close()
    end
    if str then
        return RED .. ' ‹' .. str .. '›' .. NORMAL
    end
    return ''
end

local prompt = clink.promptfilter(30)
function prompt:filter(old_prompt)
    local git = git_prompt_info()
    -- The matching relies on the default prompt which ends in X:\PATH\PATH>
    local cwd = old_prompt:match('.*(.:[^>]*)>') or clink.get_cwd()
    return BLUE .. cwd .. NORMAL .. git .. '$'
end

