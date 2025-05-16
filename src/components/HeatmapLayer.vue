<template>
</template>

<script>
import { ref, watch, onMounted, onUnmounted } from 'vue';
import L from 'leaflet';
import 'leaflet.heat';

export default {
  name: 'HeatmapLayer',
  props: {
    // 地图对象
    map: {
      type: Object,
      required: true
    },
    // 组合数据 - 包含所有选定类型的数据
    data: {
      type: Array,
      default: () => [],
      validator: (value) => {
        // 验证数据结构
        return Array.isArray(value) && value.every(item => 
          typeof item.lat === 'number' && typeof item.lng === 'number'
        );
      }
    },
    // 是否显示热力图
    showHeatmap: {
      type: Boolean,
      default: false
    },
    // 最大缩放级别
    maxZoom: {
      type: Number,
      default: 20
    },
    // 热力图配置参数（从父组件传入）
    heatmapConfig: {
      type: Object,
      default: () => ({
        radius: 25,         // 调整默认半径
        blur: 20,          // 调整默认模糊
        intensity: 2.5,    // 增加默认强度
        maxThreshold: 6    // 降低阈值，更容易出现红色
      }),
      validator: (value) => {
        return value && 
               typeof value.radius === 'number' && 
               typeof value.blur === 'number' && 
               typeof value.intensity === 'number' && 
               typeof value.maxThreshold === 'number';
      }
    }
  },
  emits: ['update:showHeatmap', 'legend-update'],
  setup(props, { emit }) {
    // 本地状态
    const heatmapLayer = ref(null);
    
    // 监听外部显示热力图变化
    watch(() => props.showHeatmap, (newVal) => {
      if (newVal) {
        createHeatmap();
      } else {
        removeHeatmap();
      }
    });
    
    // 监听数据变化
    watch(() => props.data, () => {
      if (props.showHeatmap) {
        createHeatmap();
      }
    }, { deep: true });
    
    // 监听配置参数变化
    watch(() => props.heatmapConfig, () => {
      if (props.showHeatmap) {
        createHeatmap();
      }
    }, { deep: true });
    
    // 移除热力图
    const removeHeatmap = () => {
      if (heatmapLayer.value && props.map) {
        props.map.removeLayer(heatmapLayer.value);
        heatmapLayer.value = null;
      }
    };
    
    // 检查坐标有效性
    const isValidCoordinate = (lat, lng) => {
      return lat && lng && !isNaN(lat) && !isNaN(lng);
    };
    
    // 创建热力图
    const createHeatmap = () => {
      if (!props.map) {
        console.error('Map not initialized, cannot create heatmap');
        return;
      }
      
      // 先移除现有热力图
      removeHeatmap();
      
      // 热力图数据点
      let heatData = [];
      
      // 统计有效数据点
      let validPoints = 0;
      
      // 处理传入的数据
      if (Array.isArray(props.data) && props.data.length > 0) {
        props.data.forEach(item => {
          if (isValidCoordinate(item.lat, item.lng)) {
            // 增加每个点的权重，使热力图更明显
            heatData.push([item.lat, item.lng, props.heatmapConfig.intensity * 1.2]);
            validPoints++;
          }
        });
      }
      
      // 优化的动态最大值算法 - 让热力图效果更强
      const dynamicMax = Math.max(
        props.heatmapConfig.intensity * 1.2,    // 降低基础乘数
        Math.ceil(heatData.length / (props.heatmapConfig.maxThreshold * 2))  // 提高阈值影响
      );
      
      // 热力图配置 - 增强版本
      const config = {
        radius: props.heatmapConfig.radius,
        blur: props.heatmapConfig.blur,
        maxZoom: props.maxZoom,
        max: dynamicMax,
        minOpacity: 0.3,  // 提高最小透明度
        gradient: {       // 使用更鲜艳的渐变色
          0.05: 'rgba(0, 0, 128, 0.2)',    // 深蓝色
          0.15: 'blue',
          0.25: 'rgba(0, 150, 255, 0.7)',  // 天蓝色
          0.35: 'cyan',
          0.45: 'rgba(0, 255, 0, 0.9)',    // 绿色
          0.55: 'yellow',
          0.65: 'orange',
          0.75: 'rgba(255, 69, 0, 0.95)',  // 橙红色
          0.85: 'red',
          0.95: 'darkred',
          1.0: 'maroon'                    // 深红色
        }
      };
      
      // 打印热力图数据统计
      console.log('Enhanced Heatmap data statistics:', {
        'Total data points': heatData.length,
        'Valid data points': validPoints,
        'Heatmap configuration': config,
        'Calculated max': dynamicMax,
        'Effective radius': props.heatmapConfig.radius,
        'Effective blur': props.heatmapConfig.blur
      });
      
      // 创建热力图图层
      if (heatData.length > 0) {
        heatmapLayer.value = L.heatLayer(heatData, config).addTo(props.map);
        console.log('Enhanced heatmap created successfully');
      } else {
        console.warn('No data points available to create heatmap');
      }
      
      // 通知图例更新
      emit('legend-update');
    };
    
    // 初始化
    onMounted(() => {
      if (props.showHeatmap) {
        createHeatmap();
      }
    });
    
    // 清理
    onUnmounted(() => {
      removeHeatmap();
    });
    
    // 返回用于父组件访问的方法（如果需要）
    return {
      createHeatmap,
      removeHeatmap
    };
  }
};
</script>

<style scoped>
</style>