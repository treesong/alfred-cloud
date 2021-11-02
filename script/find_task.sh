if [[ $1 == i-* ]]; then
    vmId=$1
    prefix=${vmId:0:5}
    line=`cat ${region_table} | grep " $prefix"`
    region=`echo $line | cut -d' ' -f1`
    project=`echo $line | cut -d' ' -f2`

    filter='{
        variables: {
            key: "$vmId", 
            region: "$region", 
            project: "$project"
        },
        items: . | map({
            uid: .taskId,
            arg: .taskId,
            title: (.taskId + "/" + .type + "/" + .errorCode),
            subtitle: (.instanceId + .time)
        })
    }'

    aliyunlog log get_log \
        --region-endpoint=$region.log.aliyuncs.com \
        --project=$project \
        --logstore=track-log \
        --query="key: task_status and param.instanceId: $vmId not type=Created not type=Kicked not type=Fetched not type=Running | select taskId, instanceId, type, errorCode, date_format(__time__, '%Y-%m-%d %H:%i:%s') as time order by __time__ desc"  \
        --from_time="48 hour ago" \
        --to_time=now | jq "${filter}"


elif [[ $1 == t-* ]]; then
	taskId=$1
	prefix=${taskId:2:3}
	line=`cat ${region_table} | grep " $prefix"`
    region=`echo $line | cut -d' ' -f1`
    project=`echo $line | cut -d' ' -f2`

    filter='{
        variables: {
            key: "$vmId", 
            region: "$region", 
            project: "$project"
        },
        items: . | map({
            uid: .instanceId,
            arg: .instanceId,
            title: (.taskId + "/" + .type + "/" + .errorCode),
            subtitle: (.instanceId + .time)
        })
    }'

	aliyunlog log get_log \
        --region-endpoint=$region.log.aliyuncs.com \
        --project=$project \
        --logstore=track-log \
        --query="key: task_status and param.taskId: $taskId | select select taskId, instanceId, type, errorCode, date_format(__time__, '%Y-%m-%d %H:%i:%s')) as subtitle order by __time__ desc"  \
        --from_time="48 hour ago" \
        --to_time=now | jq "${filter}"
fi
