local http_request = require "http.request";
local cjson = require "cjson";

local M = {}

-- setup
function M.setup(obj)
    local key = obj["key"]

    local host = 'wordsapiv1.p.rapidapi.com'

    -- get synonyms
    local Synonyms = function(opts)
        if key ~= nil then
            local word = string.lower(opts.args)
            local req = http_request.new_from_uri(string.format('https://wordsapiv1.p.rapidapi.com/words/%s/synonyms', word))

            req.headers:append('x-rapidapi-key', key)
            req.headers:append('x-rapidapi-host', host)

            local headers, stream = assert(req:go(10))

            local body = assert(stream:get_body_as_string())

            if headers:get ":status" ~= "200" then
                error(body)
            end

            local dec = cjson.decode(body)
            print("synonyms:")
            for _,v in pairs(dec["synonyms"]) do
                print(v)
            end

        else print("please set key with :WordmanSetKey")

        end

        end

    vim.api.nvim_create_user_command(
        'WordmanSynonyms',
        Synonyms,
        { nargs=1 }
        )

    -- get antonyms
    local Antonyms = function(opts)
        local word = string.lower(opts.args)
        local req = http_request.new_from_uri(string.format('https://wordsapiv1.p.rapidapi.com/words/%s/antonyms', word))

        req.headers:append('x-rapidapi-key', key)
        req.headers:append('x-rapidapi-host', host)

        local headers, stream = assert(req:go(10))

        local body = assert(stream:get_body_as_string())

        if headers:get ":status" ~= "200" then
            error(body)
        end

        local dec = cjson.decode(body)
        print("antonyms:")
        for _,v in pairs(dec["antonyms"]) do
            print(v)
        end

    end

    vim.api.nvim_create_user_command(
        'WordmanAntonyms',
        Antonyms,
        { nargs=1 }
        )

    -- get definitions
    local Definitions = function(opts)
        local word = string.lower(opts.args)
        local req = http_request.new_from_uri(string.format('https://wordsapiv1.p.rapidapi.com/words/%s/definitions', word))

        req.headers:append('x-rapidapi-key', key)
        req.headers:append('x-rapidapi-host', host)

        local headers, stream = assert(req:go(10))

        local body = assert(stream:get_body_as_string())

        if headers:get ":status" ~= "200" then
            error(body)
        end

        local dec = cjson.decode(body)
        print("definitions:")
        for _,definitions in ipairs(dec["definitions"]) do
            for _,definition in pairs(definitions) do
                print(definition["definition"])
            end
        end

    end

    vim.api.nvim_create_user_command(
        'WordmanDefinitions',
        Definitions,
        { nargs=1 }
        )

    -- get random
    local Random = function()
        local req = http_request.new_from_uri('https://wordsapiv1.p.rapidapi.com/words/?random=true')

        req.headers:append('x-rapidapi-key', key)
        req.headers:append('x-rapidapi-host', host)

        local headers, stream = assert(req:go(10))

        local body = assert(stream:get_body_as_string())

        if headers:get ":status" ~= "200" then
            error(body)
        end

        print(body)

    end

    vim.api.nvim_create_user_command(
        'WordmanRandom',
        Random,
        { nargs=0 }
        )

    -- get all
    local All = function(opts)

        Synonyms(opts)
        Antonyms(opts)
        Definitions(opts)

    end


    vim.api.nvim_create_user_command(
        'WordmanAll',
        All,
        { nargs=1 }
        )

    -- get word
    local Word = function(opts)
        local word = string.lower(opts.args)
        local req = http_request.new_from_uri(string.format('https://wordsapiv1.p.rapidapi.com/words/%s', word))

        req.headers:append('x-rapidapi-key', key)
        req.headers:append('x-rapidapi-host', host)

        local headers, stream = assert(req:go(10))

        local body = assert(stream:get_body_as_string())

        if headers:get ":status" ~= "200" then
            error(body)
        end

        print(body)

    end

    vim.api.nvim_create_user_command(
        'WordmanWord',
        Word,
        { nargs=1 }
        )
    end


return M
