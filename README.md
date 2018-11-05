GrowingIO的埋点版本flutter插件. 


# 集成


## Android集成

此Flutter插件可支持track版本与auto-track版本的GrowingIO SDK使用, 请根据需要自行选择搭配

### 添加Android依赖
#### 依赖纯打点版本
纯打点版本(track)版本， 需要依赖track版本的SDK

    dependencies{
        implementation 'com.growingio.android:vds-android-agent:track-2.6.0'
    }

### 无埋点版本
无埋点版本(auto-track)版本， 需要依赖于auto-track版本的SDK并且需要配置Gradle插件

*配置ClassPath:*

    buildscript {
        repositories {
            jcenter()
            google()
        }
        dependencies {
            //gradle建议版本
            classpath 'com.android.tools.build:gradle:3.1.3'
            classpath 'com.growingio.android:vds-gradle-plugin:autotrack-2.6.0'
        }
    }

*使用插件:*

    apply plugin: 'com.android.application'
    //添加插件
    apply plugin: 'com.growingio.android'
    ​
    dependencies {
            compile 'com.growingio.android:vds-android-agent:autotrack-2.6.0@aar'
    }

### 获取projectId与UrlScheme

在GrowingIO官网应用管理创建Android应用， 跳转界面后可以发现包含projectId与UrlSchema的代码片段， 请粘贴到项目对应位置: 

    android {
      defaultConfig {
    	// xxxx
    	resValue("string", "growingio_project_id", "9926fc6c1189e2fb")
    	resValue("string", "growingio_url_scheme", "growing.da7e6c2879469314")
    	// xxxx
      }
    }

另外为了可以从浏览器直接跳转App， 需要在Manifest中配置UrlSchema

    <intent-filter>
      <data android:scheme="growing.da7e6c2879469314"/>
      <action android:name="android.intent.action.VIEW" />
    
      <category android:name="android.intent.category.DEFAULT" />
      <category android:name="android.intent.category.BROWSABLE" />
    </intent-filter>

同时也需要配置权限（比如网络权限）

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>

具体配置请参见项目的example配置


### 初始化SDK

GrowingIO的SDK需要在Application的onCreate中初始化: 

    GrowingIO.startWithConfiguration( this,
    		new Configuration()
    				.setChannel("渠道名")
    				.setRnMode(true)     // 这个必须设置
    				.setDebugMode(true)   // 显示日志， release环境请关闭
    				.setTestMode(true));  // 即时发送， release环境请关闭

如果flutter项目没有自定义Application， 需要用户自己手动添加一个AndroidApplication， 可参照example


### tip

1.  为什么Android项目里面高亮GrowingIO的类会出现报红色

    这个应该是Flutter项目结构问题，不过并不影响运行， 可以放心编译

2.  为什么不在flutter中初始化:

    -   因为GrowingIO需要获取Android的Activity生命周期， 为了数据的准确性， 需要在Activity出现前就初始化完成
    -   开发者相信很多用户都会使用flutter + native形式的进行开发， 为了同时服务flutter于native


# API

在dart中调用GrowingIO的函数， 需要先import对应的包

    import 'package:flutter_growingio_track/growingio_track.dart';

具体参数限制请参见GrowingIO官网文档。 

1.  track发送自定义事件, 对应于cstm事件

    <table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
    
    
    <colgroup>
    <col  class="org-left" />
    
    <col  class="org-left" />
    
    <col  class="org-left" />
    </colgroup>
    <tbody>
    <tr>
    <td class="org-left">参数</td>
    <td class="org-left">是否必填</td>
    <td class="org-left">说明</td>
    </tr>
    
    
    <tr>
    <td class="org-left">eventId</td>
    <td class="org-left">必填</td>
    <td class="org-left">事件Id</td>
    </tr>
    
    
    <tr>
    <td class="org-left">num</td>
    <td class="org-left">否</td>
    <td class="org-left">数值, double型</td>
    </tr>
    
    
    <tr>
    <td class="org-left">variable</td>
    <td class="org-left">否</td>
    <td class="org-left">参数, Map型</td>
    </tr>
    </tbody>
    </table>
    
    调用示例:
    
        import 'package:growingioflutter/growingio_track.dart';
        
        GrowingIO.track('eventId');
        GrowingIO.track('testEventId', num: 23.0, variable: {'testKey': 'testValue', 'testNumKey': 233});
        GrowingIO.track('eventId', num: 23.0);
        GrowingIO.track('eventId', variable: {'testkey': 'testValue', 'testNumKey': 2333});

