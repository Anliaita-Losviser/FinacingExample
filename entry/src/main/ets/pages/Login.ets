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
import { FontSizes } from '../common/CommonStyles'
import { InputWidget } from '../components/Input'
import { FunctionTitleComponent } from '../components/TitleComponent'
import { EmailAuthProvider, VerifyCodeAction, VerifyCodeSettingBuilder, PhoneUserBuilder,
  PhoneAuthProvider, AGConnectAuth, AGConnectAuthCredentialProvider, EmailUserBuilder
} from "@hw-agconnect/auth-ohos"
import agconnect from '@hw-agconnect/api-ohos'
import { addUser } from '../services/CloudServices'

@Entry
@Component
struct Login {
  @State isRegister: boolean = false//是否是注册状态
  @State countDown: number = 120//倒计时，120秒
  timer: number
  @State email:string = '2927848634@qq.com'//邮箱信息
  @State passWord:string = 'abc123456'//密码，初始abc123456
  @State verifyCode:string = ''//验证码
  /**
   * 发送验证码
   */
  async SendCode(){
    this.StartCountDown()
    //发送邮箱验证码
    const verifyCodeSetting = new VerifyCodeSettingBuilder()
      .setAction(VerifyCodeAction.REGISTER_LOGIN)//验证码类型：注册或登录
      .setLang('zh_CN')
      .setSendInterval(120)
      .build()
    await agconnect.auth().requestEmailVerifyCode(this.email, verifyCodeSetting)
      .then(async verifyCodeResult => {
        //验证码申请成功
        console.log(JSON.stringify(verifyCodeResult),'验证码申请成功')
      }).catch(error => {
      //验证码申请失败
        console.log(JSON.stringify(error),'验证码申请失败')
    })
  }
  /**
   * 注册功能函数
   */
  Register(){
    /**
     * 通过检查邮箱、密码、验证码完成注册
     */
    //首先构造一个emailUser对象，设置其附带的邮箱、密码、验证码信息
    const emailUser = new EmailUserBuilder()
      .setEmail(this.email)
      .setPassword(this.passWord) //可以给用户设置初始密码。填写后后续可以用密码来登录
      .setVerifyCode(this.verifyCode)
      .build()
    //创建用户（华为认证层面）
    agconnect.auth().createEmailUser(emailUser)
      .then(async (result) => {
        //创建用户到云数据库
        const user = await agconnect.auth().getCurrentUser()
        const data = await addUser({
          uuid: user.getUid(),
          email: this.email
        })
        //跳转主页
        router.replaceUrl({url: 'pages/MainPage'})
        //创建帐号成功后，默认已登录
        console.log(JSON.stringify(result),'创建帐号成功')
      })
      .catch(error => {
        //创建用户失败
        console.log(JSON.stringify(error),'创建用户失败')
      })
  }
  /**
   * 登录功能函数
   */
  async DoLogin(){
    try {
      //使用邮箱密码登录
      const credential = EmailAuthProvider.credentialWithPassword(this.email,this.passWord)
      //执行登录
      const user = await agconnect.auth().signIn(credential)
      //判断用户是否存在
      if(user!= null){
        router.replaceUrl({url: 'pages/MainPage'})
      }
    }
    catch (error){
      console.error(error, '登录失败')
    }
  }
  /**
   * onPageShow里面判断用户是否登录
   */
  async CheckIfLogin(){
    const user = await agconnect.auth().getCurrentUser()
    return user != null
  }
  async onPageShow(){
    try {
      const isLogin = await this.CheckIfLogin()
      if(isLogin){
        router.replaceUrl({url: 'pages/MainPage'})
      }
    }
    catch (error){
      console.error(error, '未登录')
    }
  }
  /**
   * 定时器倒计时功能
   */
  StartCountDown(){
    this.timer = setInterval(()=>{
      this.countDown -= 1
      if(this.countDown === 0){
        this.countDown = 120
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
      FunctionTitleComponent({ title: $r('app.string.loginpage_title'),
        leftButton: $r('app.media.chevron_left'),
        fontWeight:FontWeight.Bold}).width(360)
      //表单,列式布局
      Column() {
        //邮箱框
        InputWidget({ title: $r('app.string.loginpage_email_title'),
          icon: $r('app.media.envelope_fill'),
          defaultValue: this.email,
          change: (val) => {
          this.email = val
        }})
          .margin({ top: 16, bottom: 16 })
        //密码
        InputWidget({ title: $r('app.string.loginpage_password_title'),
          icon: $r('app.media.lock_fill'),
          inputType: InputType.Password,
          defaultValue: this.passWord,
          change: (val) => {
            this.passWord = val
          }})
          .margin({ top: 16, bottom: 16 })
        //验证码输入框
        if(this.isRegister)
        {
          Column() {
            Text($r('app.string.vertifyCode')).fontSize(FontSizes.Third).fontWeight(FontWeight.Regular)
            Flex(){
              TextInput()
                .width(272).margin({ left: 8, right: 8})
                .backgroundColor($r('app.color.white'))
                .onChange((val:string)=>{
                  this.verifyCode = val
                })
              Button(this.countDown === 120 ? $r('app.string.get_vertify_code'): `${this.countDown}s`)
                .onClick(()=>{
                  if(this.countDown === 120){
                    this.SendCode()
                  }
                })
            }.height(50).margin({ top: 8, bottom: 8 })
          }
        }
        //登录按钮
        Button(this.isRegister == false ? $r('app.string.loginpage_title'): $r('app.string.signup')).BottonStyle()
          .backgroundColor($r('app.color.theme_red'))
          .onClick(()=>{
            this.isRegister ? this.Register(): this.DoLogin()
          })

        //注册按钮
        Button(this.isRegister == false ? $r('app.string.signup') : $r('app.string.back'))
          .BottonStyle()
          .fontColor($r('app.color.black'))
          .backgroundColor($r('app.color.background_secondary'))
          .onClick(()=>{
            this.isRegister = !this.isRegister
          })
      }
      .backgroundColor($r('app.color.white')).borderRadius(16)
      .width(348).margin({ top:16, bottom: 16 })
    }
    .width('100%').height('100%').backgroundColor($r('app.color.background_secondary'))
  }

  @Styles BottonStyle(){.width(120).height(36).margin({ top: 16, bottom: 16 })}

}