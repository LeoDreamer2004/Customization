#!/bin/bash

key="$1"
cur_path=$HOME"/Scripts/Personalize/vscode/"
map_path=$cur_path"vscode-profiles-mapping.toml"
local_settings=$cur_path"settings.json"

# find path in map
path=$(grep -E "^$key\s*=" $map_path | awk -F '=' '{print $2}' | xargs)
if [ -n "$path" ]; then
echo -e "Local \e[1m\e[92mconfig[$key]\e[0m found at $path"
cp $HOME$path $local_settings
echo -e "\e[1m\e[36mStart copying config to other profiles... \e[0m"

# copy to other profiles
grep -E "^\s*[^#]\w+\s*=" $map_path | grep -v -E "^\s*$key\s*=" | while IFS="=" read -r other_key other_path; do
cp $local_settings $HOME$other_path
echo -e "Copied \e[1m\e[92mconfig[$key]\e[0m to \e[1m\e[92mconfig[$other_key]\e[0m"
done

# commit changes to git
echo -e "Commit changes to git? \e[1m(y/n)\e[0m"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
echo -e "\e[1m\e[36mCommitting changes to git... \e[0m"
git -C $cur_path add * 
git -C $cur_path commit -am "Updated vscode profile $key"
git -C $cur_path push 
fi

echo -e "\e[1m\e[36mAll profiles are synchronized! \e[0m"

else
echo "Key '$key' not found in $map"
fi
