## Muffin
**Multiple Flutters In**，基于Flutter2.0多Engine、Navigator2.0实现的一套混合栈管理方案。
   与单Engine的本质区别在于，单Engine模式下pop或者push操作的是同一个Flutter路由，同一个Engine需要attach到不同的FlutterVC上，导致混合栈维护复杂。
   多Engine模式下，Engine是底层spwan的，一个FlutterVC对应一个Engine，每一个FlutterVC中的Flutter路由保证独立，混合栈维护简单，可以实现类似popUntil的功能。
## 功能

#### Feature

✅  Muffin API 无 `Context`

✅  Flutter 树形结构 路由配置

✅ `Native push Flutter` 携带参数、获取返回值

✅ 自定义 `UrlParser` （定义Uri解析）实现 从 Schema 跳转 Flutter

✅ `Flutter push Native` 携带参数、获取返回值

✅ 自定义 `PushNativeHandler`（灵活根据path跳转）

✅ `Flutter pop` 携带参数

✅ `Flutter popUntil` 携带参数

✅ 数据同步共享，实现原生 和 `Flutter` 一些类数据改变同步

✅ `Android Fragment`级别支持

✅ 单独运行 **module** 时，可为 原生通信事件自定 **Mock** 数据

✅ 支持自定义 `MethodChannel`

✅ 支持 二级路由 配置，比如 `/home/detail`、`/home/first/:id` 携带参数

#### TODO

❎ `Native`页面路由标记方式，目前使用Class类名作为path。兼容`ARouter`

❎ 任然 使用 Navigator API 可能会遇到问题

## API

**Native push Flutter**

```dart
//基本push
MuffinNavigator.push("/home");

//push携带参数
Map<String, Object> arguments = new HashMap<>();
arguments.put("count", 1);
MuffinNavigator.push("/first",arguments);

//push scheme
MuffinNavigator.push("meijianclient://meijian.io?url=first&name=uri_test");

//push scheme 携带参数，将会拼接 query 参数
Map<String, Object> arguments = new HashMap<>();
arguments.put("count", 1);
MuffinNavigator.push("meijianclient://meijian.io?url=first&name=uri_test");

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
```dart
//与平常使用的NavigatorAPI一样
//pushNamed
Muffin.pushNamed('/second',{'data': "data from Home Screen"});

//获取返回值 使用 await 即可 
```


**Flutter push Native**
```dart
//将页面路径和参数传递到原生，原生根据参数跳转，可以通过ARouter，可以if else 判断 等
//pushNamed
Muffin.pushNamed('/native_main',{'data': "data from Home Screen"});
```

**Flutter pop**
```dart
//pop
Muffin.pop({'data': "data from Home Screen"});

//TODO popUntil
Muffin.popUntil('/first', {'data': "data from Home Screen"});
```

**数据同步**

```dart
//原理是监听字段改变，通知所有监听者
//实现DataModelChangeListener接口，添加被监听字段，监听器等
//具体参考 Demo [BasicInfo] 类
//Flutter侧也需要同样字段的类，实现 DataModelChangeListener接口
//具体参考 Flutter Demo [basic_info.dart]
```


**Mock**
```dart
//在单独运行时，当需要调用 method channel 的方法时，因为原生没有注册方法，导致报错。我们在调用通信事件时进行拦截，返回 mock 的数据。
//在Flutter初始化时 配置 mock 数据

/// getArguments：事件名，（key，value）：（事件名，参数）=> dynamic(具体类型)
Muffin.addMock(MockConfig('getArguments', (key, value) => {}));
```

## Android 接入Muffin
```dart
1.在Flutter项目中添加依赖 
 muffin: ^1.0.0
 
2.路由配置&&数据共享配置&&各种配置
   void main() async {
     ///确保channel初始化  
     WidgetsFlutterBinding.ensureInitialized();
     ///如果需要数据同步，则添加下面的代码，将原生的数据同步到Flutter侧
     await Muffin.initShare([BasicInfo.instance]);
     ///添加 channel method mock
     Muffin.addMock(MockConfig('someMethod', (key, value) => {}));
     ///get Navigator Widget
     runApp(await getApp());
    }

  ///get a App with dif initialRoute
  Future<Widget> getApp() async {
   ///从原生跳转到Flutter第一次，需要的一些参数 
   var arguments = await NavigatorChannel.arguments;

   return MuffinMaterialApp(
      notFoundRoute: MuffinPage(name: '/404', page: () => NotFoundPage()),
      ///自定义Parser
      routeInformationParser: MuffinInformationParser(MeiJianUrlParser(),
          initialRoute: arguments.path, arguments: arguments.arguments),
      ///路由树  
      muffinPages: [
        /// /home/first and /home/second
        MuffinPage(name: '/home', page: () => HomeScreen(), children: [
          MuffinPage(
            name: '/first',
            page: () => FirstScreen(),
          ),
          MuffinPage(name: '/second/:id', page: () => SecondScreen()),
        ])
      ]);
}
///自定义Schema 解析
class MeiJianUrlParser extends UrlParser {
  @override
  Map<String, String> getParams(Uri uri) {
    Map<String, String> params = Map.from(uri.queryParameters);
    params.remove('url');
    return params;
  }

  @override
  String getPath(Uri uri) {
    if (uri.host.isEmpty) {
      return uri.path;
    }
    String path = uri.queryParameters['url']!;
    if (path.isEmpty) {
      path = "/";
    }
    if (!path.startsWith("/")) {
      path = "/" + path;
    }
    return path;
  }
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
    //带有数据同步能力
    .setModels(models)
    //新增自定义VC，使用【MuffinFlutterFragment】, 参考[BaseFlutterActivity]
    //默认使用【MuffinFlutterActivity】
    .setAttachVc(BaseFlutterActivity.class);
  }
4.在 Manifest.xml文件中配置 FlutterActivity  
5. 好了，Muffin已经集成完了。
```

## 补充
### Flutter页面获取参数
```
老旧的方式，是在混合栈路由配置时，作为参数传递到对应的页面，新的方式 汲取了 Getx的经验，可以直接使用 Muffin 的API获取
参考 first.dart

  Text('Get arguments by [Muffin.arguments]',
        style: Theme.of(context).textTheme.subtitle1,),

  ///Muffin.arguments 
  Text('${Muffin.arguments}',
        style: Theme.of(context).textTheme.subtitle1, ),
```


## 时序图 /结构图


2.0

https://www.processon.com/view/link/5f97c9a6f346fb06e1efae1d