if [ -n "$region" ]; then
    OPTS="--RegionId=$region"
fi

if [ -z "$pageSize" ]; then
    pageSize=10
fi

if [ -z "$pageIndex" ]; then
    pageIndex=1
fi

OPTS="$OPTS --PageSize=${pageSize}"
OPTS="$OPTS --PageNumber=${pageIndex}"

if [ "" != "${vmId}" ]; then
	OPTS="$OPTS --InstanceId=${vmId}"
fi;

filter='{
	variables: {
		total: .TotalCount, 
		pageSize: .PageSize, 
		pageIndex: .PageNumber
	}, 
	items: .Disks.Disk | map({
		uid: .DiskId, 
		arg: .DiskId, 
		title: [ .Device, "(", .Category, "|", .Size, "GB)" ] | join(""),
		subtitle: .CreationTime,
		icon: {path: ("./icon/product/disk.png")},
		text: { largetype: .}, 
		mods: { 
			cmd: { subtitle: .DiskId}
		}
	})
}'

add_pagable='.items += [{
	valid: (.variables.pageIndex * .variables.pageSize < .variables.total), 
	match: ">>", 
	arg: ">>",
	icon: {path: "./icon/menu/forward.png"},
	title: ["Page Next: [", .variables.pageIndex * .variables.pageSize + 1, " ~ ", (.variables.pageIndex + 1) * .variables.pageSize, "] / Total: ", .variables.total] | join(""),
	variables: {
		pageIndex: (.variables.pageIndex + 1)
	}
}]'

add_backward=".items += [{
	match: \"<<\", 
	arg: \"<<\",
	icon: {
		path: \"./icon/menu/backward.png\"
	},
	title: (\"GOTO: ${vmId}\")
}]"

aliyun ecs DescribeDisks $OPTS | jq "$filter | $add_pagable | $add_backward"