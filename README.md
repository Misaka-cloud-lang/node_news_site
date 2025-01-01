## 新闻网站子模块

![Java](https://img.shields.io/badge/Java-17-orange)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1-brightgreen)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple)

基于JSP+Servlet的新闻网站系统，作为互联网广告系统的子模块，实现了新闻展示和广告投放功能。

## 📚 项目结构
node_news_site/
├── src/
│ └── main/
│ ├── java/com/example/news_site/
│ │ ├── controller/ # Servlet控制器
│ │ ├── dao/ # 数据访问层
│ │ ├── model/ # 数据模型
│ │ ├── service/ # 业务逻辑层
│ │ └── util/ # 工具类
│ ├── resources/
│ │ └── db.properties # 数据库配置
│ └── webapp/
│ ├── css/ # 样式文件
│ ├── js/
│ │ └── userTracker.js # 用户行为跟踪
│ ├── images/ # 图片资源
│ │ ├── default.jpg # 默认图片
│ │ ├── banner1.png # 广告横幅
│ │ ├── popup1.png # 弹窗广告
│ │ └── floating1.png # 浮动广告
│ └── pages/ # JSP页面
└── pom.xml # Maven配置

## 🚀 主要功能

### 1. 新闻功能
- 分类浏览：国内、国际、财经、科技等
- 新闻搜索：支持关键词搜索
- 新闻详情：完整的新闻内容展示
- 相关推荐：基于分类的新闻推荐

### 2. 广告功能
- 多广告位支持
  - 顶部通栏(topBanner)
  - 信息流(inFeed)
  - 侧边栏(sidebar)
  - 底部固定(bottomBanner)
- 用户行为跟踪
  - 页面访问记录
  - 分类偏好分析
  - 停留时间统计
- 广告请求与展示
  - 实时广告请求
  - 自适应展示
  - 错误处理机制

## 🔧 配置说明

### 数据库配置

properties
src/main/resources/db.properties
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://101.37.119.177:3306/news_1217
jdbc.username=root
jdbc.password=dijkstra

### 广告服务器配置

javascript
// src/main/webapp/js/userTracker.js
const UserTracker = {
adServer: '112.124.63.147:8080',
categoryMap: {
"国内": "domestic",
"国际": "international",
"体育": "sports",
// ...更多分类映射
}
}



## 📱 页面访问

- 首页: `/news/`
- 新闻列表: `/news/pages/newsList.jsp?category=国内`
- 新闻详情: `/news/pages/newsDetail.jsp?id=1`
- 搜索结果: `/news/pages/searchResults.jsp?query=关键词`

## 🌐 接口说明

### 页面路由
| 功能 | URL | 参数 |
|------|-----|------|
| 首页 | `/news/` | - |
| 新闻列表 | `/news/pages/newsList.jsp` | `category=国内` |
| 新闻详情 | `/news/pages/newsDetail.jsp` | `id=1` |
| 搜索结果 | `/news/pages/searchResults.jsp` | `query=关键词` |

## 📋 部署检查

### 前置条件
- [] JDK 17+
- [] Tomcat 10.1
- [] MySQL 8.0

### 运行检查
1. 数据库连接
   - 确保数据库服务可访问
   - 验证用户名密码正确

2. 广告服务
   - 检查广告服务器状态
   - 监控请求响应时间
   - 验证广告内容展示

## 🔄 版本记录

### v1.0.0 (2024-01)
- ✨ 新闻系统基础功能
- 🎯 广告系统集成
- 📊 用户行为分析
- 📱 响应式界面适配
- 🛠️ 错误处理优化

## 📈 后续计划
- [ ] 广告加载性能优化
- [ ] 用户行为深度分析
- [ ] 新增广告位类型
- [ ] 广告效果统计
## ⚠️ 注意事项

1. 广告系统
   - 确保广告服务器(112.124.63.147:8080)可访问
   - 监控广告请求状态
   - 检查广告展示效果

2. 系统维护
   - 定期检查数据库连接
   - 监控系统日志
   - 及时处理错误请求

## 🔄 更新日志

### v1.0.0 (2024-01)
- 基础新闻功能实现
- 广告系统集成完成
- 用户行为跟踪系统上线
- 响应式界面适配
- 错误处理机制优化

## 📋 待办事项
- [ ] 优化广告加载性能
- [ ] 完善用户行为分析
- [ ] 增加更多广告位类型
- [ ] 添加广告展示统计
主要更新：


1. 添加了更详细的项目结构
补充了图片资源说明
完善了功能描述
添加了待办事项
更新了版本日志
优化了格式和排版

