
/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-15 17:24:09. All Rights Reserved.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * Neither the name of the developer nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 重新分发和使用源代码和二进制形式的代码，无论是否进行修改，都是允许的，只要满足以下条件：
 * 重新分发源代码时，必须保留上述版权通知、本条件列表以及以下免责声明。
 * 以二进制形式重新分发时，必须在分发时提供的文档或其他材料中复制上述版权通知、本条件列表以及以下免责声明。
 * 未经事先书面许可，不得使用开发者或贡献者的名称来认可或推广从本软件派生出来的产品。
 */
import router from '@ohos.router'
import { FontSizes } from '../common/CommonStyles'
import { InputWidget } from '../components/Input'
import { CommonTitle, FunctionTitleComponent } from '../components/TitleComponent'
import agconnect from '@hw-agconnect/api-ohos'
import { addBankCard } from '../services/CloudServices'
import Notification from '@system.notification'
@Entry
@Component
struct AddCardPage {
  payload = {
    uuid: '',
    expiredAt: '',
    bank: '',
    name: '',
    cardNumber: '',
    ccv: ''
  }
  build() {
    Flex({ wrap: FlexWrap.Wrap,
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center }){
      //标题栏
      FunctionTitleComponent({ title: $r('app.string.add_card_page_title'),
        leftButton: $r('app.media.chevron_left'),
        leftFunc: ()=>{
          router.back()
        },
        fontWeight:FontWeight.Bold}).width(360)
      /**
       * 表单页面
       */
      Column(){
        //小标题
        CommonTitle({title: $r('app.string.card_infomation'),
          fontWeight: FontWeight.Bold,
          fontSize:FontSizes.Second,
          alignWay: FlexAlign.Start,
          topMargin: 16,
          bottomMargin: 8}).margin({left: 14})
        InputWidget({title: $r('app.string.card_belong_to'),
          change: (val: string)=>{
            this.payload.bank = val
          }})
        InputWidget({title: $r('app.string.bankCard_number'),
          change: (val: string)=>{
            this.payload.cardNumber = val
        }}).margin({top: 16})
        InputWidget({title: $r('app.string.owner_name'),
          change: (val: string)=>{
            this.payload.name = val
          }})
        .margin({top: 16,bottom: 16})
        Row(){
          InputWidget({title: $r('app.string.CCV'),widgetWidth: 148,
            change: (val: string)=>{
              this.payload.ccv = val
            }})
          InputWidget({title: $r('app.string.due_date'),widgetWidth: 148,
            change: (val: string)=>{
              this.payload.expiredAt = val
            }})
        }.width(320).justifyContent(FlexAlign.SpaceBetween).margin({bottom:16})
        Button($r('app.string.add_bankCard')).width(120).height(36)
          .backgroundColor($r('app.color.theme_red'))
          .onClick(async ()=>{
            try{
              //获取当前登录用户的信息
              const user = await agconnect.auth().getCurrentUser()
              if (!user){
                //未登录则跳到登录页面
                router.replaceUrl({url: 'pages/Login'})
                return
              }
              //添加当前用户uuid
              this.payload.uuid = user.getUid()
              //拿到卡片信息
              console.log(JSON.stringify(this.payload))
              //执行添加银行卡的操作
              const result = await addBankCard(this.payload)
              if(result.status){
                //提示成功，返回上一页
                Notification.show({
                  contentTitle:'添加成功'
                })
                setTimeout(()=>{
                  //延时1秒再返回上一页
                  router.back()
                },1000)
              }else {
                //提示失败
                Notification.show({
                  contentTitle:'添加失败'+result.errMsg
                })
              }
            }catch (error){
              console.error(error,'添加错误')
            }

          })
      }.width(348).margin({ top:16, bottom: 16 })
    }
  }
}