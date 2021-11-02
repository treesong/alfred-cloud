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

OPTS="$OPTS --IncludeOutput=true"
OPTS="$OPTS --ContentEncoding=PlainText"

if [ "" != "${vmId}" ]; then
	OPTS="$OPTS --InstanceId=${vmId}"
fi;

filter='{
	variables: {
		total: .TotalCount, 
		pageSize: .PageSize, 
		pageIndex: .PageNumber
	}, 
	items: .Invocations.Invocation | map({
		uid: .InvokeId, 
		arg: .InvokeId, 
		title: [ .CommandName, " (vm: ", (.InvokeInstances.InvokeInstance | length), ")" ] | join(""),
		subtitle: .CreationTime,
		icon: {
			path: ("./icon/task/" + .InvocationStatus + ".png")
		},
		text: { largetype: (.InvokeInstances.InvokeInstance | map(select(.InstanceId=="'${vmId}'"))[0].Output) },
		mods: { 
			ctrl: { subtitle: .CommandContent },
			alt: { subtitle: .InvocationStatus },
			cmd: { subtitle: .InvokeId },
		}
	})
}'

add_pagable='.items += [{
	valid: (.variables.pageIndex * .variables.pageSize < .variables.total), 
	match: ">>", 
	arg: ">>",
	icon: {
		path: "./icon/menu/forward.png"
	},
	title: [
		"Page Next: [", .variables.pageIndex * .variables.pageSize + 1, " ~ ", (.variables.pageIndex + 1) * .variables.pageSize, "] / Total: ", .variables.total
	] | join(""),
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

aliyun ecs DescribeInvocations $OPTS | jq "$filter | $add_pagable | $add_backward"