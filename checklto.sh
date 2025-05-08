#!/bin/bash

# Loop through each immediate subdirectory
for dir in */ ; do
    file="${dir}Cargo.toml"

    if [ -f "$file" ]; then
        echo "Processing existing $file"
        if grep -q 'lto *= *true' "$file"; then
            echo "  -> Replacing lto = true with lto = false"
            sed -i 's/lto *= *true/lto = false/' "$file"
        elif ! grep -q 'lto' "$file"; then
            if grep -q '\[profile.release\]' "$file"; then
                echo "  -> Appending lto = false under [profile.release]"
                sed -i '/\[profile.release\]/a lto = false' "$file"
            else
                echo "  -> Adding new [profile.release] section"
                echo -e "\n[profile.release]\nlto = false" >> "$file"
            fi
        fi
    else
        echo "Creating $file with lto = false"
        echo -e "[profile.release]\nlto = false" > "$file"
    fi
done
