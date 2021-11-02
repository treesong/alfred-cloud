mkdir -p $HOME/.kube/${cluster}

if ! [ -f $HOME/.kube/${cluster}/config ]; then
   aliyun cs DescribeClusterV2UserKubeconfig --ClusterId=${cluster} | jq -r .config > $HOME/.kube/${cluster}/config
fi

if ! [ -f $HOME/.kube/${cluster}/server.host ]; then
    cat $HOME/.kube/${cluster}/config | grep "server:" | xargs | cut -d' ' -f2 | xargs > $HOME/.kube/${cluster}/server.host
fi

if ! [ -f $HOME/.kube/${cluster}/server.cert ]; then
    cat $HOME/.kube/${cluster}/config | grep certificate-authority-data | cut -d':' -f2 | xargs | base64 -d > $HOME/.kube/${cluster}/server.cert
fi

if ! [ -f $HOME/.kube/${cluster}/client.cert ]; then
    cat $HOME/.kube/${cluster}/config | grep client-certificate-data | cut -d':' -f2 | xargs | base64 -d > $HOME/.kube/${cluster}/client.cert
fi

if ! [ -f $HOME/.kube/${cluster}/client.key ]; then
    cat $HOME/.kube/${cluster}/config | grep client-key-data | cut -d':' -f2 | xargs | base64 -d > $HOME/.kube/${cluster}/client.key
fi
