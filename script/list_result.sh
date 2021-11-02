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

if [ -n "$taskId" ]; then
    OPTS="$OPTS --InvokeId=${taskId}"
fi

if [ -n "$vmId" ]; then
    OPTS="$OPTS --InstanceId=${vmId}"
fi

# OPTS="$OPTS --IncludeOutput=true"
OPTS="$OPTS --ContentEncoding=PlainText"

# if [ -n "${vmId}" ]; then
# 	OPTS="$OPTS --InstanceId=${vmId}";
# fi;

filter='{
	variables: {
		total: .TotalCount, 
		pageSize: .PageSize, 
		pageIndex: .PageNumber
	},
	rerun: ((.Invocation.InvocationResults.InvocationResult[0].InvocationStatus // "Pending") | test("Pending|Running")),
	items: .Invocation.InvocationResults.InvocationResult | map({
		arg: .InstanceId, 
		title: (.InstanceId + "(" + .InvocationStatus + ")"), 
		subtitle: .Output, 
		icon: {
			path: ("./icon/task/" + .InvocationStatus + ".png")
		},
		text: {
			largetype: .Output
		}, 
		mods: {
			alt: {
				subtitle: (.FinishTime + "/" + .ErrorCode)
			},
			cmd: {
				arg: .InvokeId,
				subtitle: .InvokeId
			}
		}
	})
}'

add_backward='.items += [{
	match: "<<", 
	arg: "<<",
	icon: {
		path: "./icon/menu/backward.png"
	},
	title: "GOTO: [ 任务列表 ]",
}]'

aliyun ecs DescribeInvocationResults $OPTS | jq "${filter} | ${add_backward}"
