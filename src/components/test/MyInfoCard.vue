<template>
  <div :class="['my-info-card', colorClass]" data-aos="fade-up">
    <!-- 图片容器: 现在更大，并且是圆角正方形 -->
    <div class="info-card-image-wrapper">
      <!-- :src 直接绑定到父组件传递的 imagePath -->
      <img :src="imagePath" :alt="title" class="info-card-image">
    </div>
    <h3 class="info-card-title">{{ title }}</h3>
    <p class="info-card-description">{{ description }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue';

// Props 定义: 接收 title, description, 完整的 imagePath, colorAccent
const props = defineProps({
  title: { type: String, required: true },
  description: { type: String, required: true },
  imagePath: { type: String, required: true }, // 接收像 "/444.jpg" 这样的完整路径
  colorAccent: { type: String, default: 'primary' }
});

// 计算颜色类名
const colorClass = computed(() => `accent-${props.colorAccent}`);

</script>

<style scoped>
/* --- 卡片样式 --- */
.my-info-card {
  background-color: #ffffff;
  padding: 1.5rem;
  /* 卡片本身的圆角可以稍微调整以匹配图片圆角，可选 */
  border-radius: 20px; 
  box-shadow: 0 8px 25px rgba(0, 0, 0, 0.07);
  text-align: center;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  border: 1px solid #f0f0f0;
  display: flex;
  flex-direction: column;
  align-items: center;
  position: relative;
  overflow: hidden;
}
.my-info-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 35px rgba(0, 0, 0, 0.1);
}

/* 添加左侧彩色边框/阴影 */
.my-info-card::before {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  height: 100%;
  width: 6px;
  border-top-left-radius: 20px;
  border-bottom-left-radius: 20px;
  transition: all 0.3s ease;
}

/* 为每种颜色风格设置对应的左侧彩色边 */
.my-info-card.accent-primary::before {
  background-color: #88bf10;
  box-shadow: 0 0 15px rgba(12, 166, 120, 0.4);
}

.my-info-card.accent-secondary::before {
  background-color: #c76d0c;
  box-shadow: 0 0 15px rgba(255, 166, 0, 0.4);
}

.my-info-card.accent-tertiary::before {
  background-color: #ff4000;
  box-shadow: 0 0 15px rgba(247, 103, 7, 0.4);
}

/* 图片容器 - 改动点: 尺寸变大，添加圆角 */
.info-card-image-wrapper {
  margin-bottom: 1.8rem; /* 可以稍微增加与标题的间距 */
  width: 150px;         /* 宽度增大 */
  height: 150px;        /* 高度增大 (保持正方形) */
  overflow: hidden;
  border-radius: 16px;  /* 设置圆角，数值可调整 */
  background-color: #f0f0f0; /* 图片加载失败/过程中的背景色 */
}

/* 图片本身样式 */
.info-card-image {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover; /* 保持图片比例，填满容器 */
}

/* 标题样式 */
.info-card-title {
  font-size: 1.25rem; /* 标题大小可微调 */
  font-weight: 600;
  margin-bottom: 0.6rem;
  color: #343a40;
}
.my-info-card.accent-primary h3 {
   color: #88bf10; 
}
.my-info-card.accent-secondary h3 {
   color: #c76d0c; 
}
.my-info-card.accent-tertiary h3 {
   color: #ff4000; 
}

/* 描述样式 */
.info-card-description {
  font-size: 0.95rem; /* 描述文字大小可微调 */
  color: #6c757d;
  margin-bottom: 0;
  flex-grow: 1;
  line-height: 1.6; /* 调整行高使阅读更舒适 */
}
.visually-hidden { /* ... */ }
</style>