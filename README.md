## muffin
   **Multiple Flutters In**，基于Flutter2.0多Engine、Navigator2.0实现的一套混合栈管理方案。
   与单Engine的本质区别在于，单Engine模式下pop或者push操作的是同一个Flutter路由，同一个Engine需要attach到不同的FlutterVC上，导致混合栈维护复杂。
   多Engine模式下，Engine是底层spwan的，一个FlutterVC对应一个Engine，每一个FlutterVC中的Flutter路由保证独立，混合栈维护简单，可以实现类似popUntil的功能。

## 功能API

**Native push Flutter**
~~~
//基本push
MuffinNavigator.push(MainActivity.this, "/home");

//push携带参数
Map<String, Object> arguments = new HashMap<>();
arguments.put("count", 1);
MuffinNavigator.push(MainActivity.this, "/first",arguments);

//push Uri
MuffinNavigator.push(MainActivity.this, Uri.parse("meijianclient://meijian.io?url=first&name=uri_test"));

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
~~~

**Flutter push Flutter**
~~~
//与平常使用的NavigatorAPI一样
//pushNamed
MuffinNavigator.of(context).pushNamed(Uri.parse('/second'),{'data': "data from Home Screen"});

//获取返回值 使用 await 即可 
~~~

**Flutter push Native**
~~~
//将页面路径和参数传递到原生，原生根据参数跳转，可以通过ARouter，可以if else 判断 等
//pushNamed
MuffinNavigator.of(context).pushNamed(Uri.parse('/native_main'),{'data': "data from Home Screen"});
~~~

**Flutter pop**
~~~
//pop
MuffinNavigator.of(context).pop({'data': "data from Home Screen"});

//popUntil
MuffinNavigator.of(context).popUntil(Uri.parse('/first'), {'data': "data from Home Screen"});
~~~

**数据同步**
~~~
//原理是监听字段改变，通知所有监听者
//实现DataModelChangeListener接口，添加被监听字段，监听器等
//具体参考 Demo [BasicInfo] 类
//Flutter侧也需要同样字段的类，实现 DataModelChangeListener接口
//具体参考 Flutter Demo [basic_info.dart]
~~~

**TODO 功能**

~~~
1. popUntil 到 一个任意已经存在栈中的 Native 页面，前提需要给每一个Native页面一个页面标示（比如ARouter的@Path注解），入侵性大。再者目前场景几乎没有。之后考虑合适的方式。
2. Flutter push native , 获取返回值
~~~

## 接入Muffin

~~~
1. 在Applocation中初始化Muffin
   
   //普通初始化，第二个参数为 各种提供给上层的接口实现
   Muffin.init(this, options());

   private Muffin.Options options() {
    //数据同步对象   
    List<DataModelChangeListener> models = new ArrayList<>();
    models.add(BasicInfo.getInstance());

    return new Muffin.Options()
    //Flutter 跳转 Native 时提供给上层的接口
    .setNativeHandler((activity, pageName, data) -> {
      //根据 pageName 和 data 拼接成 schema 跳转
      if (TextUtils.equals("/main", pageName)) {
        Intent intent = new Intent(activity, MainActivity.class);
        activity.startActivity(intent);
      }
    })
    //Native Uri 类型跳转到 Flutter 接口，可参考默认实现
    .setFlutterHandler(new DefaultPushFlutterHandler())
    //带有数据同步能力
    .setModels(models);
  }

2. 好了，你可以在原生使用Muffin了
3. Flutter Muffin 初始化
   void main() async {

     ///确保channel初始化  
     WidgetsFlutterBinding.ensureInitialized();

     ///如果需要数据同步，则添加下面的代码，将原生的数据同步到Flutter侧
     await Share.instance.init([BasicInfo.instance]);

     ///get Navigator Widget
     runApp(await getApp());
   }

   Future<Widget> getApp() async {
     ///初始化 Navigator
     final navigator = MuffinNavigator(routes: {
       '/home': (uri, arguments) => MuffinRoutePage(child: HomeScreen()),
       '/first': (uri, arguments) => MuffinRoutePage(
            child: FirstScreen(
          arguments: arguments,
        ))
   }, multiple: true); //multiple是标记当前是否为混合模式，若为false，则不会与原生同步栈。

    ///这一步是获取Native传递到Flutter页面的 参数 [path, arguments]
    await navigator.init();

    return MaterialApp.router(
      ///路由解析  
      routeInformationParser: MuffinInformationParser(),
      routerDelegate: navigator,
      ///系统返回键监听
      backButtonDispatcher: MuffinBackButtonDispatcher(navigator: navigator),
   );
  }

4. 好了，Muffin已经集成完了。
~~~

## 时序图 /结构图


2.0

https://www.processon.com/view/link/5f97c9a6f346fb06e1efae1d