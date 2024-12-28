// 简化版用户行为跟踪器
const UserTracker = {
    // 广告服务器地址
    adServer: '112.124.63.147:8080',
    
    // 中英文分类映射
    categoryMap: {
        "国内": "domestic",
        "国际": "international",
        "体育": "sports",
        "科技": "technology",
        "娱乐": "entertainment",
        "财经": "finance",
        "军事": "military",
        "社会": "society",
        "股市": "stockMarket",
        "美股": "usStockMarket",
        "搜索": "search",
        "首页": "home"
    },
    
    // 转换分类为英文
    translateCategory: function(category) {
        const englishTag = this.categoryMap[category] || category;
        console.log(`[UserTracker] 分类转换: ${category} -> ${englishTag}`);
        return englishTag;
    },
    
    // 发送用户数据
    sendUserData: function(category, tags) {
        console.log('[UserTracker] 准备发送用户数据:', {
            category: category,
            tags: tags
        });

        // 构建URL参数
        const params = new URLSearchParams({
            userId: '1',
            tag: this.translateCategory(category),
            action: '1'
        });

        const url = `http://${this.adServer}/receive/news?${params.toString()}`;
        console.log('[UserTracker] 发送请求到:', url);

        // 发送请求，参数放在URL中
        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
        }).then(response => {
            if (response.ok) {
                console.log('[UserTracker] ✅ 请求成功发送! 状态码:', response.status);
                return response.text();
            }
            throw new Error('请求失败');
        }).then(data => {
            console.log('[UserTracker] 服务器响应:', data);
        }).catch(error => {
            console.error('[UserTracker] ❌ 请求失败:', error.message);
            console.error('[UserTracker] 详细错误信息:', error);
        });
    }
}; 

// 在全局添加错误处理
window.addEventListener('unhandledrejection', function(event) {
    console.error('[UserTracker] 未处理的Promise错误:', event.reason);
}); 