<template>
  <div class="demo-container">
    <h1>北京医院与学校资源分布</h1>
    <p class="description">展示北京地区医院与学校的地理分布，鼠标悬停可查看详细信息</p>
    
    <div class="map-container">
      <div id="resource-map" ref="mapContainer"></div>
      <div class="map-controls">
        <div class="resource-type">
          <label>
            <input type="radio" v-model="selectedType" value="schools" @change="changeResourceType">
            学校
          </label>
          <label>
            <input type="radio" v-model="selectedType" value="hospitals" @change="changeResourceType">
            医院
          </label>
          <label>
            <input type="radio" v-model="selectedType" value="all" @change="changeResourceType">
            所有资源
          </label>
        </div>
        
        <div class="heatmap-toggle">
          <label>
            <input type="checkbox" v-model="showHeatmap" @change="toggleHeatmap">
            显示热力图
          </label>
        </div>
      </div>
    </div>
    
    <div class="stats-panel">
      <div class="stat-card">
        <h3>学校总数</h3>
        <div class="stat-number">{{ schoolsData.length }}</div>
      </div>
      <div class="stat-card">
        <h3>医院总数</h3>
        <div class="stat-number">{{ hospitalsData.length }}</div>
      </div>
      <div class="stat-card">
        <h3>资源总数</h3>
        <div class="stat-number">{{ schoolsData.length + hospitalsData.length }}</div>
      </div>
    </div>
    
    <div class="instructions">
      <h3>使用说明:</h3>
      <ul>
        <li>蓝色圆点表示学校，红色圆点表示医院</li>
        <li>鼠标悬停在点位上可查看详细信息</li>
        <li>使用右上角的单选按钮切换显示学校、医院或所有资源</li>
        <li v-if="showHeatmap">热力图展示资源密度：红色表示高密度，蓝色表示低密度</li>
      </ul>
    </div>
  </div>
</template>

<script>
import { onMounted, ref, watch } from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

