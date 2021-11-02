if [ -n "$region" ]; then
    OPTS="$OPTS --RegionId=$region"
fi

if [ -n "$containerGroup" ]; then
    OPTS="$OPTS --ContainerGroupIds='[\"$containerGroup\"]'"
fi

filter='{
	items: .Containers | map({
		arg: .Name, 
		title: (.Name + " - (" + .CurrentState.State + ")"),
		subtitle: .Image,
		mods: {
			alt: {
		                subtitle: [.Cpu, "C", .Memory, "G"] | join(""),
			},
			cmd: {
				subtitle: .Name
			}
		}
	})
}'

eval aliyun eci DescribeContainerGroups $OPTS | jq ".ContainerGroups[0] | $filter"
