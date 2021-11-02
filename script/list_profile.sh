filter='. as $root | {
    variables: {
        current: .current,
    },
    items: .profiles | map (.|{
         uid: .name,
         arg: .name,
         title: .name,
         icon: {path: ("./icon/menu/" + (if $root.current == .name then "checked.png" else "unchecked.png" end))},
         subtitle: .access_key_id
    }) 
}'

/bin/cat /Users/ruiqi.zss/.aliyun/config.json | /usr/local/bin/jq "$filter"