2.  setEvar发送转化变量, 对应于evar事件

    函数原型为: setEvar(Map<String, dynamic> variable), 
    调用示例: 
    
        GrowingIO.setEvar({
          'testKey': 'testValue', 'testNumKey': 2333.0
        });

3.  setPeopleVariable发送用户变量, 对应于ppl事件

    函数原型为: setPeopleVariable(Map<String, dynamic> variable) 
    
    调用示例: 
    
        GrowingIO.setPeopleVariable({
          'testKey': 'testValue', 'testNumKey': 2333.0
        });

4.  setUserId设置登录用户Id, 对应于cs1字段

    <table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">
    
    
    <colgroup>
    <col  class="org-left" />
    
    <col  class="org-left" />
    
    <col  class="org-left" />
    </colgroup>
    <tbody>
    <tr>
    <td class="org-left">参数</td>
    <td class="org-left">类型</td>
    <td class="org-left">描述</td>
    </tr>
    
    
    <tr>
    <td class="org-left">userId</td>
    <td class="org-left">String</td>
    <td class="org-left">登录用户Id</td>
    </tr>
    </tbody>
    </table>
    
    函数原型: setUserId(String userId)
    
    调用示例: 
    
        GrowingIO.setUserId("testUserId");

5.  clearUserId清楚登录用户Id

    函数原型: clearUserId()
    
    调用示例: 
    
        GrowingIO.clearUserId();

6.  setVisitor设置访问用户变量, 对应于vstr事件

    函数原型: setVisitor(Map<String, dynamic> variable)
    
    调用示例: 
    
        GrowingIO.setVisitor({
        	  "visitorKey": 'key', "visitorValue": 34
        	});

##  iOS集成 
集成方式见Word文档：Flutter-iOS集成文档
##  iOS调用

调用方式与安卓一致
调用示例:

import 'package:flutter_growingio_track/growingio_track.dart';

GrowingIO.track('eventId');
GrowingIO.track('testEventId', num: 23.0, variable: {'testKey': 'testValue', 'testNumKey': 233});
GrowingIO.track('eventId', num: 23.0);
GrowingIO.track('eventId', variable: {'testkey': 'testValue', 'testNumKey': 2333});

2.  setEvar发送转化变量, 对应于evar事件

函数原型为: setEvar(Map<String, dynamic> variable), 
调用示例: 

GrowingIO.setEvar({
'testKey': 'testValue', 'testNumKey': 2333.0
});

3.  setPeopleVariable发送用户变量, 对应于ppl事件

函数原型为: setPeopleVariable(Map<String, dynamic> variable) 

调用示例: 

GrowingIO.setPeopleVariable({
'testKey': 'testValue', 'testNumKey': 2333.0
});

4.  setUserId设置登录用户Id, 对应于cs1字段

<table border="2" cellspacing="0" cellpadding="6" rules="groups" frame="hsides">


<colgroup>
<col  class="org-left" />

<col  class="org-left" />

<col  class="org-left" />
</colgroup>
<tbody>
<tr>
<td class="org-left">参数</td>
<td class="org-left">类型</td>
<td class="org-left">描述</td>
</tr>


<tr>
<td class="org-left">userId</td>
<td class="org-left">String</td>
<td class="org-left">登录用户Id</td>
</tr>
</tbody>
</table>

函数原型: setUserId(String userId)

调用示例: 

GrowingIO.setUserId("testUserId");

5.  clearUserId清楚登录用户Id

函数原型: clearUserId()

调用示例: 

GrowingIO.clearUserId();

6.  setVisitor设置访问用户变量, 对应于vstr事件

函数原型: setVisitor(Map<String, dynamic> variable)

调用示例: 

GrowingIO.setVisitor({
"visitorKey": 'key', "visitorValue": 34
});

