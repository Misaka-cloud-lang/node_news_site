// 预加载下一页的图片
function preloadNextImages() {
    const nextPageImages = document.querySelectorAll('img[data-preload]');
    nextPageImages.forEach(img => {
        const src = img.getAttribute('data-preload');
        if (src) {
            new Image().src = src;
        }
    });
}

// 监听滚动事件，当接近底部时预加载下一页图片
let isPreloading = false;
window.addEventListener('scroll', () => {
    if (isPreloading) return;
    
    const scrollPosition = window.innerHeight + window.pageYOffset;
    const pageBottom = document.documentElement.offsetHeight - 1000; // 提前1000px开始预加载
    
    if (scrollPosition >= pageBottom) {
        isPreloading = true;
        preloadNextImages();
    }
}); 