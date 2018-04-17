# HybridPageKit

>几十行代码完成新闻类App的内容展示页

`HybridPageKit`是一个针对新闻类App高性能、易扩展、组件化的通用内容页实现框架。


<div>
<img src="./HybridPageKit/gifs/Hybrid.gif" width="20%">
<img src="./HybridPageKit/gifs/Short.gif" width="20%">
<img src="./HybridPageKit/gifs/Banner.gif" width="20%">
<img src="./HybridPageKit/gifs/Folded.gif" width="20%">
</div>

*	使用WKWebView展示主内容，内存、稳定性有显著的提高，并且通过页面间复用WKWebView，极大提升了内容页的加载和渲染速度。
	
	>基于[WKWebViewExtension](https://github.com/dequan1331/WKWebViewExtension)解决了部分WKWebView的限制和Bug（menuItems，URLProtocol等）

*	配合后台数据，主内容WebView中非文字部分全部Native化，和WebView以外的扩展区整体构成内容页。对WebView内容区及Native扩展区的组件整体进行页面内滚动复用、页面间的全局复用。极大提升展示速度、UI和交互的灵活性、一次开发全局复用，极大减少开发成本
	>基于[ReusableNestingScrollview](https://github.com/dequan1331/ReusableNestingScrollview)，在不继承特殊View的情况下，通过扩展Delegate，支持WKWebView、UIWebView、UIScrollView等滚动视图中subViews全局的复用和回收

* 	解耦、独立全部UI组件，组件全局复用和自管理。UI组件和Controller、View完全解耦，通过初始化时注册、接收接收页面的各个生命周期事件及关键业务事件独立进行业务逻辑。支持热插拔、灵活独立，易扩展维护。


#	特性

*	集成简单，几十行代码完成新闻类App的内容展示页
*	Hybrid内容展示页，结合WebView及Native，TableView等，满足绝大多数新闻类App的内容页场景
* 	UI组件页面内滚动自动复用、页面间自动重用，一次开发多次使用，易于扩展
*  通过扩展和复用，提升WKWebView的基础能力，WebView上非文字UI组件Native化处理，提高展示速度和灵活性
*  统一滚动复用管理，线程安全，无需继承，易于集成现有逻辑，内部自动实现，无需管理复用逻辑和组件位置。

#	快速使用


1. 后台下发Mustache格式Json数据（或自定义解析处理）
					
```json
{
	"articleContent": "<!DOCTYPE html><html><head></head><body><P>TEXTTEXTTEXTTEXTTEXTTEXT</P><P>{{IMG_0}}</P><P>TEXTTEXTTEXTTEXTTEXTTEXT</P><P>{{IMG_1}}</P><P>TEXTTEXTTEXTTEXTTEXTTEXT</P><P>{{IMG_2}}</P><P>The End</P></body></html>",
	"articleAttributes": {
		"IMG_0": {
		    "url": "http://127.0.0.1:8080?type=3",
		    "width": "340",
		    "height": "200"
		},
		"IMG_1": {
		    "url": "http://127.0.0.1:8080?type=3",
		    "width": "340",
		    "height": "200"
		},
		"IMG_2": {
		    "url": "http://127.0.0.1:8080?type=3",
		    "width": "340",
		    "height": "200"
		},
	},  
	"articleRelateNews": {
	    "index":"1",
	    "newsArray" : [
	        "扩展阅读区 - RelateNews - 1",
	        "扩展阅读区 - RelateNews - 2",
	        "扩展阅读区 - RelateNews - 3",
	        "扩展阅读区 - RelateNews - 4",
	    ],
	}, 
	"articleComment": {
	    "index":"2",
	    "commentArray" : [
	        "相关评论区 - Comment - 1",
	        "相关评论区 - Comment - 2",
	        "相关评论区 - Comment - 3",
	        "相关评论区 - Comment - 4",
	    ],
	},  
}
```
2. 对应UI组件创建Model、View、Controller

3.	页面继承Controller,返回支持UI组件Controller
	
4.	填充数据渲染！




