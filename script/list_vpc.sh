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

filter='{
	variables: {
		total: .TotalCount, 
		pageSize: .PageSize, 
		pageIndex: .PageNumber
	}, 
	items: .Vpcs.Vpc | map({
		arg: .VpcId, 
		title: [.VpcId, "(", .VpcName, ")"] | join(""),
		subtitle: .CidrBlock,
		mods: {
			cmd: {
				subtitle: .VpcId
			},
			alt: {
				subtitle: .CreationTime
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

aliyun vpc DescribeVpcs $OPTS | jq "$filter | $add_pagable"