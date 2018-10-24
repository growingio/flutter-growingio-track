package com.growingio.plugin.fluttergrowingiotrackexample;

import io.flutter.app.FlutterApplication;
import com.growingio.android.sdk.collection.GrowingIO;
import com.growingio.android.sdk.collection.Configuration;

/**
 * Created by liangdengke on 2018/10/24.
 */
public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();


        GrowingIO.startWithConfiguration( this,
                new Configuration()
                        .setChannel("渠道名")
                        .setRnMode(true)     // 这个必须设置
                        .setDebugMode(true)   // 显示日志， release环境请关闭
                        .setTestMode(true));  // 即时发送， release环境请关闭
    }
}
