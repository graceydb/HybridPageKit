# ReusableNestingScrollview

**`ReusableNestingScrollview`是一个解决滚动视图中SubView全局复用和回收问题的组件。区别于传统的类似解决方案，`RNS`无需继承特殊ScrollView，只通过扩展Delegate的方式实现，从而更广泛的支持WKWebView、UIWebView等滚动视图，更加通用和独立。**

`ReusableNestingScrollview` is a component to solve the problem of SubView global reuse and recovery in rolling views. Unlike traditional similar solutions, `RNS `does not need to inherit a special ScrollView, only by extending the Delegate, so that the rolling views such as WKWebView, UIWebView, and so on are more widely supported, more general and independent. 

> **与[WKWebViewExtension](https://github.com/dequan1331/WKWebViewExtension)一起，组件服务于[HybridPageKit](https://github.com/dequan1331/HybridPageKit)，一个资讯类内容底层页完整的通用组件。**
> 
> Together with [WKWebViewExtension](https://github.com/dequan1331/WKWebViewExtension), components serve [HybridPageKit](https://github.com/dequan1331/HybridPageKit), which is a general sulotion of news App content page.


#Features

1.	**无需继承，适用于WebView等全部滚动视图**
	*	**区别传统组件的实现方式，无需继承特殊ScrollView，通过代理分发的方式，使子View滚动复用回收的功能能应用到任何滚动视图中**
	* **支持全部滚动视图（UIScrollview、WKWebView、UIWebView等等）**
	* **使用简单，10+行 关键函数代码即可完成ScrollView代理基本逻辑**
	* **使用场景举例：WebView展示简单内容，复杂业务逻辑使用NativeView，实现Hybrid的内容页面，并且支持Native滚动复用回收。**

		>1.It doesn't need inheritance, and applies to all rolling views such as WebView
		>> 	*	Unlike the traditional component implementation, it does not have to inherit a special ScrollView, but by the way of delegate dispatch, so that the function of the sub View scrolling reuse can be applied to any rolling view.
		>> 	* Support all rolling views (UIScrollview, WKWebView, UIWebView and so on).
		>> 	* Simple to use, complete the basic logic of ScrollView delegate by using only 10+ lines of key function code.

2.	**更加完善的区域和状态，灵活处理业务逻辑.**
	*	**自定义增加WorkRange区域。子View增加到三种状态，更加灵活的处理业务逻辑**
	* **回收池 ： 子View清除状态，进入全局回收池**
	* **准备区 ： 子View进入准备区，用于懒加载，数据预拉取等逻辑**
	* **展示区 ： 子View在屏幕中展示，用于渲染展示等逻辑**
	* **使用场景举例：一张Gif图片，进入准备区执行数据拉取，不播放，进入展示区进行播放，离开展示区进入准备区不立即回收但停止播放。**
 
		>2.Better view`s state management, flexible handling of business logic.
		>> 	*	Custom WorkRange areas which make the subview to three states, handing business logic more flexibly.
		>> 	* 	Recovery pool: The subview clear all state and gets into the global recovery pool.
		>> 	* 	Preparation area: The subview is in the preparation area, which is used for lazy loading, data prefetching and other business.
		>>   *	Display area: The subview displays in the screen, which is used for rendering and display.


3.	**数据驱动，View无状态只负责渲染展示**
	
	* **view不保存数据信息，不保存frame信息，只负责渲染**
	* **model实现protocol，参与全部的逻辑、复用回收计算等**
 
  
		>3.Data-driven, view only plays the role of rendering.
		>> 	*	View does not save data information, does not save frame information, but only plays the role of rendering.
		>> 	* 	Model implements protocol and participates in all logic, computation of recovery and reuse.


4.	**全局跨View复用及容错保护**
	
	*	**全局View回收池，支持同类型View 当前页面、跨页面复用回收**
	*	**自动回收失去父页面的View，防止内存泄露**
	*	**回收池线程安全，自定义回收view阈值等**
	

		>4.Global reuse and Robustness.
		>> 	*	The recovery pool supports the same type of View to reuse, include current page and cross page.
		>> 	*	Automatically recycle the View that loses the superView to prevent memory leakage.
		>> 	*	Thread safe, and custom count of recovery views.
	

	



#Usage
	
**只需三步，轻松实现**
	
1.	**扩展view相关联数据Model实现protocol**

```objc
@interface TestModel : NSObject <RNSModelProtocol>
	
	
-(NSString *)getUniqueId{
    return _uniqueId;
}
-(void)setComponentFrame:(CGRect)frame{
    _componentFrame = frame;
}
-(CGRect)getComponentFrame{
    return _componentFrame;
}
-(Class)getComponentViewClass{
    return _componentViewClass;
}
-(__kindof RNSComponentContext *)getCustomContext{
    return nil;
}
```
2.	**扩展ScrollView delegate**

```objc
_handler = [[RNSHandler alloc]initWithScrollView:scrollView
                      externalScrollViewDelegate:self 
                        scrollWorkRange:200.f 
                        componentViewStateChangeBlock:^(RNSComponentViewState state, 
                        NSObject<RNSModelProtocol> *componentItem, __kindof UIView *componentView) {
    
    // 复用回收View状态变化处理
    // 进入准备区 & 进入展示 & 离开展示 & 离开准备区
}];
```
3.	**增加、修改数据时reload**

```objc
[_handler reloadComponentViewsWithProcessBlock:^(NSMutableDictionary<NSString *,NSObject<RNSModelProtocol> *> *componentItemDic) {        
	
	//修改、重新设置componentItemDic中model的origin
}];
```
