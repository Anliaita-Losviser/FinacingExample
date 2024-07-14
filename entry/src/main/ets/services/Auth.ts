/*
 * Copyright (c) StarHidden2846@gmail.com Last Update: 2024-07-13 13:18:44. All Rights Reserved.
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

import { AGConnectUser, } from '@hw-agconnect/auth-ohos';
import '@hw-agconnect/auth-ohos';
import { PhoneAuthProvider, VerifyCodeSettingBuilder } from '@hw-agconnect/auth-ohos';
import { AGCApi } from '@hw-agconnect/api-ohos';

import { Log } from '../common/Log';
import { getAGConnect } from './AgcConfig';

const TAG = "[AGCAuth]";

export class AGCAuth {
  agc: AGCApi;

  constructor(context) {
    this.agc = getAGConnect(context);
  }

  public getCurrentUser(): Promise<AGConnectUser> {
    return this.agc.auth().getCurrentUser();
  }

  public requestPhoneVerifyCode(ctrCode: string, phone: string) {
    let verifyCodeSettings = new VerifyCodeSettingBuilder()
      .setAction(1001)
      .setLang('zh_CN')
      .setSendInterval(60)
      .build();
    this.agc.auth().requestPhoneVerifyCode(
      ctrCode,
      phone,
      verifyCodeSettings).then((ret) => {
      Log.info(TAG, JSON.stringify({ "Verify Code Result: ": ret }));
    }).catch((error) => {
      Log.error(TAG, "Error: " + JSON.stringify(error));
    });
  }

  public async login(countryCode: string, phoneNumber: string, verifyCode: string): Promise<AgUser> {
    return new Promise((resolve, reject) => {
      const credential = PhoneAuthProvider.credentialWithVerifyCode(countryCode, phoneNumber, verifyCode);
      this.agc.auth().signIn(credential).then(async (ret) => {
        Log.info(TAG, "User has signed in..");
        // @ts-ignore
        let user = ret.getUser();
        let userExtra = await ret.getUser().getUserExtra();

        let loginRes = new AgUser(
          user.getUid(),
          user.getPhotoUrl(),
          user.getPhone(),
          user.getDisplayName(),
          userExtra.getCreateTime(),
          userExtra.getLastSignInTime())

        resolve(loginRes);
      }).catch((error) => {
        Log.error(TAG, "Error: ", error);
        reject(error);
      });
    });
  }

  public async logout(): Promise<boolean> {
    return new Promise<boolean>((resolve, reject) => {
      this.agc.auth().signOut().then(() => {
        resolve(true);
      }).catch((error) => {
        Log.error(TAG, "error", error);
        reject(error);
      });
    });
  }

  public async deleteUser(): Promise<boolean> {
    return new Promise((resolve, reject) => {
      this.agc.auth().deleteUser().then(() => {
        resolve(true);
      }).catch((error) => {
        Log.error(TAG, "error", error);
        reject(error);
      });
    });
  }
}

export class AgUser {
  uid: String;
  photoUrl: String;
  phone: String;
  displayName: String;
  registerDate: String;
  lastLogin: String;

  constructor(uid: String = "", photoUrl: String = "", phone: String = "", displayName: String = "", registerDate: String = "", lastLogin: String = "") {
    this.uid = uid;
    this.photoUrl = photoUrl;
    this.phone = phone;
    this.displayName = displayName;
    this.registerDate = registerDate;
    this.lastLogin = lastLogin;
  }

  getUid(): String {
    return this.uid;
  }

  getPhone(): String {
    return this.phone;
  }

  getDisplayName(): String {
    return this.displayName;
  }

  getPhotoUrl(): String {
    return this.photoUrl;
  }

  getRegisterDate(): String {
    return this.registerDate;
  }

  getLastLogin(): String {
    return this.lastLogin;
  }
}
