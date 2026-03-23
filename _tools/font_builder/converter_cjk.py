from fontTools.ttLib import TTFont
from PIL import Image, ImageDraw, ImageFont
import re 
import os

# Configuration
font_path = "fusion_pixel/10px/fusion-pixel-10px-proportional-ja.ttf"     # Replace with your font path
output_image = "font_ja.png"       # Output image file name
output_text = "font_ja_characters.lua"    # Output text file for character list

# output_format = "return \"{}\"" # If not None, is the format of the contents of the output txt file
output_format = "return \"{}\""
# String|None
language_file_path = r"/mnt/c/docs/gamedev/bugscraper/bugscraper/data/lang/ja.lua"
output_folder = r"/mnt/c/docs/gamedev/bugscraper/bugscraper/_tools/font_builder/"

output_height = 14
font_size = 10
# min_codepoint = 10075   # Minimum Unicode code point to include
min_codepoint = 0   # Minimum Unicode code point to include
font_offset_y = 0

# Excluded characters
ASCII = "".join([chr(i) for i in range(32, 127)])
FONT_CHARACTERS = " !\"#$%&'()*+,-·./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz"+ \
    "{|}~ ¡¢£©®°¿ÀÁÂÃÄÅĄÆÇĆÈÉÊËĘÌÍÎÏŁÐÑŃÒÓÔÕÖØÙÚÛÜŚÝŹŻŒÞßàáâãäåąæçćèéêëęìíîïłðñńòóôõöøùúûüśýźżœþÿŸЁАБВГДЕЖЗИЙКЛМНО"+ \
    "ПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяё€"
FONT_SYMBOLS_CHARACTERS = \
    "🔊🔉🔈🎵🎼🔳🔲📺🕐↖🛜▶⏸✓❌🔄🔘⬅➡⬆⬇⏏🔫🔚📥👆🔙🗄⌨🎮🎚❤" + \
    "✅❎🔗💡⚠🕹🫨💧🐜🐛🐝🪲🈶🌄🛅😎😈🐦𝕏🦋🐰🐞🌐⏭🥚🥦🐧🎓🔺🦂💀⏰🔥⭐🍊🏆⎘⚔️"
excluded_characters = set(ASCII) | set(FONT_CHARACTERS) | set(FONT_SYMBOLS_CHARACTERS)
appended_images = [
    "/mnt/c/docs/gamedev/bugscraper/bugscraper/fonts/hope_gold.png", 
    "/mnt/c/docs/gamedev/bugscraper/bugscraper/fonts/font_symbols.png"
]

background_color = 0x00000000
text_color = "white"
separator_color = "red"


def extract_language_file_values(language_file_path) -> list[str]:
    if not language_file_path:
        return []
    
    values = []
    with open(language_file_path, "r", encoding="utf-8") as f:
        lines = f.readlines()
        for line in lines:
            if not "=" in line:
                continue
            
            line = line.strip()    
            # Matched strings like 'key = "value"' or 'key = [[value]]'
            match = re.match(r'(\w+?) = ("|\[\[)(.+?)("|\]\]),?', line)

            if match == None:
                continue
            
            values.append(line)
    
    print(f"Matched {len(values)} values in '{language_file_path}'.")
    return values
   
    
def extract_characters_used_by_language(language_values, min_codepoint, excluded_characters):
    """
    Takes as argument a collection of values in a language file and returns the used characters, excluding 
    characters strictly below `min_codepoint` and `excluded_characters`
    """
    used_characters = set()
    for value in language_values:
        for character in value:
            if (ord(character) >= min_codepoint) and (character not in excluded_characters):
                used_characters.add(character) 
    
    return used_characters


def extract_characters(font_path, min_codepoint=0):
    """
    Extracts all characters supported by the font, excluding those below a given code point.
    """
    font = TTFont(font_path)
    cmap = font.getBestCmap()
    characters = [chr(code_point) for code_point in cmap.keys() if code_point >= min_codepoint]
    return characters


def create_image(font_path, characters, output_image, font_size=48, appended_images=[]):
    """
    Creates a rectangular PNG image with all characters and appended images.
    Each element is separated by a 1px vertical line.
    """
    font = ImageFont.truetype(font_path, size=font_size)

    char_widths = [font.getbbox(char)[2] for char in characters]

    total_chars = len(characters)
    
    # Calculate text section width
    max_width = sum(char_widths) + len(char_widths) + 1 
    total_height = output_height

    # Pre-load appended images and calculate their scaled widths to match total_height
    loaded_imgs = []
    for img_path in appended_images:
        img = Image.open(img_path).convert("RGBA")
        aspect_ratio = img.width / img.height
        new_width = int(total_height * aspect_ratio)
        img = img.resize((new_width, total_height), Image.Resampling.LANCZOS)
        loaded_imgs.append(img)
        max_width += new_width # Add image width + separator line

    image = Image.new("RGBA", (max_width, total_height), background_color)
    draw = ImageDraw.Draw(image)
    
    x_offset, y_offset = 0, 0
    # Draw characters
    for i, char in enumerate(characters):
        draw.line([(x_offset, y_offset), (x_offset, y_offset + total_height)], fill=separator_color, width=1)
        x_offset += 1  

        draw.text((x_offset, y_offset + font_offset_y), char, font=font, fill=text_color)
        x_offset += font.getbbox(char)[2]

    # Draw appended images
    for img in loaded_imgs:
        image.paste(img, (x_offset, 0), img)
        x_offset += img.width

    # Draw closing line 
    # draw.line([(x_offset, y_offset), (x_offset, y_offset + total_height)], fill=separator_color, width=1)
    # x_offset += 1  

    image.save(output_image)
    print(f"Image saved as {output_image}")

def save_characters_to_file(characters: list[str], output_file: str, output_format: str):
    """
    Saves the list of characters to a text file.
    """
    with open(output_file, "w", encoding="utf-8") as f:
        all_characters = "".join(characters)
        f.write(output_format.format(all_characters))
    print(f"Characters saved to {output_file}")


# Execution
characters_used = set()
font_characters: list[str] = extract_characters(font_path, min_codepoint)
if language_file_path:
    language_file_values: list[str]  = extract_language_file_values(language_file_path)
    characters_used = extract_characters_used_by_language(language_file_values, min_codepoint, excluded_characters)
else:
    characters_used = font_characters

if len(characters_used) == 0:
    print("ERROR: no characters are used. Did you exclude too many characters?")
    exit()

used_characters_present_in_font: list[str] = list(set(font_characters).intersection(characters_used))
used_characters_present_in_font.sort()
print(f"Found {len(characters_used)} used characters")
print(f"Found {len(used_characters_present_in_font)} used characters compatible with font: {used_characters_present_in_font}")

save_characters_to_file(used_characters_present_in_font, os.path.join(output_folder, output_text), output_format)
create_image(font_path, used_characters_present_in_font, os.path.join(output_folder, output_image), font_size, appended_images)
