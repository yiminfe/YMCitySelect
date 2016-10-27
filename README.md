<h1>YMCitySelect</h1>
<ul>
<li>快速集成城市选择框架</li>
<li>修改: 在原来的仓库的基础上,将 city 添加id属性, districts(辖区列表) 由原来的string 类型 改动为 city 的 model 类型,,   
之前的协议和其他代理 都是用string 传输的,现在改为 city 的 model 传递,你可以通过继承 YMCityModel 来实现更多的属性 和功能,,,, 注意,自定义的 citymodel 请实现 NSCoding 的协议, </li>
<li>原来的城市显示数据都是 plist 获取的,现在改为可以外部传入合适的对象进入,没有传入的时候就是以前的 plist 数据 , 使用方法是 

typedef  NSArray<YMCityGroupsModel *>*(^GetDataSourceBlock)(void) ;
///获取城市数据
@property (copy,nonatomic) GetDataSourceBlock getGroupBlock;


只需要传入一个 YMCityGroupsModel 对象的数组即可

</li>
<li>支持首字母拼音查找城市、全拼查找城市、字体查找城市</li>
<li></li>
<li></li>
<li>注意:请在info.plist文件里面配置key: NSLocationWhenInUseUsageDescription</li>
<li>通过Modal窗口弹出[[YMCitySelect alloc] initWithDelegate:self]，需要传入代理控制器</li>
<li>遵守协议:YMCitySelectDelegate</li>
<li>实现代理方法:-(void)ym_ymCitySelectCityName:(NSString *)cityName</li>
<a href="https://github.com/iosdeveloperSVIP/YMCitySelect/archive/master.zip" target="_blank" ><img src="https://raw.githubusercontent.com/iosdeveloperSVIP/YMCitySelect/master/ymcityselect.gif"></img></a>
</ul>
<p>GitHub：<a href="https://github.com/iosdeveloperSVIP"  target="_blank">iosdeveloperSVIP</a>
 &nbsp;&nbsp;&nbsp;&nbsp;邮箱：<a href="mailto:iosdeveloper@vip.163.com">iosdeveloper@vip.163.com</a><p>
<h4>亲爱的各位同行，如果在使用中出现bug，请联系邮箱:<a href="mailto:iosdeveloper@vip.163.com">iosdeveloper@vip.163.com</a>，如果使用不错的话请帮我点下右上角星星Star，非常感谢</h4>
<h1>操作目录</h1>
<ul>
<li><a href="#defaultstyles">一行代码集成</a>
<ui>
<li><a href="#defaultstyles">Modal出城市选择控制器</a></li>
<li><a href="#defaultstyles">遵守协议，实现代理方法</a></li>
</ul>
</li>
</ul>
<hr/>
<h2>安装使用</h2>
<h3>使用 CocoaPods安装</h3>
<div class="highlight highlight-source-ruby"><pre>pod <span class="pl-s"><span class="pl-pds">'</span>YMCitySelect<span class="pl-pds">'</span></span></pre></div>
<h3>手动导入文件</h3>
<ul>
<li>将YMCitySelect文件夹中的所有源代码拽入项目中</li>
<li>【导入主头文件：<code>#import "YMCitySelect.h"</code>】</li>
</ul>
<h2 id="defaultstyles">一行代码集成</h2>
<div class="highlight highlight-source-objc"><pre>
<span class="pl-k">
[self presentViewController:[[YMCitySelect alloc] initWithDelegate:self] animated:YES completion:nil];
<br>//通过Modal弹出城市控制器，并传入代理控制器
<br>YMCitySelectDelegate //请遵守协议
<br>-(void)ym_ymCitySelectCityName:(NSString *)cityName
<br>//请实现代理方法cityName就是返回的城市名</div>
<h4>亲爱的各位同行，如果你已经浏览到这，请帮我点下右上角星星Star，非常感谢</h4>
