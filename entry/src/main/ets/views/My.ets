/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-15 20:52:39. All Rights Reserved.
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
import { CommonTitle } from '../components/TitleComponent'
import agconnect from '@hw-agconnect/api-ohos'
import { User } from '../models/userData'
import userModel from '../viewModels/UserViewmodel'
@Preview
@Component
export struct MyInfomation {
  @Link userInfo: User

  logout(){
    //退出登录，回到登录页面
    // @ts-ignore
    agconnect.auth().signOut()
    router.replaceUrl({url: 'pages/Login'})
  }
  build(){
    Column(){
      CommonTitle({
        title: $r('app.string.my_page_title'),
        topMargin: 24,
        bottomMargin: 16,
        fontWeight: FontWeight.Bold,
        fontSize: FontSizes.Second,
        alignWay: FlexAlign.Center
      })
      //个人信息栏
      Column(){
        Image($r('app.media.person_crop_circle_fill_1'))
          .width(96).height(96)
        Text('示例').fontSize(FontSizes.Normal)
        Text(this.userInfo.email).fontSize(FontSizes.Normal)
      }.width(256).margin({top: 24,bottom: 24})

      Flex({alignItems:ItemAlign.Center,justifyContent:FlexAlign.SpaceBetween}){
        Image($r('app.media.square_and_pencil')).height(36).width(36)
        Text('编辑个人信息')
        Image($r('app.media.chevron_right')).height(36).width(18)
          .onClick(()=>{
            /**
             * 跳转到编辑页面
             */
            router.pushUrl({url: 'pages/EditPersonPage'})
          })
      }.margin({bottom:24}).padding(8)

      Flex({alignItems:ItemAlign.Center,justifyContent:FlexAlign.SpaceBetween}){
        Image($r('app.media.square_and_pencil')).height(36).width(36)
        Text('个人二维码')
        Image($r('app.media.chevron_right')).height(36).width(18)
          .onClick(()=>{
            router.pushUrl({url: 'pages/QRcodeGeneratePage'})
          })
      }.margin({bottom:24}).padding(8)

      Button($r('app.string.my_page_unsignin')).width(120).height(36)
        .backgroundColor($r('app.color.theme_red'))
        .onClick(()=>{
          this.logout()
        })
    }.width(348).height('100%').justifyContent(FlexAlign.Start)
  }
}