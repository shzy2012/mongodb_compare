import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isPanelVisible = true;
  List<Tab> _tabs = [];
  List<Widget> _tabViews = [];
  List<String> _mytabs = ["Tab 1", "Tab 2", "Tab 3"];

  // TabController 是 Flutter 中用于管理 TabBar 和 TabBarView 的控制器。它的作用是跟踪当前选中的标签页（Tab）索引，并允许在不同标签页之间进行切换。TabController 常与 TabBar 和 TabBarView 一起使用，以实现标签页导航。
  // late 关键字用于声明一个稍后初始化的非空变量。它告诉编译器，这个变量在使用前一定会被初始化，因此在声明时不需要立即赋值。
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabs.clear();
    _tabViews.clear();

    for (int i = 0; i < _mytabs.length; i++) {
      _tabs.add(_buildTab(i, _mytabs[i]));
      _tabViews.add(Center(
          child: Text(_mytabs[i], style: const TextStyle(fontSize: 24))));
    }

    _tabController = TabController(
        length: _mytabs.length,
        vsync: this /* 通过 vsync 来确保动画在正确的时间点更新，以节省资源并提高性能。*/);
  }

  Tab _buildTab(int index, String title) {
    return Tab(
      child: Row(
        children: [
          const Icon(Icons.compare, size: 16),
          Text(title),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              print("触发 ${title} , ${index} ");
              _closeTab(index);
            },
            child: const Icon(Icons.close, size: 16),
          )
        ],
      ),
    );
  }

  void _closeTab(int index) {
    if (index >= 0 && index < _mytabs.length) {
      setState(() {
        _tabs.removeAt(index);
        _tabViews.removeAt(index);
        _mytabs.removeAt(index);
        _tabController = TabController(length: _mytabs.length, vsync: this);
      });
    }
  }

  void _onDestinationSelected(int index) {
    // setState用于通知框架状态已经发生了变化，并且需要重新构建界面以反映这些变化。
    // 当你调用 setState 时，Flutter 会重新运行 build 方法，从而更新界面
    setState(() {
      if (_selectedIndex == index) {
        _isPanelVisible = !_isPanelVisible;
      } else {
        _selectedIndex = index;
        _isPanelVisible = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        // layout
        children: <Widget>[
          // 用于实现侧边导航栏的组件
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onDestinationSelected,
            destinations: const [
              NavigationRailDestination(
                  icon: Icon(Icons.folder),
                  label: Text("Explorer"),
                  selectedIcon: Icon(Icons.folder_open)),
              NavigationRailDestination(
                  icon: Icon(Icons.search),
                  label: Text("Search"),
                  selectedIcon: Icon(Icons.search)),
              NavigationRailDestination(
                icon: Icon(Icons.source),
                label: Text("Source Control"),
                selectedIcon: Icon(Icons.source),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.extension),
                label: Text("Extensions"),
                selectedIcon: Icon(Icons.extension),
              ),
              NavigationRailDestination(
                  icon: Icon(Icons.account_circle),
                  label: Text("Account"),
                  selectedIcon: Icon(Icons.account_circle)),
            ],
          ),
          // 水平布局中创建一个垂直分隔线
          const VerticalDivider(
            // 用于设置分隔线本身的厚度
            thickness: 1,
            // 用于设置整个分隔线小部件的宽度（包括线条和可能的空白）。
            width: 1,
            // 用于设置分隔线的颜色。
            color: Colors.grey,
          ),
          // 用于控制其子小部件的可见性
          Visibility(
              visible: _isPanelVisible,
              child: Container(
                width: 200,
                color: Colors.grey[200],
                child: Center(
                    child: Text(
                  'Panel for ${_selectedIndex == 0 ? "Explorer" : _selectedIndex == 1 ? "Search" : _selectedIndex == 2 ? "Source Control" : _selectedIndex == 3 ? "Extensions" : "Account"}',
                  style: const TextStyle(fontSize: 18),
                )),
              )),
          const VerticalDivider(
            // 用于设置分隔线本身的厚度
            thickness: 1,
            // 用于设置整个分隔线小部件的宽度（包括线条和可能的空白）。
            width: 1,
            // 用于设置分隔线的颜色。
            color: Colors.grey,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                /* Widget 类型的列表;通过使用泛型，可以确保列表中的所有元素都是 Widget*/
                TabBar(
                  tabAlignment: TabAlignment.start,
                  tabs: _tabs,
                  isScrollable: true,
                  controller: _tabController,
                  indicatorPadding: const EdgeInsets.only(left: 0.0),
                  labelPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0), // 用于设置标签的内边距
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: _tabViews,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("状态栏:", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() {
            _isPanelVisible = !_isPanelVisible;
          }),
        },
        child: Icon(
          _isPanelVisible ? Icons.visibility_off : Icons.visibility,
        ),
      ),
    );
  }
}