export default {
  name: 'BeijingResourcesMap',
  setup() {
    // 响应式引用
    const mapContainer = ref(null);
    const map = ref(null);
    const selectedType = ref('all');
    const showHeatmap = ref(false);
    
    // 热力图层引用
    const heatmapLayer = ref(null);
    
    // 缩放级别常量
    const zoomLevels = {
      max: 15,
      min: 10
    };

    // 模拟数据 - 北京的学校
    const schoolsData = ref([
      {
        name: "北京大学附属中学",
        address: "北京市海淀区中关村北大街126号",
        phone: "010-62751351",
        type: "重点中学",
        lat: 39.9869,
        lng: 116.3058
      },
      {
        name: "清华大学附属中学",
        address: "北京市海淀区中关村东路81号",
        phone: "010-62783371",
        type: "重点中学",
        lat: 40.0036,
        lng: 116.3317
      },
      {
        name: "北京师范大学附属实验中学",
        address: "北京市西城区新街口外大街19号",
        phone: "010-62208156",
        type: "重点中学",
        lat: 39.9473,
        lng: 116.3609
      },
      {
        name: "北京市第四中学",
        address: "北京市西城区西黄城根北街甲18号",
        phone: "010-66176362",
        type: "普通中学",
        lat: 39.9286,
        lng: 116.3833
      },
      {
        name: "北京市第二中学",
        address: "北京市西城区西直门内大街马甸前街2号",
        phone: "010-66128534",
        type: "普通中学",
        lat: 39.9527,
        lng: 116.3675
      }
    ]);

    // 模拟数据 - 北京的医院
    const hospitalsData = ref([
      {
        name: "北京协和医院",
        address: "北京市东城区帅府园1号",
        phone: "010-69156114",
        type: "综合医院",
        lat: 39.9133,
        lng: 116.4177
      },
      {
        name: "北京大学第一医院",
        address: "北京市西城区西什库大街8号",
        phone: "010-83572211",
        type: "综合医院",
        lat: 39.9266,
        lng: 116.3650
      },
      {
        name: "北京天坛医院",
        address: "北京市丰台区南四环西路119号",
        phone: "010-59976666",
        type: "专科医院",
        lat: 39.8651,
        lng: 116.3906
      },
      {
        name: "北京儿童医院",
        address: "北京市西城区南礼士路56号",
        phone: "010-59616161",
        type: "儿科医院",
        lat: 39.9075,
        lng: 116.3678
      },
      {
        name: "北京安贞医院",
        address: "北京市朝阳区安贞路2号",
        phone: "010-64456218",
        type: "心脏专科医院",
        lat: 39.9778,
        lng: 116.4007
      }
    ]);

    // 初始化地图
    const initMap = () => {
      // 确保DOM已经渲染
      setTimeout(() => {
        try {
          // 初始化地图
          map.value = L.map('resource-map', {
            center: [39.9042, 116.4074], // 北京中心
            zoom: 12,
            minZoom: zoomLevels.min,
            maxZoom: zoomLevels.max,
            scrollWheelZoom: true,
            doubleClickZoom: true,
            zoomDelta: 0.5,
            zoomSnap: 0.5
          });

          // 添加底图
          L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; OpenStreetMap contributors',
            maxZoom: zoomLevels.max
          }).addTo(map.value);

          // 初始显示所有点位
          displayAllPoints();
          
          // 添加图例
          addLegend();
          
          // 初始适应所有点位
          fitMapToBounds();
          
          // 添加地图缩放事件监听器
          map.value.on('zoomend', () => {
            // 缩放后重新渲染点位，以调整大小
            displayAllPoints();
          });
          
          // 添加地图移动结束事件监听器
          map.value.on('moveend', () => {
            // 更新点位工具提示方向
            if (window.markersLayer) {
              window.markersLayer.eachLayer(layer => {
                if (layer._tooltip) {
                  layer._tooltip.setContent(layer._tooltip._content);
                }
              });
            }
          });
        } catch (error) {
          console.error('初始化地图出错:', error);
        }
      }, 100);
    };

    // 添加图例
    const addLegend = () => {
      if (!map.value) return;
      
      // 移除现有图例
      const existingLegend = document.querySelector('.info.legend');
      if (existingLegend) {
        existingLegend.remove();
      }
      
      // 创建图例
      const legend = L.control({position: 'bottomright'});
      
      legend.onAdd = function (map) {
        const div = L.DomUtil.create('div', 'info legend');
        
        // 添加点位图例
        div.innerHTML = `
          <h4>点位说明</h4>
          <div style="margin-bottom:5px;">
            <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#3388ff;border:1px solid white;"></span>
            <span style="margin-left:5px;">学校</span>
          </div>
          <div style="margin-bottom:5px;">
            <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:#ff3333;border:1px solid white;"></span>
            <span style="margin-left:5px;">医院</span>
          </div>
        `;
        
        // 添加热力图图例
        if (showHeatmap.value) {
          div.innerHTML += `
            <h4 style="margin-top:10px;">热力图</h4>
            <div style="margin-bottom:3px;display:flex;align-items:center;">
              <div style="width:50px;height:10px;background:linear-gradient(to right, blue, cyan, lime, yellow, red);"></div>
              <span style="margin-left:5px;font-size:12px;">资源密度</span>
            </div>
          `;
        }
        
        return div;
      };

      legend.addTo(map.value);
    };

    // 显示点位
    const displayAllPoints = () => {
      if (!map.value) return;
      
      let markers = [];
      
      // 获取当前缩放级别，用于调整点位大小
      const zoom = map.value.getZoom();
      const baseSize = 10; // 基础大小
      // 根据缩放级别动态调整点位大小
      const scaleFactor = zoom >= 13 ? 1.5 : 
                          zoom >= 11 ? 1.2 : 
                          zoom < 9 ? 0.7 : 1;
      const pointSize = baseSize * scaleFactor;
      const borderSize = 2 * scaleFactor;
      
      // 创建标记的通用函数
      const createMarker = (item, color, tooltipContent) => {
        // 使用缩放级别调整点位大小
        const marker = L.marker([item.lat, item.lng], {
          icon: L.divIcon({
            className: 'custom-div-icon',
            html: `<div style="background-color:${color};width:${pointSize}px;height:${pointSize}px;border-radius:50%;border:${borderSize}px solid white;"></div>`,
            iconSize: [pointSize + borderSize*2, pointSize + borderSize*2],
            iconAnchor: [(pointSize + borderSize*2)/2, (pointSize + borderSize*2)/2]
          }),
          riseOnHover: true // 鼠标悬停时提高标记层级
        });
        
        // 动态调整工具提示的方向
        const getTooltipDirection = () => {
          const bounds = map.value.getBounds();
          const center = map.value.getCenter();
          
          // 根据点位相对于地图中心的位置决定工具提示方向
          if (item.lat > center.lat) {
            return item.lng > center.lng ? 'left' : 'right';
          } else {
            return 'top';
          }
        };
        
        marker.bindTooltip(tooltipContent, {
          direction: getTooltipDirection(),
          permanent: false,
          className: 'custom-tooltip',
          offset: [0, -pointSize/2],
          opacity: 0.9,
          sticky: true // 使工具提示跟随鼠标
        });
        
        return marker;
      };
      
      // 添加学校点位
      if (selectedType.value === 'schools' || selectedType.value === 'all') {
        schoolsData.value.forEach(school => {
          const tooltipContent = `
            <div class="tooltip-content">
              <h3>${school.name}</h3>
              <div class="tooltip-details">
                <p><strong>地址:</strong> ${school.address}</p>
                <p><strong>电话:</strong> ${school.phone}</p>
                <p><strong>类型:</strong> ${school.type}</p>
              </div>
            </div>
          `;
          
          markers.push(createMarker(school, '#3388ff', tooltipContent));
        });
      }
      
      // 添加医院点位
      if (selectedType.value === 'hospitals' || selectedType.value === 'all') {
        hospitalsData.value.forEach(hospital => {
          const tooltipContent = `
            <div class="tooltip-content">
              <h3>${hospital.name}</h3>
              <div class="tooltip-details">
                <p><strong>地址:</strong> ${hospital.address}</p>
                <p><strong>电话:</strong> ${hospital.phone}</p>
                <p><strong>类型:</strong> ${hospital.type}</p>
              </div>
            </div>
          `;
          
          markers.push(createMarker(hospital, '#ff3333', tooltipContent));
        });
      }
      
      // 添加标记到地图
      if (markers.length > 0) {
        // 移除已有的点位图层
        if (window.markersLayer && map.value) {
          map.value.removeLayer(window.markersLayer);
        }
        
        window.markersLayer = L.layerGroup(markers);
        window.markersLayer.addTo(map.value);
      }
      
      // 更新热力图
      updateHeatmap();
    };

    // 切换资源类型
    const changeResourceType = () => {
      if (map.value) {
        displayAllPoints();
        // 确保在DOM更新后执行fitMapToBounds
        setTimeout(() => {
          fitMapToBounds();
        }, 100);
      }
    };
    
    // 自动调整地图视图
    const fitMapToBounds = () => {
      if (!map.value) return;
      
      // 获取当前显示的点位
      let allPoints = [];
      
      if (selectedType.value === 'schools' || selectedType.value === 'all') {
        allPoints = [...allPoints, ...schoolsData.value];
      }
      
      if (selectedType.value === 'hospitals' || selectedType.value === 'all') {
        allPoints = [...allPoints, ...hospitalsData.value];
      }
      
      if (allPoints.length === 0) return;
      
      // 计算边界并缩放地图
      const bounds = L.latLngBounds(allPoints.map(point => [point.lat, point.lng]));
      
      // 确保边界有效
      if (bounds.isValid()) {
        // 使用更适合的参数设置
        map.value.fitBounds(bounds, {
          padding: [80, 80], // 增加padding确保所有点都在视图内
          maxZoom: 13,
          animate: true,
          duration: 0.5 // 添加动画持续时间
        });
      } else {
        // 如果边界无效，回到默认视图
        map.value.setView([39.9042, 116.4074], 12);
      }
    };
    
    // 更新热力图
    const updateHeatmap = () => {
      if (!map.value) return;
      
      // 删除旧的热力图层
      if (heatmapLayer.value && map.value.hasLayer(heatmapLayer.value)) {
        map.value.removeLayer(heatmapLayer.value);
      }
      
      // 如果不显示热力图，直接返回
      if (!showHeatmap.value) return;
      
      // 创建热力图数据
      let heatData = [];
      
      if (selectedType.value === 'schools' || selectedType.value === 'all') {
        schoolsData.value.forEach(school => {
          heatData.push([school.lat, school.lng, 0.5]); // 第三个参数是强度
        });
      }
      
      if (selectedType.value === 'hospitals' || selectedType.value === 'all') {
        hospitalsData.value.forEach(hospital => {
          heatData.push([hospital.lat, hospital.lng, 0.7]); // 医院点位强度稍高
        });
      }
      
      // 创建热力图层
      if (heatData.length > 0) {
        heatmapLayer.value = L.heatLayer(heatData, {
          radius: 25,
          blur: 15,
          maxZoom: 17,
          max: 1.0,
          gradient: {0.4: 'blue', 0.5: 'cyan', 0.6: 'lime', 0.7: 'yellow', 1: 'red'}
        }).addTo(map.value);
      }
    };
    
    // 切换热力图显示
    const toggleHeatmap = () => {
      updateHeatmap();
      addLegend(); // 更新图例
    };
    
    // 监听显示类型变化
    watch(selectedType, () => {
      displayAllPoints();
      // 确保在DOM更新后调整地图视图
      setTimeout(() => {
        fitMapToBounds();
      }, 100);
    });
    
    // 监听热力图显示状态变化
    watch(showHeatmap, () => {
      updateHeatmap();
      addLegend();
    });
    
    // 监听地图尺寸变化，解决窗口调整大小时的问题
    window.addEventListener('resize', () => {
      if (map.value) {
        // 强制地图重新计算尺寸
        map.value.invalidateSize();
        // 在地图重新计算尺寸后调整视图
        setTimeout(() => {
          fitMapToBounds();
        }, 200);
      }
    });

    // 组件挂载时初始化
    onMounted(() => {
      initMap();
    });

    // 返回需要在模板中使用的属性和方法
    return {
      mapContainer,
      map,
      selectedType,
      showHeatmap,
      changeResourceType,
      toggleHeatmap,
      schoolsData,
      hospitalsData
    };
  }
};
</script>

