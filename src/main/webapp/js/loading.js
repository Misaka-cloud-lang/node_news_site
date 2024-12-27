// 添加加载进度条
const loadingBar = document.createElement('div');
loadingBar.className = 'loading-bar';
document.body.appendChild(loadingBar);

window.addEventListener('load', () => {
    loadingBar.style.width = '100%';
    setTimeout(() => {
        loadingBar.style.display = 'none';
    }, 300);
});

document.addEventListener('DOMContentLoaded', () => {
    loadingBar.style.width = '60%';
}); 