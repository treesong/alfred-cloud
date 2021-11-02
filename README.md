# alfred-cloud

Alfred 工作流，用于快速连接 Aliyun ECS/ECI/ACK 实例/容器；

## 准备工作：
1. 需要安装&配置 Aliyun CLI <https://help.aliyun.com/document_detail/121544.html> 
2. 需要安装 JQ <https://stedolan.github.io/jq/>
3. 需要安装 kubectl, 如果需要连接ECI 容器
4. 需要安装&配置 Aliyun ECI CLI, 如果需要连接ECI 容器

## 使用演示

### 连接 ECS 实例

![connect-ecs.gif](https://raw.githubusercontent.com/treesong/alfred-cloud/main/gif/connect-ecs.gif)

> 演示中的输入：
> - ls ecs hangz [回车] // ecs hangzhou 地域
> - pre [回车] // 查找名称带 pre 的实例
> - ssh [回车] // 执行 Open SSH 功能


### 免登录 ECS，执行脚本

![run-command.gif](https://raw.githubusercontent.com/treesong/alfred-cloud/main/gif/run-command.gif)


> 演示中的输入：
> - ls ecs hangz [回车] // ecs hangzhou 地域
> - daily [回车] // 查找名称带 daily 的实例
> - sh [回车] // 执行 Run Shell Script 功能
> - lsb_releae -a [TAB] [回车] // 执行此脚本
> - 等待脚本执行完成，Command+L 查看输入

### 连接 ACK Pod

> 需要已安装 kubectl

![connect-ack-pod.gif](https://raw.githubusercontent.com/treesong/alfred-cloud/main/gif/connect-ack-pod.gif)


### 连接 ECI 容器

> 需要已安装 aliyun eci cli

![connect-eci-pod.gif](https://raw.githubusercontent.com/treesong/alfred-cloud/main/gif/connect-eci-pod.gif)


### 切换 Aliyun Profile

![switch-profile.gif](https://raw.githubusercontent.com/treesong/alfred-cloud/main/gif/switch-profile.gif)


### 打包为 alfredworkflow

```shell
```