<style scoped>
.demo-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  font-family: 'Arial', sans-serif;
}

h1 {
  color: #333;
  text-align: center;
  margin-bottom: 10px;
}

.description {
  text-align: center;
  color: #666;
  margin-bottom: 20px;
}

.map-container {
  position: relative;
  width: 100%;
  height: 500px;
  margin-bottom: 20px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
}

#resource-map {
  width: 100%;
  height: 100%;
  z-index: 1;
}

.map-controls {
  position: absolute;
  top: 10px;
  right: 10px;
  z-index: 2;
  background-color: rgba(255, 255, 255, 0.9);
  border-radius: 4px;
  padding: 10px;
  color: #333;
  width: 200px;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}

.resource-type {
  margin-bottom: 15px;
}

.resource-type label, .heatmap-toggle label {
  display: block;
  margin-bottom: 5px;
  cursor: pointer;
}

.stats-panel {
  display: flex;
  justify-content: space-between;
  margin-bottom: 20px;
}

.stat-card {
  background-color: #f5f5f5;
  border-radius: 8px;
  padding: 15px;
  width: 32%;
  text-align: center;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

.stat-card h3 {
  margin: 0 0 10px 0;
  font-size: 16px;
  color: #555;
}

.stat-number {
  font-size: 24px;
  font-weight: bold;
  color: #333;
}

.instructions {
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 15px;
  margin-top: 20px;
}

.instructions h3 {
  margin-top: 0;
  color: #333;
}

.instructions ul {
  padding-left: 20px;
}

.instructions li {
  margin-bottom: 5px;
  color: #555;
}

/* 全局样式 */
:global(.custom-div-icon) {
  background: none !important;
  border: none !important;
}

:global(.custom-tooltip) {
  background-color: white;
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
}

:global(.tooltip-content h3) {
  margin: 0 0 6px 0;
  color: #333;
  font-size: 16px;
  border-bottom: 1px solid #eee;
  padding-bottom: 4px;
}

:global(.tooltip-details p) {
  margin: 2px 0;
  color: #555;
  font-size: 13px;
}

:global(.info.legend) {
  padding: 6px 8px;
  font: 14px/16px Arial, Helvetica, sans-serif;
  background: white;
  background: rgba(255, 255, 255, 0.8);
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
  border-radius: 5px;
}

:global(.info h4) {
  margin: 0 0 5px;
  color: #777;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .map-container {
    height: 400px;
  }
  
  .map-controls {
    width: 150px;
  }
  
  .stat-card {
    padding: 10px;
  }
}

@media (max-width: 480px) {
  .map-container {
    height: 350px;
  }
  
  .stats-panel {
    flex-direction: column;
  }
  
  .stat-card {
    width: 100%;
    margin-bottom: 10px;
  }
}
</style>