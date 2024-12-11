#!/bin/bash

key="$1"
map_path="./vscode-profiles-mapping.toml"

path=$(grep -E "^$key\s*=" $map_path | awk -F '=' '{print $2}' | xargs)


if [ -n "$path" ]; then
echo -e "Local \e[1m\e[92mconfig[$key]\e[0m found at $path"
cp $HOME$path ./settings.json 
echo -e "\e[1m\e[36mStart copying config to other profiles \e[0m"
grep -E "^\s*[^#]\w+\s*=" $map_path | grep -v -E "^\s*$key\s*=" | while IFS="=" read -r other_key other_path; do
cp ./settings.json $HOME$other_path
echo -e "Copied \e[1m\e[92mconfig[$key]\e[0m to \e[1m\e[92mconfig[$other_key]\e[0m"
done

echo -e "Commit changes to git? \e[1m\e[92m(y/n)\e[0m"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
echo "Committing changes to git"
git add *
git commit -am "Updated vscode profile $key"
git push
fi

echo -e "\e[1m\e[36mAll profiles are synchronized\e[0m"

else
echo "Key '$key' not found in $map"
fi
