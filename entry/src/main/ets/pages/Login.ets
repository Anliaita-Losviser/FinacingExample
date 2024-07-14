/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-13 13:18:45. All Rights Reserved.
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
import { InputWidget } from '../components/Input'
import { TitleComponent } from '../components/TitleComponent'


@Entry
@Component
struct Login {
  @State isRegister: boolean = false
  @State countDown: number = 60
  timer: number
  /**
   * 发送验证码
   */
  SendCode(){
    this.StartCountDown()
  }
  /**
   * 倒计时功能
   */
  StartCountDown(){
    this.timer = setInterval(()=>{
      this.countDown -= 1
      if(this.countDown === 0){
        this.countDown = 60
        clearInterval(this.timer)
      }
    }, 1000)
  }
  build() {
    Flex({ wrap: FlexWrap.Wrap,
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center }) {
      //标题栏
      TitleComponent({ title: $r('app.string.loginpage_title') }).width(360)
      //表单,列式布局
      Column() {
        //邮箱框
        InputWidget({ title: $r('app.string.loginpage_email_title'),
          icon: $r('app.media.envelope_fill') })
          .margin({ top: 8, bottom: 8 })
        //密码
        InputWidget({ title: $r('app.string.loginpage_password_title'),
          icon: $r('app.media.lock_fill'),
          inputType: InputType.Password })
          .margin({ top: 8, bottom: 8 })
        //验证码输入框
        if(this.isRegister)
        {
          Column() {
            Text($r('app.string.vertifyCode')).fontSize(24).fontWeight(FontWeight.Regular)
            Flex(){
              TextInput()
                .width(272).margin({ left: 8, right: 8})
                .backgroundColor($r('app.color.white'))
              Button(this.countDown === 60 ? $r('app.string.get_vertify_code'): `${this.countDown}s`)
                .onClick(()=>{
                  if(this.countDown === 60){
                    this.SendCode()
                  }
                })
            }.height(50).margin({ top: 8, bottom: 8 })
          }
        }
        Button($r('app.string.loginpage_title')).BottonStyle()
          .backgroundColor($r('app.color.theme_red'))
          .onClick(()=>{
            router.replaceUrl({url: 'pages/MainPage'})
          })
        Button(this.isRegister == false ? $r('app.string.signup') : $r('app.string.back'))
          .BottonStyle()
          .fontColor($r('app.color.black'))
          .backgroundColor($r('app.color.background_secondary'))
          .onClick(()=>{this.isRegister = !this.isRegister})
      }
      .backgroundColor($r('app.color.white')).borderRadius(16)
      .width(348).margin({ top:16, bottom: 16 })
    }
    .width('100%').height('100%').backgroundColor($r('app.color.background_secondary'))
  }

  @Styles BottonStyle(){.width(120).height(36).margin({ top: 8, bottom: 8 })}

}