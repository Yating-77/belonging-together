// src/directives/scrollSlide.js

// 使用 WeakMap 来存储 IntersectionObserver 实例，方便在元素卸载时清理
const observers = new WeakMap();

const scrollSlideDirective = {
  // Vue 3 使用 'mounted' (替代 Vue 2 的 'bind')
  mounted(el, binding) {
    // 从指令的参数 (arg) 获取方向 (例如 v-scroll-slide:left 中的 'left')
    const direction = binding.arg || 'left'; // 如果没有提供参数，默认从左边滑入
    const slideClass = direction === 'right' ? 'slide-in-right' : 'slide-in-left';

    // 给元素添加基础动画类和特定方向的类
    el.classList.add('animate-on-scroll', slideClass);

    // IntersectionObserver 的配置选项
    const observerOptions = {
      root: null, // 相对于浏览器视口
      rootMargin: '0px',
      threshold: 0.1 // 元素可见性达到 10% 时触发回调
    };

    // 创建 IntersectionObserver 实例
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        // 当元素进入视口时 (isIntersecting 为 true)
        if (entry.isIntersecting) {
          // 添加 'is-visible' 类来触发 CSS 中定义的动画
          el.classList.add('is-visible');

          // 可选: 让动画只触发一次，触发后停止观察该元素
          observer.unobserve(el);
          // 从 WeakMap 中移除，因为不再需要了
          observers.delete(el);
        }
        // 可选: 如果希望元素离开视口后再次隐藏并能重复触发动画
        // else {
        //   el.classList.remove('is-visible');
        // }
      });
    }, observerOptions);

    // 开始观察目标元素
    observer.observe(el);
    // 将 observer 实例存入 WeakMap，键是元素本身
    observers.set(el, observer);
  },

  // Vue 3 使用 'unmounted' (替代 Vue 2 的 'unbind')
  unmounted(el) {
    // 组件卸载时进行清理，断开观察，防止内存泄漏
    if (observers.has(el)) {
      observers.get(el).disconnect();
      observers.delete(el); // 从 WeakMap 中删除
    }
  }
};

// 导出指令对象
export default scrollSlideDirective;