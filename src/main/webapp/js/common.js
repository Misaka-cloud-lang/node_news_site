// 更新时间日期
function updateDateTime() {
    const now = new Date();
    const dateOptions = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
    const timeOptions = { hour: '2-digit', minute: '2-digit', second: '2-digit' };
    
    document.getElementById('currentDate').textContent = now.toLocaleDateString('zh-CN', dateOptions);
    document.getElementById('currentTime').textContent = now.toLocaleTimeString('zh-CN', timeOptions);
}

// 导航栏滚动效果
function initNavbarScroll() {
    window.addEventListener('scroll', function() {
        const navbar = document.querySelector('.navbar');
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    });
}

// 初始化函数
function initCommon() {
    updateDateTime();
    setInterval(updateDateTime, 1000);
    initNavbarScroll();
}

// 页面加载完成后执行
document.addEventListener('DOMContentLoaded', initCommon); 