const observers = new WeakMap();

const scrollSlideDirective = {
  mounted(el, binding) {
    const direction = binding.arg || 'left';
    const slideClass = direction === 'right' ? 'slide-in-right' : 'slide-in-left';

    el.classList.add('animate-on-scroll', slideClass);

    const observerOptions = {
      root: null,
      rootMargin: '0px',
      threshold: 0.1
    };

    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          el.classList.add('is-visible');
          observer.unobserve(el);
          observers.delete(el);
        }
      });
    }, observerOptions);

    observer.observe(el);
    observers.set(el, observer);
  },

  unmounted(el) {
    if (observers.has(el)) {
      observers.get(el).disconnect();
      observers.delete(el);
    }
  }
};

export default scrollSlideDirective;