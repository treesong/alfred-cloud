if [ -n "$region" ]; then
    OPTS="--RegionId=$region"
fi

if [ -z "$pageSize" ]; then
    pageSize=10
fi

if [ -z "$pageIndex" ]; then
    pageIndex=1
fi

OPTS="$OPTS --page_size=${pageSize}"
OPTS="$OPTS --page_number=${pageIndex}"

filter='{
	variables: {
		total: .page_info.total_count, 
		pageSize: .page_info.page_size, 
		pageIndex: .page_info.page_number
	}, 
	items: .clusters | map({
		arg: .cluster_id, 
		title: (.name + "(" + .cluster_type + ") - " + .state),
		subtitle: (.region_id + "/" +.cluster_id),
		mods: {
			cmd: {
				subtitle: .cluster_id
			},
			alt: {
				subtitle: .cluster_spec
			}
		}
	})
}'

add_pagable='.items += [{
	valid: (.variables.pageIndex * .variables.pageSize < .variables.total), 
	match: ">>", 
	arg: "",
	icon: {path: "icon/menu/forward.png"},
	title: ["Page Next: [", .variables.pageIndex * .variables.pageSize + 1, " ~ ", (.variables.pageIndex + 1) * .variables.pageSize, "] / Total: ", .variables.total] | join(""),
	variables: {
		pageIndex: (.variables.pageIndex + 1)
	}
}]'

aliyun cs DescribeClustersV1 $OPTS | jq "$filter | $add_pagable"
