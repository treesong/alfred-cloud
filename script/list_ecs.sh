query=$1
if [ "$query" != "$keyword" ]; then
    pageIndex=1;
fi

if [ -n "$region" ]; then
    OPTS="--RegionId=$region"
fi

if [ -n "$vpcId" ]; then
    OPTS="--VpcId=$vpcId"
fi

if [ -z "$pageSize" ]; then
    pageSize=10
fi

if [ -z "$pageIndex" ]; then
    pageIndex=1
fi

OPTS="$OPTS --PageSize=${pageSize}"
OPTS="$OPTS --PageNumber=${pageIndex}"


if [[ ${query} == i-* ]]; then
	OPTS="$OPTS --InstanceIds=[\"$query\"]"
elif [ "${query}" != "" ]; then
	OPTS="$OPTS --InstanceName=%$query%"
fi

filter='{
	variables: {
		total: .TotalCount, 
		pageSize: .PageSize, 
		pageIndex: .PageNumber
	},
	items: .Instances.Instance | map(.|{
		uid: .InstanceId,
		arg: .InstanceId,
		title: (.InstanceName + " - (" + .Status + ")"),
		subtitle: (if .InstanceNetworkType == "vpc" then
		                "vpc://" + .PublicIpAddress.IpAddress[0] + "/" + .VpcAttributes.PrivateIpAddress.IpAddress[0]
		           else 
				        "classic://" + .PublicIpAddress.IpAddress[0] + "/" + .InnerIpAddress.IpAddress[0]
				   end),
		icon: {
			path: ("./icon/os/" +[.OSNameEn|ascii_downcase|splits(" |_")][0] + ".png")
		},
		quicklookurl: ("http://qt.aliyun-inc.com/instance/vm/index?tab=1&vm=" + .InstanceId),

		mods: {
			ctrl: {
				subtitle: (.InstanceNetworkType + "/" + .InnerIpAddress.IpAddress[0] + "/" + .PublicIpAddress.IpAddress[0])
			}, 
			alt: {
				icon: (.Status|ascii_downcase + ".png"),
				subtitle: (.OSNameEn + "/" + .InstanceType + "/" + (.Cpu|tostring) + "核" + (.Memory/1024|tostring) + "G")
			}, 
			cmd: {
				subtitle: .InstanceId
			}, 

			shift: {}
		},
		variables: {
			status: .Status,
			osType: .OSType,
			vmName: .InstanceName,
			internetIp: .PublicIpAddress.IpAddress[0]
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

add_keyword=".variables += {keyword: \"${query}\"}"

aliyun ecs DescribeInstances ${OPTS} | jq "$filter | $add_pagable | $add_keyword"