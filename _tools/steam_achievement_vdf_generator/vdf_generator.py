import re
import os

def parse_lua_to_dict(content):
    """
    Flattens a Lua table into a python dict with dot notation keys.
    Enforces matching quotes to prevent cutting off strings at apostrophes.
    """
    flat_dict = {}
    
    # Remove all comments (block and single line)
    content = re.sub(r'--\[\[.*?\]\]', '', content, flags=re.DOTALL)
    content = re.sub(r'--.*', '', content)
    
    # Improved pattern: 
    # Group 1: key
    # Group 2: double-quoted value
    # Group 3: single-quoted value
    # Group 4: start of a table {
    pattern = re.compile(r'(\w+)\s*=\s*(?:"(.*?)"|\'(.*?)\'|(\{))')
    
    lines = content.split('\n')
    current_path = []
    
    for line in lines:
        # Track depth: if a line contains only '}', pop the path
        # (Very basic Lua table tracking)
        stripped = line.strip().rstrip(',')
        if stripped == '}':
            if current_path: current_path.pop()
            continue

        matches = pattern.findall(line)
        for key, dbl_val, sng_val, is_table in matches:
            if is_table:
                current_path.append(key)
            else:
                # Use whichever quote group captured the value
                value = dbl_val if dbl_val != '' else sng_val
                full_key = ".".join(current_path + [key])
                flat_dict[full_key] = value
                
    return flat_dict

def parse_vdf_tokens(content):
    """Extracts key-value pairs from the Tokens block of a VDF."""
    tokens_block = re.search(r'\"Tokens\"\s*\{([\s\S]*?)\}', content)
    if tokens_block:
        return re.findall(r'\"(.*?)\"\s*\"(.*?)\"', tokens_block.group(1))
    return []

def translate_vdf(en_vdf_path, en_lua_path, target_lua_path, output_lang_name):
    with open(en_vdf_path, 'r', encoding='utf-8') as f:
        en_vdf_content = f.read()
    with open(en_lua_path, 'r', encoding='utf-8') as f:
        en_lua_dict = parse_lua_to_dict(f.read())
    with open(target_lua_path, 'r', encoding='utf-8') as f:
        target_lua_dict = parse_lua_to_dict(f.read())

    # Reverse map: English Value -> Lua Key
    reverse_en_map = {v: k for k, v in en_lua_dict.items()}

    vdf_pairs = parse_vdf_tokens(en_vdf_content)
    
    new_tokens = []
    for key, en_value in vdf_pairs:
        lua_key = reverse_en_map.get(en_value)
        
        if lua_key and lua_key in target_lua_dict:
            translated_value = target_lua_dict[lua_key]
        else:
            translated_value = en_value
            # Only print warning if it's not a known heart symbol or similar
            if en_value not in ["7 ❤", "100"]: 
                print(f"Warning: No match for '{en_value}'")

        # Use 4-space tabs for Steam VDF cleanliness
        new_tokens.append(f'\t\t"{key}"\t\t"{translated_value}"')

    output = [
        '"lang"',
        '{',
        f'\t"Language"\t"{output_lang_name}"',
        '\t"Tokens"',
        '\t{',
        *new_tokens,
        '\t}',
        '}'
    ]

    return "\n".join(output)

if __name__ == "__main__":
    # https://partner.steamgames.com/doc/store/localization/languages

    langs = ["fr", "es", "pl", "pt_BR", "ja"]
    code_to_name = {
        "fr": "french",
        "es": "spanish",
        "pl": "polish",
        "pt_BR": "brazilian",
        "ja": "japanese",
        "zh": "schinese"
    }
    
    for lang in langs:
        EN_VDF = "/mnt/c/docs/gamedev/bugscraper/bugscraper/_tools/steam_achievement_vdf_generator/2957130_loc_english.vdf"
        EN_LUA = "/mnt/c/docs/gamedev/bugscraper/bugscraper/data/lang/en.lua"
        TARGET_LUA = f"/mnt/c/docs/gamedev/bugscraper/bugscraper/data/lang/{lang}.lua"
        TARGET_LANG_NAME = code_to_name[lang]

        OUTPUT_FILE = f"achievements_{TARGET_LANG_NAME}.vdf"

        if os.path.exists(EN_VDF) and os.path.exists(EN_LUA) and os.path.exists(TARGET_LUA):
            result = translate_vdf(EN_VDF, EN_LUA, TARGET_LUA, TARGET_LANG_NAME)
            with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
                f.write(result)
            print(f"Successfully generated {OUTPUT_FILE}")
        else:
            print("Error: Ensure all 3 input files exist in the directory.")