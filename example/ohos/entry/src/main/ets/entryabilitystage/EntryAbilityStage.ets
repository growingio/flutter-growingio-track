import AbilityStage from '@ohos.app.ability.AbilityStage'
import type Want from '@ohos.app.ability.Want'
import { GrowingAnalytics, GrowingConfig } from 'flutter_growingio_track'
import { GrowingToolsKit } from '@growingio/tools'

export default class EntryAbilityStage extends AbilityStage {
  onCreate(): void {
    // 应用的HAP在首次加载的时，为该Module初始化操作
    this.startAnalytics()
  }
  onAcceptWant(want: Want): string {
    // 仅specified模式下触发
    return 'EntryAbilityStage'
  }

  startAnalytics() {
    // 在初始化 SDK 之前，可配置通用属性
    // GrowingAnalytics.setGeneralProps({ 'defaultProps':'good' })
    // let count = 0
    // GrowingAnalytics.setDynamicGeneralProps(() => {
    //   count++
    //   return { 'count' : count}
    // })
    // GrowingAnalytics.setDynamicGeneralProps(() => ({}))

    let config = new GrowingConfig().SaaS(
      '0a1b4118dd954ec3bcc69da5138bdb96',
      'growing.bf30ad277eaae1aa'
    )
    config.debugEnabled = true
    config.sessionInterval = 30
    config.dataUploadInterval = 15
    config.requestOptions.connectTimeout = 10
    config.requestOptions.transferTimeout = 10
    config.autotrackAllPages = true
    config.plugins = [new GrowingToolsKit({useInRelease: true})]
    GrowingAnalytics.start(this.context, config)
  }
}