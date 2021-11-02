filter='{
    items: .items | map({
        arg: (.metadata.name + " --namespace=" + .metadata.namespace) ,
        title: ("[" + .metadata.namespace + "] " + .metadata.name),
        subtitle: [
            .status.numberAvailable, " Available ",
            .status.numberReady, " Ready ",
            .status.currentNumberScheduled, " Scheduled"
        ] | join("")
    })
}'

server=$(cat $HOME/.kube/${cluster}/server.host)

curl -q -s -k --cert $HOME/.kube/$cluster/client.cert --key $HOME/.kube/$cluster/client.key $server$url | jq "$filter"
