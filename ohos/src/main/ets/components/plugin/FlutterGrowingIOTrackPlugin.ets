/**
 * @license
 * Copyright (C) 2024 Beijing Yishu Technology Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos'
import { GrowingAnalytics, GrowingConfig, GrowingAttrType } from '@growingio/analytics'

type ValueType = string | number | boolean | string[] | number[] | boolean[]

/** FlutterGrowingIOTrackPlugin **/
export default class FlutterGrowingIOTrackPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null
  context: Context | null = null

  constructor() {
  }

  getUniqueClassName(): string {
    return "FlutterGrowingIOTrackPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_growingio_track");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "track") {
      this.trackCustomEvent(call)
    } else if (call.method == "setEvar") {
      this.setEvar(call)
    } else if (call.method == "setPeopleVariable") {
      this.setPeopleVariable(call)
    } else if (call.method == "setUserId") {
      this.setLoginUserId(call)
    } else if (call.method == "clearUserId") {
      this.cleanLoginUserId(call)
    } else if (call.method == "setVisitor") {
      this.setVisitor(call)
    } else {
      result.notImplemented()
    }
  }

  trackCustomEvent(call: MethodCall) {
    let eventName = call.argument('eventId') as string | null
    let map = call.argument('variable') as Map<string, ValueType>
    let attributes = this.attributesFromMap(map)
    if (eventName) {
      GrowingAnalytics.track(eventName, attributes)
    }
  }

  setEvar(call: MethodCall) {
    let map = call.args as Map<string, ValueType>
    let attributes = this.attributesFromMap(map)
    GrowingAnalytics.setEvar(attributes)
  }

  setPeopleVariable(call: MethodCall) {
    let map = call.args as Map<string, ValueType>
    let attributes = this.attributesFromMap(map)
    GrowingAnalytics.setPeopleVariable(attributes)
  }

  setLoginUserId(call: MethodCall) {
    let userId = call.argument('userId') as string
    GrowingAnalytics.setLoginUserId(userId)
  }

  cleanLoginUserId(call: MethodCall) {
    GrowingAnalytics.cleanLoginUserId()
  }

  setVisitor(call: MethodCall) {
    let map = call.args as Map<string, ValueType>
    let attributes = this.attributesFromMap(map)
    GrowingAnalytics.setVisitor(attributes)
  }

  attributesFromMap(map: Map<string, ValueType>): GrowingAttrType {
    let attributes: GrowingAttrType = {}
    if (map == null || map == undefined) {
      return {}
    }
    map.forEach((value, key) => {
      attributes[key] = value
    })
    return attributes
  }
}