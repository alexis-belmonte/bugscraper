#!/bin/bash
set -euo pipefail

# Script to apply tag-based patches to source files
# Usage: ./patch_tags.sh "tag1,tag2,tag3"

TAGS_INPUT="${1:-}"

if [[ -z "$TAGS_INPUT" ]]; then
    echo "::notice title=Patch Application::No tags provided, skipping patch application"
    exit 0
fi

# Parse tags into array (split by comma)
IFS=',' read -ra TAGS <<< "$TAGS_INPUT"
# Trim whitespace from each tag
TAGS=("${TAGS[@]/#/}")
TAGS=("${TAGS[@]%/}")

# Remove empty tags
TAGS=("${TAGS[@]}" )

if [[ ${#TAGS[@]} -eq 0 ]] || [[ -z "${TAGS[0]:-}" ]]; then
    echo "::notice title=Patch Application::No valid tags provided, skipping patch application"
    exit 0
fi

echo "::notice title=Patch Application::Processing tags: ${TAGS[*]}"

# Find all files matching pattern: <name>.<tag>.<type>.<ext>
# Store them in associative arrays indexed by original file path
declare -A PATCH_APPEND
declare -A PATCH_REPLACE

while IFS= read -r -d '' FILE; do
    # Extract components from filename: name.tag.type.ext
    file_basename="${FILE##*/}"
    
    # Match pattern: <name>.<tag>.<type>.<ext>
    if [[ "$file_basename" =~ ^(.+)\.([^.]+)\.(a|r)\.(.+)$ ]]; then
        original_name="${BASH_REMATCH[1]}"
        tag="${BASH_REMATCH[2]}"
        type="${BASH_REMATCH[3]}"
        extension="${BASH_REMATCH[4]}"
        
        # Reconstruct the expected original file path
        dir_path="$(dirname "$FILE")"
        original_file="$dir_path/$original_name.$extension"
        
        patch_key="$original_file:$tag"
        
        if [[ "$type" == "a" ]]; then
            PATCH_APPEND["$patch_key"]="$FILE"
        elif [[ "$type" == "r" ]]; then
            PATCH_REPLACE["$patch_key"]="$FILE"
        fi
    fi
done < <(find . -type f \( -name '*.a.*' -o -name '*.r.*' \) -print0 2>/dev/null)

# Check for conflicts (same original + same tag with both a and r)
for key in "${!PATCH_APPEND[@]}"; do
    if [[ -n "${PATCH_REPLACE[$key]:-}" ]]; then
        echo "::error title=Patch Application Error::Conflict detected: ${key} has both append (.a.) and replace (.r.) patches"
        exit 1
    fi
done

# Check that original files exist for all patches
for key in "${!PATCH_APPEND[@]}" "${!PATCH_REPLACE[@]}"; do
    original_file="${key%:*}"
    if [[ ! -f "$original_file" ]]; then
        echo "::error title=Patch Application Error::Original file not found: ${original_file} (patch exists but source missing)"
        exit 1
    fi
done

# Apply patches in tag order
for tag in "${TAGS[@]}"; do
    echo "::notice title=Patch Application::Applying tag: '${tag}'"
    
    # Process append patches for this tag
    for key in "${!PATCH_APPEND[@]}"; do
        if [[ "$key" == *":$tag" ]]; then
            original_file="${key%:*}"
            patch_file="${PATCH_APPEND[$key]}"
            
            echo "::notice title=Patch Application::APPEND: ${patch_file} → ${original_file}"
            cat "$patch_file" >> "$original_file"
            
            # Delete patch file
            rm -f "$patch_file"
        fi
    done
    
    # Process replace patches for this tag
    for key in "${!PATCH_REPLACE[@]}"; do
        if [[ "$key" == *":$tag" ]]; then
            original_file="${key%:*}"
            patch_file="${PATCH_REPLACE[$key]}"
            
            echo "::notice title=Patch Application::REPLACE: ${patch_file} → ${original_file}"
            cp -f "$patch_file" "$original_file"
            
            # Delete patch file
            rm -f "$patch_file"
        fi
    done
done

# Clean up any remaining suffix files (unused tags)
REMAINING_SUFFIXED=$(find . -type f \( -name '*.a.*' -o -name '*.r.*' \) 2>/dev/null | wc -l)
if [[ "$REMAINING_SUFFIXED" -gt 0 ]]; then
    echo "::warning title=Patch Application::${REMAINING_SUFFIXED} suffix files remain (unused tags):"
    find . -type f \( -name '*.a.*' -o -name '*.r.*' \) 2>/dev/null | head -10
fi

echo "::notice title=Patch Application::Patch application complete"
