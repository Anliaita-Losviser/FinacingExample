/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-21 19:40:28. All Rights Reserved.
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
import { CommonTitle } from '../components/TitleComponent'
import web_webview from '@ohos.web.webview'

@Preview
@Component
export struct Statistic {
  @State payRecords: PayRecords[] = [{income:'290',outcome: '340',date: new Date("2024-7-21")}
  ,{income:'355',outcome: '234',date: new Date("2024-7-22")},{income:'964',outcome: '288',date: new Date("2024-7-23")}
  ,{income:'111',outcome: '535',date: new Date("2024-7-24")},{income:'263',outcome: '333',date: new Date("2024-7-25")}
  ,{income:'986',outcome: '185',date: new Date("2024-7-26")},{income:'248',outcome: '625',date: new Date("2024-7-27")}]

  controller: web_webview.WebviewController = new web_webview.WebviewController()
  //给webview传的上下文
  context = {
    getPayRecordsTotal: ()=>{
      return JSON.stringify(this.payRecords)
    }
  }
  build(){
    Column(){
      CommonTitle({
        title: $r('app.string.statitstic_page'),
        topMargin: 24,
        bottomMargin: 16,
        fontWeight: FontWeight.Bold,
        fontSize: FontSizes.Second,
        alignWay: FlexAlign.Center
      })
      Web({
        src: $rawfile('index.html'),
        controller: this.controller
      }).javaScriptProxy({
        //注入上下文
        object: this.context,
        //指定web端可以接收的key
        name: 'context',
        controller: this.controller,
        //webview调用应用侧函数
        methodList: ['getPayRecordsTotal']
      }).onConsole((event)=>{
        console.log('--page log--页面数据',event.message.getMessage())
        return true
      })
    }.height('100%').width('100%')
  }
}
/**
 * 由于Deveco Studio稳定性问题，云函数频繁上传失败，且云端serverless功能不完善，
 * 故暂时不实现查询数据功能，写静态数据验证webview
 */
class PayRecords{
  income: string
  outcome: string
  date: Date
}