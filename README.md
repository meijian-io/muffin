## Muffin
**Multiple Flutters In**，基于Flutter2.0多Engine、Navigator2.0实现的一套混合栈管理方案。
   与单Engine的本质区别在于，单Engine模式下pop或者push操作的是同一个Flutter路由，同一个Engine需要attach到不同的FlutterVC上，导致混合栈维护复杂。
   多Engine模式下，Engine是底层spwan的，一个FlutterVC对应一个Engine，每一个FlutterVC中的Flutter路由保证独立，混合栈维护简单，可以实现类似popUntil的功能。

## 功能

#### Feature
✅ `Native push Flutter` 携带参数、获取返回值

✅ 自定义 `PushFlutterHandler` （定义Uri解析）实现 从 Schema 跳转 Flutter
✅ `Flutter push Native` 携带参数、获取返回值
✅ 自定义 `PushNativeHandler`（灵活根据path跳转）
✅ `Flutter pop` 携带参数
✅ 数据同步共享，实现原生 和 `Flutter` 一些类数据改变同步
✅ `Android Fragment`级别支持
✅ 单独运行 **module** 时，可为 原生通信事件自定 **Mock** 数据
✅ 支持自定义 `MethodChannel`

#### TODO
❎ `Native`页面路由标记，实现 `popUntil`
❎ 支持 **Web**
❎ 支持 二级路由 配置，比如 `/home/detail`

## API

**Native push Flutter**
```
//基本push
MuffinNavigator.push("/home");

//push携带参数
Map<String, Object> arguments = new HashMap<>();
arguments.put("count", 1);
MuffinNavigator.push("/first",arguments);

//push Uri
MuffinNavigator.push(Uri.parse("meijianclient://meijian.io?url=first&name=uri_test"));

//对应都有pushForResult API
@Override protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (data != null) {
      //pageName 为返回参数的 页面标示
      Log.e("AAA", data.getStringExtra("pageName"));
      //result为 返回值 是一个 HashMap<String,Object>
      Log.e("AAA", (data.getSerializableExtra("result")).toString());
    }
}
```

**Flutter push Flutter**
```
//与平常使用的NavigatorAPI一样
//pushNamed
MuffinNavigator.of(context).pushNamed('/second',{'data': "data from Home Screen"});

//获取返回值 使用 await 即可 
```

**Flutter push Native**
```
//将页面路径和参数传递到原生，原生根据参数跳转，可以通过ARouter，可以if else 判断 等
//pushNamed
MuffinNavigator.of(context).pushNamed('/native_main',{'data': "data from Home Screen"});
```

**Flutter pop**
```
//pop
MuffinNavigator.of(context).pop({'data': "data from Home Screen"});

//TODO popUntil
MuffinNavigator.of(context).popUntil('/first', {'data': "data from Home Screen"});
```

**数据同步**

```
//原理是监听字段改变，通知所有监听者
//实现DataModelChangeListener接口，添加被监听字段，监听器等
//具体参考 Demo [BasicInfo] 类
//Flutter侧也需要同样字段的类，实现 DataModelChangeListener接口
//具体参考 Flutter Demo [basic_info.dart]
```


**Mock**
```
//在单独运行时，当需要调用 method channel 的方法时，因为原生没有注册方法，导致报错。我们在调用通信事件时进行拦截，返回 mock 的数据。
//在Flutter初始化时 配置 mock 数据

/// getArguments：事件名，（key，value）：（事件名，参数）=> dynamic(具体类型)
Muffin.instance.addMock(MockConfig('getArguments', (key, value) => {}));
```

## Android 接入Muffin
```
1.在Flutter项目中添加依赖 
 
 muffin:
    git:
      url: 'git@gitlab.qunhequnhe.com:app/flutter/muffin.git'
      ref: 'master'
 pub get
 
2.路由配置&&数据共享配置&&各种配置
   void main() async {
     ///确保channel初始化  
     WidgetsFlutterBinding.ensureInitialized();
     ///如果需要数据同步，则添加下面的代码，将原生的数据同步到Flutter侧
     await Share.instance.init([BasicInfo.instance]);
     ///添加 channel method mock
     Muffin.instance.addMock(MockConfig('someMethod', (key, value) => {}));
     ///get Navigator Widget
     runApp(await getApp());
    }

    Future<Widget> getApp() async {
     ///初始化 Navigator，配置页面路由信息
     ///initRoute参数：在单独运行时可以配置打开默认的页面
     ///initArguments参数：在单独运行时可以配置打开默认的页面参数
     ///emptyWidget参数：在跳转时没有找对应的页面，则显示定义的空页面
     final navigator = MuffinNavigator(routes: {
       '/home': (arguments) => MuffinRoutePage(child: HomeScreen()),
       '/first': (arguments) => MuffinRoutePage(
            child: FirstScreen(
          arguments: arguments,
        ))
    },
        initRoute:'/',
        initArguments:{},
        emptyWidget: CustomEmptyView()
    );
    return MaterialApp.router(
      ///路由解析  
      routeInformationParser: MuffinInformationParser(navigator: navigator),
      routerDelegate: navigator,
      ///系统返回键监听
      backButtonDispatcher: MuffinBackButtonDispatcher(navigator: navigator),
   );
  }

3.原生，在Applocation中初始化 Muffin
   
   //普通初始化，第二个参数为 各种提供给上层的接口实现
   Muffin.init(this, options());

   private Muffin.Options options() {
    //数据同步对象   
    List<DataModelChangeListener> models = new ArrayList<>();
    models.add(BasicInfo.getInstance());

    return new Muffin.Options()
    //Flutter 跳转 Native 时提供给上层的接口
    .setPushNativeHandler((activity, pageName, data) -> {
      //根据 pageName 和 data 拼接成 schema 跳转
      if (TextUtils.equals("/main", pageName)) {
        Intent intent = new Intent(activity, MainActivity.class);
        activity.startActivity(intent);
      }
    })
    //Native Uri 类型跳转到 Flutter 接口，可参考默认实现
    .setPushFlutterHandler(new DefaultPushFlutterHandler())
    //带有数据同步能力
    .setModels(models)
    //新增自定义VC，使用【MuffinFlutterFragment】, 参考[BaseFlutterActivity]
    //默认使用【MuffinFlutterActivity】
    .setAttachVc(BaseFlutterActivity.class);
  }
4.在 Manifest.xml文件中配置 FlutterActivity  
5. 好了，Muffin已经集成完了。
```

## 时序图 /结构图


2.0

https://www.processon.com/view/link/5f97c9a6f346fb06e1efae1d