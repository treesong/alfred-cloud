filter='{
	items: .Users.User | map({
		arg: .UserId, 
		title: (.UserName + "(" + .DisplayName + ")"),
		subtitle: .CreateDate, 
		mods: {
			cmd: {
				subtitle: .UserId
			}
		}
	})
}'

aliyun ram ListUsers | jq "$filter"