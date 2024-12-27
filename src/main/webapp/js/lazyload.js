document.addEventListener("DOMContentLoaded", function() {
    const lazyImages = document.querySelectorAll("img.lazy");
    const imageOptions = {
        threshold: 0,
        rootMargin: "100px 0px"
    };

    function loadImage(img) {
        const src = img.dataset.src;
        if (!src) return;

        img.style.opacity = '0.5';
        
        const newImg = new Image();
        newImg.onload = function() {
            img.src = src;
            img.style.opacity = '1';
            img.classList.remove("lazy");
            const overlay = img.parentElement.querySelector('.placeholder-overlay');
            if (overlay) {
                overlay.style.opacity = '0';
                setTimeout(() => overlay.remove(), 300);
            }
        };
        newImg.onerror = function() {
            img.src = `${pageContext.request.contextPath}/images/default.jpg`;
            img.style.opacity = '1';
            img.classList.remove("lazy");
            const overlay = img.parentElement.querySelector('.placeholder-overlay');
            if (overlay) overlay.remove();
        };
        newImg.src = src;
    }

    function loadInitialImages() {
        const viewHeight = window.innerHeight;
        lazyImages.forEach(img => {
            const rect = img.getBoundingClientRect();
            if (rect.top < viewHeight + 100) {
                loadImage(img);
            }
        });
    }

    if ("IntersectionObserver" in window) {
        const imageObserver = new IntersectionObserver((entries, observer) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    loadImage(img);
                    observer.unobserve(img);
                }
            });
        }, imageOptions);

        loadInitialImages();
        lazyImages.forEach(img => {
            if (img.classList.contains('lazy')) {
                imageObserver.observe(img);
            }
        });
    } else {
        loadInitialImages();
        let lazyLoadThrottleTimeout;
        function lazyLoad() {
            if (lazyLoadThrottleTimeout) {
                clearTimeout(lazyLoadThrottleTimeout);
            }
            lazyLoadThrottleTimeout = setTimeout(() => {
                const scrollTop = window.pageYOffset;
                lazyImages.forEach(img => {
                    if (img.classList.contains('lazy')) {
                        if (img.offsetTop < (window.innerHeight + scrollTop + 100)) {
                            loadImage(img);
                        }
                    }
                });
            }, 20);
        }
        window.addEventListener('scroll', lazyLoad);
        window.addEventListener('resize', lazyLoad);
    }
}); 