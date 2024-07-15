/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-14 11:54:48. All Rights Reserved.
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
import { Home } from '../views/Home'
import { MyInfomation } from '../views/My'
import { Wallet } from '../views/Wallet'

@Entry
@Component
struct MainPage {
  @StorageProp('currentBreakpoint') curBp: string = 'sm'
  @State currentIndex: number = 0
  private tabsController: TabsController = new TabsController()
  build() {
    Tabs({barPosition: this.curBp == 'sm'? BarPosition.End : BarPosition.Start, controller: this.tabsController}){
      TabContent() {
        Home()//首页
      }
      .tabBar(this.TabBuilder($r('app.string.main_page'), 0,$r('app.media.house_fill_selected'),$r('app.media.house_fill')))
      TabContent() {
        Text('统计').fontSize(30)
      }
      .tabBar(this.TabBuilder($r('app.string.statitstic_page'),1,$r('app.media.statistics_selected'), $r('app.media.statistics')))
      TabContent() {
        Wallet()
      }
      .tabBar(this.TabBuilder($r('app.string.packet_page'),2,$r('app.media.case_fill_selected'), $r('app.media.case_fill')))
      TabContent() {
        MyInfomation()
      }
      .tabBar(this.TabBuilder($r('app.string.my_page'), 3,$r('app.media.person_crop_circle_fill_1_selected'),$r('app.media.person_crop_circle_fill_1')))
    }.vertical(this.curBp == 'sm'? false: true).margin({bottom: 28})
    .backgroundColor($r('app.color.white')).scrollable(false)
  }
  /**
   *
   * @param title：tab的标题
   * @param targetIndex：目标页面
   * @param selectedImg：选中状态的图片
   * @param normalImg：未选中状态的图片
   */
  @Builder TabBuilder(title: ResourceStr, targetIndex: number, selectedImg: Resource, normalImg: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedImg : normalImg)
        .size({ width: 25, height: 25 })
      Text(title)
        .fontColor(this.currentIndex === targetIndex ? $r('app.color.theme_red') : $r('app.color.black'))
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      /**
       * tab组件的点击切换逻辑
       */
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(this.currentIndex);
    })
  }
}