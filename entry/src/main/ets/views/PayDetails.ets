/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-16 14:53:07. All Rights Reserved.
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
import { FontSizes } from '../common/CommonStyles'
import { InputWidget } from '../components/Input'
import { CommonTitle } from '../components/TitleComponent'

@CustomDialog
export struct PayDetails{
  controller : CustomDialogController
  getCardOptions(){
    return [{value: '工商银行'}]
  }
  build(){
    Flex({direction: FlexDirection.Column, alignItems:ItemAlign.Center}){
      Text('付款给').fontSize(FontSizes.Third).padding(16).textAlign(TextAlign.Center)
        .width('100%').border({width:{bottom:1}, color: $r('app.color.background_fourth')})
      /**
       * 收款方
       */
      Column(){
        Image($r('app.media.person_crop_circle_fill_1'))
          .width(48).height(48)
        Text('xx公司').fontSize(FontSizes.Normal)
        Text('年度会员').fontSize(FontSizes.Normal)
      }.width(192).height(96).padding(8).margin(8)
      .justifyContent(FlexAlign.End)
      .borderRadius(16)
      .shadow({radius: 36,color: $r('app.color.background_secondary')})

      CommonTitle({title: $r('app.string.pay_account'),
        fontWeight: FontWeight.Bold,
        fontSize:FontSizes.Third,
        alignWay: FlexAlign.Start,
        topMargin: 16,
        bottomMargin: 8}).width(320)
      /**
       * 银行卡选择
       */
      Row(){
        Image($r('app.media.card_bacground')).width(36).height(24)
        .borderRadius(4).margin(8)

        Select(this.getCardOptions())
          .selected(1)
          .value( '工商银行').font({size: FontSizes.Normal})
          .selectedOptionFont({size: FontSizes.Normal})
          .optionFont({size: FontSizes.Normal})

      }.width(296).height(64).padding(8).margin(8)
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius(16)
      .shadow({radius: 36,color: $r('app.color.background_secondary')})

      CommonTitle({title: $r('app.string.pay_amount'),
        fontWeight: FontWeight.Bold,
        fontSize:FontSizes.Third,
        alignWay: FlexAlign.Start,
        topMargin: 16,
        bottomMargin: 8}).width(320)
      /**
       * 金额
       */
      Text('￥200').fontSize(FontSizes.Third)
        .width('100%').textAlign(TextAlign.Center)
      //输入框
      InputWidget({title: $r('app.string.owner_name')}).margin({top: 8})
      InputWidget({title: $r('app.string.edit_my_page_phoneNumber')}).margin({top: 8})
      Button($r('app.string.edit_page_confirm'))
        .width(120).height(36).margin({ top: 16, bottom: 16 })
        .backgroundColor($r('app.color.theme_red'))
    }.width('100%').height('100%').backgroundColor($r('app.color.white'))
    .margin({top: 80}).borderRadius({topLeft: 24,topRight: 24})
  }
}