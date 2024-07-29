# requires moreutils and ripgrep


for i in 1 2
    for regex in (list '^(\s*(\S.*?)\h+:=.*?\h)\2(\h.*?;)' \
                       '^(\s*(\S.*?)\h+:=.*?\h)\2(\..*?;)' \
                       '^(\s*(\S.*?)\h+:=.*?\()\2(\h.*?;)' \
                       '^(\s*(\S.*?)\h+:=.*?\()\2(\..*?;)')
        for file in (rg -P --multiline $regex -l)
            rg -P --multiline $regex -r '$1@$3' "$file" -N --passthru | sponge "$file"
        end
    end
end
