# FinacingExample
鸿蒙理财APP练习实战，API版本为9
src/main/ets的目录结构如下：
├─common
│      CommonStyles.ts
│
├─components
│      BusinessCard.ets
│      Input.ets
│      TitleComponent.ets
│
├─entryability
│      EntryAbility.ts
│
├─models
│      CardModel.ts
│      userData.ts
│
├─pages
│      AddCardPage.ets
│      EditPersonPage.ets
│      Login.ets
│      MainPage.ets
│      PayPage.ets
│      QRcodeGeneratePage.ets
│
├─services
│      CloudServices.ts
│
├─viewModels
│      CardViewmodel.ets
│      UserViewmodel.ets
│
└─views
       BankCard.ets
       Home.ets
       My.ets
       PayDetails.ets
       Statistic.ets
       TransactionInfomation.ets
       Wallet.ets


common存放一些全局公共样式，如字体大小；components存放可复用的组件；models是MVVM模式中定义的数据模型类；
pages是软件的各个页面，如登录页Login.ets，主页MainPage.ets；
services是云函数相关的服务；
viewModels是MVVM模式中的视图模型类，用于操作数据；
views是主页及其他页面中相对独立的子视图，例如：
主页中包含底部的tab栏和首页、统计、钱包、我的四大部分，分别对应4个view