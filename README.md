
## 加密货币版本请切换到coin分支
后续会统一为一个版本

[<img src="./assets/logo.png" width="180" />]()

[![github](https://img.shields.io/badge/github-byrnexu-brightgreen.svg)](https://github.com/byrnexu)  ![visitors](https://visitor-badge.laobi.icu/badge?page_id=byrnexu.betterquant)  [![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.svg?v=102)](https://github.com/byrnexu)

**Better quant today, best quant tomorrow.** 💪  

欢迎fork/star，你的支持是这个项目越来越好的最大动力，BetterQuant 沟通交流群 431100199 （加入前请star项目并提供github用户名）

**最近在外面看机会，上海地区私募机构需要技术总监/合伙人可以联系：byrnexu@gmail.com**   

## 进度和计划
* 开始接入国内二级市场，完成了A股现货第一个接口XTP的接入，完善了风控模块
* CTP接入 (进行中...)
* 文档补充 (进行中...)
&nbsp;

---

## 前言

&emsp;&emsp;目前接了现货XTP接口，所有柜台的仓位管理、盈亏计算、资产管理的算法及订单的状态维护的处理都是一样的，基于目前良好的行情和交易网关的接口，可以逐个快速接入。betterquant的主要功能和特点包括：<br/>
* 🔥 这是一个设计目标为支持多账户、多策略、多个产品、多托管主机并行的可水平扩展的分布式量化交易系统。<br/>
&nbsp;
* 🔥 支持c++和python两种语言编写交易策略，整个系统几个命令即可完成安装部署。<br/>
&nbsp;
* 🔥 目前的设计中只需要柜台或者交易所提供了委托回报和查询订单信息两个接口（实际理论上也只需要这两个接口），系统就可以帮你精确计算账户、策略、子策略等各个层面的pnl和手续费信息，系统崩溃后的各种信息的恢复，无视各种类型的交易所或者柜台接口，只需这两个接口即可。<br/>
&nbsp;
* 🔥🔥 强大的灾备功能，任何子系统崩溃，不会导致最终的数据异常‼️。交易服务崩溃，重启后会重建仓位和PNL信息，交易网关崩溃重启后会自动处理崩溃期间产生的未处理的订单状态变化，风控子系统崩溃后重启，同样会恢复各种风控指标。上述的恢复过程无需撤销任何未完结的订单。<br/>
&nbsp;
* 🔥 所有子系统，包括行情子系统、策略引擎、交易服务、交易网关、风控子系统都通过无锁共享内存交互❕。成功的消灭常规方案也就是子系统间通过tcp/domainsocket的百微秒级别的延时❕。用共享内存做子系统之间的ipc，使得系统兼具单进程的性能，同时也具备多进程的安全性，即任意系统crash不会导致其他子系统crash。当然虽然 目前子系统之间是通过共享内存交互的，但这并不是一个单机版的交易系统❕，后续会通过web服务提供restful和websocket接口，接受远端报单、回报和其他业务功能。<br/>
&nbsp;
* 🔥 内置web服务，可以通过web服务的restful接口查询历史行情，也可以通过web服务向指定策略发起人工干预指令‼️。<br/>
&nbsp;
* 🔥 每个子系统有自己独立的PUB_CHANNEL，你可以往自己的PUB_CHANNEL发布TOPIC，比如行情子系统可以发布新合约上线、合约参数的变化情况、风控子系统可以定制自己的风控指标，发布到风控子系统的PUB_CHANNEL，每个子系统可以通过系统的统一的格式订阅和发布自己感兴趣的TOPIC‼️。<br/>
&nbsp;
* 🔥 账户、策略、子策略、用户等各个层面独立的仓位和订单管理功能。<br/>
&nbsp;
* 🔥 很多系统收到报单后会针对订单做事前风控的处理，这个环节成为了这些系统的瓶颈所在，系统默认对收到的订单按照账户+市场+代码的维度做了分流，实现了无锁并行的风控处理，使得这个环节变得畅通无阻✈️，也可以通过修改编译参数来控制订单的分流粒度。<br/>
&nbsp;
* 🔥🔥 强大的事前事中风控模块，你可以根据表达式自定义风控指标，比如通过acctId=10000&marketCode=SZSE&symbolCode=00002&side=Bid限制每秒SZSE市场00002买入数量、特定时间间隔内的买入数量、买入金额、买入笔数等等各种风控指标。<br/>
&nbsp;
* 🔥🔥 插件式的风控指标管理🔌，可以根据系统统一的格式撰写动态链接库形式的风控指标，在交易系统运行中你可以启用、禁用或者升级这些风控插件‼️，从而实现风控指标的动态管理，满足一些市场7\*24小时交易需要，开放式的api接口使得你可以在风控指标接口里得到你任何想要的数据，通过这些数据结合自己的需求定制灵活多样化的风控指标。<br/>
&nbsp;
* 🔥🔥 强大的pnl实时监控功能‼️，你可以在任何子系统（比如策略端）实时订阅并监控账户、策略、子策略、用户、市场、标的、多头头寸、空头头寸等每个维度的已实现盈亏、未实现盈亏（浮动盈亏）、手续费使用情况，或者说任意维度组合的已实现盈亏、未实现盈亏（浮动盈亏）、手续费使用情况‼️<br/>
&nbsp;
* 🔥 系统外状态码动态维护功能，由于交易系统可能会接入多个交易所/交易柜台，每个外部交易服务都有自己特定的状态码，策略执行过程中也会收到未知的外部状态，系统在收到这些外部状态之后会自动收录，你可以在运行期间将其映射到指定的内部状态码，由此策略端就能够正确的处理新的状态码的业务逻辑。整个过程无需重启任何子系统❕。<br/>
&nbsp;
* 🔥 每一个策略可以指定若干套参数的子策略，子策略集合由一个线程池管理，子策略的参数可以在运行期间修改并自动更新，也可以在运行中增加或者禁用子策略❕。这一点对于一些7\*24小时交易的市场尤为重要。<br/>
&nbsp;
* 🔥 历史行请的保存和回放，可以设定历史行情按照一定的倍速回放，比如100倍或者0.01倍的速度回放保存的历史行情。<br/>
&nbsp;
* 🔥 模拟成交，可以设定一个模拟订单最终状态为全成、部成或者废单等，结合上面的历史行情回放可以实现简单的回测功能。<br/>
&nbsp;
* 🔥 目前系统内延迟是10微秒这个量级（阿里云 Intel(R)cpu Xeon(R) Platinum 8369B CPU @ 2.70GHz），也就是行情进入系统开始计时、dispatch到convert线程转换为内部统一格式、发布到行情子系统的PUB_CHANNEL，策略收到行情将行情dispatch到订阅该行情的子策略，子策略发起报单，交易服务收到报单，经过最简单的风控（目前内置了流控插件），订单由交易服务发往交易网关，交易网关将订单转换为交易所的格式后发出后计时结束。当然在大cache的服务器上性能表现应该能够更好。<br/>  

---
## 目录
### 🛠 [编译](doc/build_cn.md)
### 🐋 [安装](doc/installation_cn.md)
### ⭐ [文档](doc/documentation_cn.md)
### 🧨 [注意](doc/caution_cn.md)
### ⁉️ [FAQ](doc/faq_cn.md)
### 🥔 [TODO](doc/todo_cn.md)

&nbsp;
---
&nbsp;
&nbsp;

<div align="center"> <img  src="https://github-readme-streak-stats.herokuapp.com?user=byrnexu&theme=onedark&date_format=M%20j%5B%2C%20Y%5D" /> </div>
