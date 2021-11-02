items='[
    {
        uid: "QuickLook",
        arg: "QuickLook",
        title: "QuickLook",
        subtitle: "QuickLook",
        icon: {
            path: "./icon/api/ShowDetails.png"
        }
    },
    {
        uid: "DescribeInvocations",
        arg: "DescribeInvocations",
        title: "Describe Invocations",
        subtitle: "DescribeInvocations",
        icon: {
            path: "./icon/api/RunCommand.png"
        }
    }
]';

if [ "${status}" == "Running" ]; then
    menu='[{
        uid: "StopInstance",
        arg: "StopInstance",
        title: "Stop Instance",
        subtitle: "StopInstance",
        icon: {
            path: "./icon/api/StopInstance.png"
        }
    },{
        uid: "RebootInstance",
        arg: "RebootInstance",
        title: "RebootInstance",
        subtitle: "RebootInstance",
        icon: {
            path: "./icon/api/RebootInstance.png"
        }
    },{
        uid: "GetInstanceConsoleOutput",
        arg: "GetInstanceConsoleOutput",
        title: "Instance ConsoleOutput",
        subtitle: "GetInstanceConsoleOutput",
        icon: {
            path: "./icon/api/GetInstanceConsoleOutput.png"
        }
    }]';
    items="$items | . += ${menu}";

    if [ "${osType}" == "linux" ]; then
        menu='[{
            uid: "OpenSSHConnection",
            arg: "OpenSSHConnection",
            title: "Open SSH Connection",
            subtitle: "ssh root@",
            icon: {
                path: "./icon/api/RunCommand.png"
            }
        },{
            uid: "RunShellScript",
            arg: "RunShellScript",
            title: "Run Shell Script",
            subtitle: "RunShellScript",
            icon: {
                path: "./icon/api/RunCommand.png"
            }
        }]';
        items="$items | . += ${menu}";
    else
        menu='[{
            uid: "RunBatScript",
            arg: "RunBatScript",
            title: "Run Bat Script",
            subtitle: "RunBatScript",
            icon: {
                path: "./icon/api/RunCommand.png"
            }
        }, {
            uid: "RunPowerShellScript",
            arg: "RunPowerShellScript",
            title: "Run PowerShell Script",
            subtitle: "RunPowerShellScript",
            icon: {
                path: "./icon/api/RunCommand.png"
            }
        }]';
        items="$items | . += ${menu}";
    fi;
elif [ "$status" == "Stopped" ]; then
    menu='[{
        uid: "StartInstance",
        arg: "StartInstance",
        title: "Start Instance",
        subtitle: "StartInstance",
        icon: {
            path: "./icon/api/StartInstance.png"
        }
    }]';
    items="$items | . += ${menu}";
fi

add_title=".[].subtitle += \" (${vmId})\""

add_vmInfo=".[] += {
    mods: {
        cmd: {
            subtitle: \"${vmId}\"
        },
        alt: {
            subtitle: \"${vmName}\"
        }, 
        ctrl: {
            subtitle: \"${internetIp}\"
        }
    }
}"

add_backward=". += [{
	match: \"<<\", 
	arg: \"<<\",
	icon: {
		path: \"./icon/menu/backward.png\"
	},
	title: (\"GOTO: ${region}\")
}]"

echo '{}' | jq "${items} | ${add_title} | ${add_vmInfo} | ${add_backward} | {items: .}"