/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-14 18:38:19. All Rights Reserved.
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
import { BusinessCardButton } from '../components/BusinessCard'
import { CommonTitle } from '../components/TitleComponent'
import { Card } from '../models/CardModel'
import { BankCard } from './BankCard'
import { TransactionCard } from './TransactionInfomation'

@Component
export struct Home {
  @State arr: Array<number> = [1, 2, 3, 4, 5, 6, 7, 8, 9]
  @Link cards: Card[]
  build() {
    Scroll(){
      Flex({ wrap: FlexWrap.Wrap,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center }) {
        Column() {
          /**
           * 1.标题
           */
          CommonTitle({
            title: $r('app.string.main_page'),
            topMargin: 24,
            bottomMargin: 16,
            fontWeight: FontWeight.Bold,
            fontSize: FontSizes.Second,
            alignWay: FlexAlign.Center
          })
          CommonTitle({
            title: $r('app.string.main_page_welcom'),
            topMargin: 16,
            bottomMargin: 8,
            fontWeight: FontWeight.Regular,
            fontSize: FontSizes.Third,
            alignWay: FlexAlign.Start
          })
          /**
           * 2.银行卡组件
           */
          Swiper() {
            if(this.cards && this.cards.length){
              ForEach(this.cards,(item)=>{
                BankCard({
                  bankName: item.bank,
                  balance: item.amount,
                  bankCardNumber: item.cardNumber
                })
              })
            }
            else {
              BankCard()
            }
          }.loop(true)
          .indicatorStyle({
            size: 8,
            color: $r('app.color.white'),
            selectedColor: $r('app.color.white')
          }).margin({ top: 8, bottom: 8 })
          /**
           * 3.功能分类
           */
          CommonTitle({
            title: $r('app.string.main_page_function_title'),
            topMargin: 24,
            bottomMargin: 8,
            fontWeight: FontWeight.Regular,
            fontSize: FontSizes.Third,
            alignWay: FlexAlign.Start
          })
          Flex() {
            BusinessCardButton({ name: '转账' })
              .onClick(()=> {
                router.pushUrl({url: 'pages/PayPage',
                params:{
                  //收款人id
                  payeeId: '1469625907781088064'
                }})
              })
            BusinessCardButton({ name: '收款' })
            BusinessCardButton({ name: '账单' })
          }
        }.width(348)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)

        /**
         * 4.交易信息
         */
        Column(){
          CommonTitle({
            title: $r('app.string.main_page_transaction_title'),
            topMargin: 16,
            bottomMargin: 8,
            fontWeight: FontWeight.Regular,
            fontSize:FontSizes.Third,
            alignWay: FlexAlign.Start
          })
          List({ space: 12 }) {
            ForEach(this.arr, (item: string) => {
              ListItem() {
                TransactionCard()
              }
            }, (item: string) => item)
          }.layoutWeight(1)
        }.width(348).height('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Center)
      }.width('100%')
    }.scrollBar(BarState.Off)
  }
}
