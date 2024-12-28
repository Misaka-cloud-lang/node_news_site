// 更新时间日期
function updateDateTime() {
    const now = new Date();
    const dateOptions = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
    const timeOptions = { hour: '2-digit', minute: '2-digit', second: '2-digit' };
    
    document.getElementById('currentDate').textContent = now.toLocaleDateString('zh-CN', dateOptions);
    document.getElementById('currentTime').textContent = now.toLocaleTimeString('zh-CN', timeOptions);
}

// 初始化函数
function initCommon() {
    updateDateTime();
    setInterval(updateDateTime, 1000);
}

// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', initCommon);

// 视图切换功能
document.addEventListener('DOMContentLoaded', function() {
    console.log('View switcher initialization...');
    const viewSwitchers = document.querySelectorAll('.view-switcher .btn');
    const newsContainer = document.querySelector('.news-container');
    
    if (!viewSwitchers.length || !newsContainer) {
        console.log('Required elements not found:', {
            viewSwitchers: viewSwitchers.length,
            newsContainer: !!newsContainer
        });
        return;
    }

    viewSwitchers.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('View button clicked');
            
            // 移除所有按钮的active类
            viewSwitchers.forEach(btn => btn.classList.remove('active'));
            // 添加当前按钮的active类
            this.classList.add('active');
            
            // 切换视图
            const viewType = this.getAttribute('data-view');
            console.log('Switching to view:', viewType);
            
            // 使用 classList 方法替换类名
            newsContainer.classList.remove('grid-view', 'list-view');
            newsContainer.classList.add(`${viewType}-view`);
            
            // 保存用户偏好
            localStorage.setItem('preferred-view', viewType);
        });
    });
    
    // 恢复用户的视图偏好
    const preferredView = localStorage.getItem('preferred-view') || 'grid';
    console.log('Preferred view:', preferredView);
    const preferredButton = document.querySelector(`[data-view="${preferredView}"]`);
    if (preferredButton) {
        preferredButton.click();
    }
}); 