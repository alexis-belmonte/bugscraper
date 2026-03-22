return function(en_old, en_new_str, en_new_tbl, target_tbl, output_path)
    local lines = {}
    local stack = {}
    
    -- Helper to get nested values via a list of keys
    local function get_nested_val(tbl, path_stack)
        local current = tbl
        for _, key in ipairs(path_stack) do
            if type(current) ~= "table" then return nil end
            current = current[key]
        end
        return current
    end

    -- Process the English string line by line
    for line in en_new_str:gmatch("([^\r\n]*)[\r\n]?") do
        -- 1. Detect entering a new table: key = {
        local table_key = line:match('^%s*([%w_]+)%s*=%s*{') or line:match('^%s*%["([%w_]+)"%]%s*=%s*{')
        if table_key then
            table.insert(stack, table_key)
            table.insert(lines, line)
        
        -- 2. Detect exiting a table: },
        elseif line:match('^%s*},') or line:match('^%s*}%s*$') then
            table.insert(lines, line)
            table.remove(stack)

        -- 3. Detect a key-value pair: key = "value" (comma optional)
        else
            -- We capture 'trailing' to remember if there was a comma or specific spacing
            local key, quote, val, trailing = line:match('^%s*([%w_]+)%s*=%s*(["\'])(.-)%2(,?%s*)')

            if not key then -- try bracketed key format ["key"]
                key, quote, val, trailing = line:match('^%s*%["([%w_]+)"%]%s*=%s*(["\'])(.-)%2(,?%s*)')
            end

            if key then
                table.insert(stack, key)
                
                local en_old_val = get_nested_val(en_old, stack)
                local en_new_val = get_nested_val(en_new_tbl, stack)
                local target_val = get_nested_val(target_tbl, stack)
                
                local final_val = ""
                
                if en_old_val == nil then
                    final_val = string.format("[[ADDED / '%s']]", en_new_val)
                elseif en_old_val ~= en_new_val then
                    local base = target_val or en_old_val
                    final_val = string.format("%s[[CHANGED / old:'%s' / new:'%s']]", base, en_old_val, en_new_val)
                else
                    final_val = target_val or en_new_val
                end

                -- Reconstruct the line
                local indent = line:match("^(%s*)")
                local comment = line:match("%-%-.+$") or ""
                -- if comment ~= "" then comment = " " .. comment end
                
                -- We use the 'trailing' capture to preserve the comma (or lack thereof)
                local newLine = string.format('%s%s = %s%s%s%s%s', indent, key, quote, final_val, quote, trailing, comment)
                table.insert(lines, newLine)
                
                table.remove(stack)
            else
                -- Just a comment line or empty line, keep as is
                table.insert(lines, line)
            end
        end
    end

    -- Write to file
    local file = io.open(output_path, "w")
    if file then
        file:write(table.concat(lines, "\n"))
        file:close()
        print("File saved to: " .. output_path)
    end
end