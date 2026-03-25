build_directory=$1
version=$2

if [[ ! "${CI}" ]]; then
    mkdir -p /mnt/c/docs/gamedev/steam_sdk/tools/ContentBuilder/content/bugscraper/$version/win64
    mkdir -p /mnt/c/docs/gamedev/steam_sdk/tools/ContentBuilder/content/bugscraper/$version/macos

    unzip -o "$build_directory/win64/bugscraper-win64.zip" -d /mnt/c/docs/gamedev/steam_sdk/tools/ContentBuilder/content/bugscraper/$version/win64
    unzip -o "$build_directory/macos/bugscraper-macos.zip" -d /mnt/c/docs/gamedev/steam_sdk/tools/ContentBuilder/content/bugscraper/$version/macos
fi
