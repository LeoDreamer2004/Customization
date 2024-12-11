#!/bin/bash

key="$1"
map_path="./vscode-profiles-mapping.toml"

path=$(grep -E "^$key\s*=" $map_path | awk -F '=' '{print $2}' | xargs)

if [ -n "$path" ]; then
echo "Local config[$key] found at $path"
echo
cp $HOME$path ./settings.json 

grep -E "^\s*[^#]\w+\s*=" $map_path | grep -v -E "^\s*$key\s*=" | while IFS="=" read -r other_key other_path; do
cp ./settings.json $HOME$other_path
echo "Copied config[$key] to config[$other_key]"
done

git add *
git commit -am "Updated vscode profile $key"
git push

else
echo "Key '$key' not found in $map"
fi
