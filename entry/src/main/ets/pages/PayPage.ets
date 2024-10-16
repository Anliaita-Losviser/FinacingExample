/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-16 14:46:34. All Rights Reserved.
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
import { FunctionTitleComponent } from '../components/TitleComponent'
import { Card } from '../models/CardModel'
import { PayDetails } from '../views/PayDetails'
import CardModel from '../viewModels/CardViewmodel'
import { onPay } from '../services/CloudServices'
import { User } from '../models/userData'
import UserModel from '../viewModels/UserViewmodel'

@Entry
@Component
struct PayPage {
  //弹窗
  dialogController = new CustomDialogController({
    builder: PayDetails({
      payeeId: $payeeId,
      payerCards: $cards,
      PayAmount: $PayAmount,
      onConfirm: async (amount)=>{
        console.log('查看')
        console.log(this.payerInfo.uuid)
        console.log(this.payeeId)
        await onPay({
          //传付款人的信息
          payer: this.payerInfo.uuid,
          payee: this.payeeId,
          amount,
        })
        setTimeout(()=>{
          router.back()
        },1000)
      }
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
  })
  //收款人id
  @State payeeId:string = ''
  //付款人（当前登录用户）信息
  @State payerInfo:User = new User()
  //付款人（当前登录用户）银行卡信息
  @State cards: Card[]=[]
  @State PayAmount: number = 20

  async onPageShow(){
    const params = router.getParams()
    this.payeeId = params['payeeId']
    try {
      CardModel.getCardList().then((data)=>{
        this.cards = data
        if (this.cards){
          console.log("获取付款人（当前登录用户）银行卡信息")
        }
      }).catch (error => {console.error(error)})
      UserModel.getUserInfo().then((data)=>{
        this.payerInfo = data
        if(this.payerInfo){
          console.log("获取付款人（当前登录用户）信息")
        }
      }).catch(error => {console.error(error)})
    }catch (error){
      console.error(error,'错误')
    }
    //显示页面打开弹窗
    this.dialogController.open()
  }

  build() {
    Flex({wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center}){
      FunctionTitleComponent({ title: $r('app.string.pay_page_title'),
        leftButton: $r('app.media.chevron_left'),
        leftFunc: ()=>{
          router.back()
        },
        fontWeight:FontWeight.Bold}).width(360)
    }.width('100%').height('100%')
  }
}