local method = ngx.req.get_method()
local cjson = require "cjson"

local Data = ngx.shared.my_data

local function Add(name, age)
    local id = tostring(math.random(100000, 999999))
    local item = cjson.encode({ name = name, age = age })
    Data:set(id, item)
end

local function GetAll()
    local result = {}
    local keys = Data:get_keys()
    for _, key in ipairs(keys) do
        table.insert(result, cjson.decode(Data:get(key)))
    end
    return result
end

local function Get()
    -- ngx.header.content_type = "application/json"
    local json_response = cjson.encode(GetAll())
    ngx.say(json_response)
end

local function Post()
    ngx.req.read_body()
    local data = ngx.req.get_body_data()

    if not data then
        ngx.status = ngx.HTTP_BAD_REQUEST
        -- ngx.header.content_type = "application/json"
        ngx.say(cjson.encode({ error = "Invalid request body" }))
        return
    end

    local ok, json_data = pcall(cjson.decode, data)

    if not ok then
        ngx.status = ngx.HTTP_BAD_REQUEST
        -- ngx.header.content_type = "application/json"
        ngx.say(cjson.encode({ error = "Invalid JSON" }))
        return
    end

    Add(json_data.name or "unknown", json_data.age or 0)

    ngx.status = ngx.HTTP_OK
    -- ngx.header.content_type = "application/json"
    ngx.say(cjson.encode({ success = true, message = "Data added successfully" }))
end

if method == "GET" then
    Get()
elseif method == "POST" then
    Post()
else
    ngx.status = ngx.HTTP_NOT_FOUND
    ngx.say("<p> Not found 404 </p>")
end
