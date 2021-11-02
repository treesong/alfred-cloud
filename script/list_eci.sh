if [ -n "$region" ]; then
    OPTS="--RegionId=$region"
fi

filter='{
	variables: {
		total: .TotalCount, 
		pageSize: .PageSize, 
		pageIndex: .PageNumber
	}, 
	items: .ContainerGroups | map({
		arg: .ContainerGroupId, 
		title: (.ContainerGroupName + " - (" + .Status + ")"),
		subtitle: [ .Cpu, "C", .Memory, "G / Events:", (.Events|length)] | join(""),
		mods: {
			alt: {
				subtitle: (.InternetIp + "/" + .IntranetIp)
			},
			cmd: {
				subtitle: .ContainerGroupId
			}
		}
	})
}'

add_pagable='.items += [{
	valid: (.variables.pageIndex * .variables.pageSize < .variables.total), 
	match: ">>", 
	arg: "",
	icon: {path: "forward.png"},
	title: ["Page Next: [", .variables.pageIndex * .variables.pageSize + 1, " ~ ", (.variables.pageIndex + 1) * .variables.pageSize, "] / Total: ", .variables.total] | join(""),
	variables: {
		pageIndex: (.variables.pageIndex + 1)
	}
}]'

aliyun eci DescribeContainerGroups $OPTS | jq "$filter"
