<template>
</template>

<script>
import { ref, watch, onMounted, onUnmounted } from 'vue';
import L from 'leaflet';
import 'leaflet.heat';

export default {
  name: 'HeatmapLayer',
  props: {
    // map object
    map: {
      type: Object,
      required: true
    },
    // combined data - contains all selected types data
    data: {
      type: Array,
      default: () => [],
      validator: (value) => {
        // validate data structure
        return Array.isArray(value) && value.every(item => 
          typeof item.lat === 'number' && typeof item.lng === 'number'
        );
      }
    },
    // whether to show heatmap
    showHeatmap: {
      type: Boolean,
      default: false
    },
    // maximum zoom level
    maxZoom: {
      type: Number,
      default: 20
    },
    // heatmap configuration parameters (passed from parent component)
    heatmapConfig: {
      type: Object,
      default: () => ({
        radius: 25,         // adjust default radius
        blur: 20,          // adjust default blur
        intensity: 2.5,    // increase default intensity
        maxThreshold: 6    // reduce threshold, easier to show red
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
    // local state
    const heatmapLayer = ref(null);
    
    // watch external show heatmap change
    watch(() => props.showHeatmap, (newVal) => {
      if (newVal) {
        createHeatmap();
      } else {
        removeHeatmap();
      }
    });
    
    // watch data change
    watch(() => props.data, () => {
      if (props.showHeatmap) {
        createHeatmap();
      }
    }, { deep: true });
    
    // watch configuration parameters change
    watch(() => props.heatmapConfig, () => {
      if (props.showHeatmap) {
        createHeatmap();
      }
    }, { deep: true });
    
    // remove heatmap
    const removeHeatmap = () => {
      if (heatmapLayer.value && props.map) {
        props.map.removeLayer(heatmapLayer.value);
        heatmapLayer.value = null;
      }
    };
    
    // check coordinate validity
    const isValidCoordinate = (lat, lng) => {
      return lat && lng && !isNaN(lat) && !isNaN(lng);
    };
    
    // create heatmap
    const createHeatmap = () => {
      if (!props.map) {
        console.error('Map not initialized, cannot create heatmap');
        return;
      }
      
      // remove existing heatmap first
      removeHeatmap();
      
      // heatmap data points
      let heatData = [];
      
      // count valid data points
      let validPoints = 0;
      
      // process incoming data
      if (Array.isArray(props.data) && props.data.length > 0) {
        props.data.forEach(item => {
          if (isValidCoordinate(item.lat, item.lng)) {
            // increase weight of each point, making heatmap more obvious
            heatData.push([item.lat, item.lng, props.heatmapConfig.intensity * 1.2]);
            validPoints++;
          }
        });
      }
      
      // optimized dynamic max value algorithm - make heatmap effect stronger
      const dynamicMax = Math.max(
        props.heatmapConfig.intensity * 1.2,    // reduce base multiplier
        Math.ceil(heatData.length / (props.heatmapConfig.maxThreshold * 2))  // increase threshold impact
      );
      
      // heatmap configuration - enhanced version
      const config = {
        radius: props.heatmapConfig.radius,
        blur: props.heatmapConfig.blur,
        maxZoom: props.maxZoom,
        max: dynamicMax,
        minOpacity: 0.3,  // increase minimum opacity
        gradient: {       // use more vibrant gradient colors
          0.05: 'rgba(0, 0, 128, 0.2)',    // dark blue
          0.15: 'blue',
          0.25: 'rgba(0, 150, 255, 0.7)',  // sky blue
          0.35: 'cyan',
          0.45: 'rgba(0, 255, 0, 0.9)',    // green
          0.55: 'yellow',
          0.65: 'orange',
          0.75: 'rgba(255, 69, 0, 0.95)',  // orange
          0.85: 'red',
          0.95: 'darkred',
          1.0: 'maroon'                    // dark red
        }
      };
      
      // print heatmap data statistics
      console.log('Enhanced Heatmap data statistics:', {
        'Total data points': heatData.length,
        'Valid data points': validPoints,
        'Heatmap configuration': config,
        'Calculated max': dynamicMax,
        'Effective radius': props.heatmapConfig.radius,
        'Effective blur': props.heatmapConfig.blur
      });
      
      // create heatmap layer
      if (heatData.length > 0) {
        heatmapLayer.value = L.heatLayer(heatData, config).addTo(props.map);
        console.log('Enhanced heatmap created successfully');
      } else {
        console.warn('No data points available to create heatmap');
      }
      
      // notify legend update
      emit('legend-update');
    };
    
    // initialize
    onMounted(() => {
      if (props.showHeatmap) {
        createHeatmap();
      }
    });
    
    // cleanup
    onUnmounted(() => {
      removeHeatmap();
    });
    
    return {
      createHeatmap,
      removeHeatmap
    };
  }
};
</script>

<style scoped>
</style>