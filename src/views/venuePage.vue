<template>
  <div class="demo-container">
    <!-- Hero Banner -->
    <div class="hero-banner">
      <div class="hero-content">
        <h1 class="hero-title">Find Autism Support in Your Community</h1>
        <p class="hero-subtitle">Discover nearby special schools, therapy centres, hospitals, early intervention services, and daily living support tailored for autistic children and their families.</p>
      </div>
    </div>

    <div class="main-content">  
      <!-- Step Indicators -->
      <div class="step-indicators">
        <div :class="['step', currentStep === 'filter' ? 'active' : '']">1. Filter Resources</div>
        <div :class="['step', currentStep === 'heatmap' ? 'active' : '']">2. View Heatmap</div>
      </div>
      
      <!-- External Resource Selector - Only shown in filter step -->
      <div v-if="currentStep === 'filter'" class="external-filter-container">
        <div class="resource-filter">
          <div class="resource-type">
            <div class="type-title">Select Resource Types:</div>
            <div class="checkbox-group">
              <label v-for="(config, key) in RESOURCE_TYPES" :key="key">
                <input 
                  type="checkbox" 
                  v-model="selectedTypes[key]" 
                  @change="changeResourceType"
                >
                <span :style="{ color: config.color }">{{ config.label }}</span>
              </label>
            </div>
            <div class="quick-options">
              <button @click="selectAll">Select All</button>
              <button @click="selectNone">Clear All</button>
            </div>
            
            <!-- Confirm Filter Button -->
            <div class="confirm-section">
              <button 
                class="confirm-button" 
                @click="goToHeatmap"
                :disabled="!hasSelectedAnyType"
              >
                Confirm Filter and View Heatmap
              </button>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Heatmap Control Panel - Only shown in heatmap step -->
      <div v-if="currentStep === 'heatmap'" class="external-filter-container">
        <div class="resource-type">
          <div class="back-navigation-inline">
            <a href="#" @click.prevent="backToFiltering" class="back-link">
              <span class="arrow">←</span> Back to Filter
            </a>
          </div>
          
          <!-- Location Density Search Component -->
          <LocationDensitySearch
            :map="map"
            :all-types-selected="isAllTypesSelected"
            :resource-data="resourceData"
            v-model:loading="isLoading"
            :selected-types="confirmedTypes"
            ref="densitySearchRef"
          />
        </div>
      </div>
      
      <!-- Map Container with Heatmap Controls Overlay -->
      <div class="map-container">
        <div id="resource-map" ref="mapContainer"></div>
        
        <!-- Loading Animation Overlay -->
        <div v-if="isLoading" class="loading-overlay">
          <div class="loading-spinner"></div>
          <div class="loading-text">Loading Resources...</div>
        </div>
        
       
        <div v-if="currentStep === 'heatmap'" class="heatmap-controls-overlay">
          <div class="heatmap-controls-header">
            <h3>Heatmap Controls</h3>
            <button class="minimize-btn" @click="toggleControlsMinimized">
              {{ controlsMinimized ? '▼' : '▲' }}
            </button>
          </div>
          
          <div v-show="!controlsMinimized" class="heatmap-controls-content">
            <div class="heatmap-toggle">
              <label class="switch">
                <input type="checkbox" v-model="showHeatmap">
                <span class="slider round"></span>
              </label>
              <span class="toggle-label">{{ showHeatmap ? 'Hide Heatmap' : 'Show Heatmap' }}</span>
            </div>
            
            <div v-if="showHeatmap" class="heatmap-settings">
             
              <div class="setting-item">
                <label>Hotspot Radius:</label>
                <input type="range" min="15" max="40" v-model.number="heatmapParams.radius" @change="updateHeatmapParams">
                <span class="setting-value">{{ heatmapParams.radius }}</span>
              </div>
              
        
              <div class="setting-item">
                <label>Blur Level:</label>
                <input type="range" min="20" max="35" v-model.number="heatmapParams.blur" @change="updateHeatmapParams">
                <span class="setting-value">{{ heatmapParams.blur }}</span>
              </div>
              
              <button class="reset-btn" @click="resetHeatmapParams">Reset Settings</button>
            </div>
          </div>
        </div>
        

        <HeatmapLayer
          v-if="map && currentStep === 'heatmap'"
          :map="map"
          :data="heatmapData"
          :show-heatmap="showHeatmap"
          :max-zoom="maxZoomLevel"
          :heatmap-config="heatmapParams"
          @legend-update="updateLegend"
        />
      </div>
      
      <div class="stats-panel">
        <div class="stat-card">
          <h3>Total Schools</h3>
          <div class="stat-number">{{ schoolsData.length }}</div>
        </div>
        <div class="stat-card">
          <h3>Total Hospitals</h3>
          <div class="stat-number">{{ hospitalsData.length }}</div>
        </div>
        <div class="stat-card">
          <h3>NDIS Early Intervention</h3>
          <div class="stat-number">{{ ndisProvidersData.length }}</div>
        </div>
        <div class="stat-card">
          <h3>NDIS Daily Living</h3>
          <div class="stat-number">{{ ndisDailyLivingData.length }}</div>
        </div>
        <div class="stat-card">
          <h3>NDIS Therapy Services</h3>
          <div class="stat-number">{{ ndisTherapyData.length }}</div>
        </div>
        <div class="stat-card">
          <h3>Total Resources</h3>
          <div class="stat-number">{{ schoolsData.length + hospitalsData.length + ndisProvidersData.length + ndisDailyLivingData.length + ndisTherapyData.length }}</div>
        </div>
      </div>
      
      <div class="instructions">
        <h3>Usage Instructions:</h3>
        <ul>
          <li>Blue dots represent special schools, red dots represent hospitals, green dots represent NDIS early intervention, purple dots represent NDIS daily living support, and orange dots represent NDIS therapy services</li>
          <li>Check the boxes above to display multiple types of resources simultaneously</li>
          <li>Hover over a point to view detailed information</li>
          <li v-if="showHeatmap">The heatmap shows resource density: red indicates high density, blue indicates low density</li>
          <li v-if="currentStep === 'filter'">After completing resource selection, click "Confirm Filter and View Heatmap" to enter heatmap view mode</li>
          <li v-if="currentStep === 'heatmap'">In heatmap mode, you can use the heatmap toggle to show or hide the heatmap</li>
          <li v-if="currentStep === 'heatmap'">In heatmap mode, the currently displayed resource types are locked and cannot be changed</li>
          <li v-if="currentStep === 'heatmap'">Use the location density search feature to search for specific addresses or coordinates and view resource distribution in the area</li>
          <li v-if="currentStep === 'heatmap'">Location density search requires all resource types to be selected to function</li>
          <li v-if="currentStep === 'heatmap'">Click "Back to Filter" to return to the filter interface and reselect resource types</li>
          <li v-if="currentStep === 'heatmap'">Use the heatmap controls on the map to adjust heatmap parameters: Adjusting Hotspot Radius controls the size of influence area for each resource point, adjusting Blur Level makes the heatmap appear smoother or clearer</li>
        </ul>
      </div>
      
      <div v-if="dataLoadError" class="error-message">
        <p>{{ dataLoadError }}</p>
      </div>
    </div>
  </div>
</template>
<script>
import { onMounted, ref, onUnmounted, reactive, watch, computed } from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import HeatmapLayer from '../components/HeatmapLayer.vue';
import LocationDensitySearch from '../components/LocationDensitySearch.vue';
import { loadAllData } from '../services/dataLoader.js';

import { 
  RESOURCE_TYPES,
  createFilterState,
  hasSelectedAnyType,
  isAllTypesSelected,
  selectAllTypes,
  selectNoneTypes,
  toggleResourceType,
  copyFilterState,
  getSelectedTypeConfigs,
  getDataByFilters,
  getFilterStatistics,
  validateFilterState,
  saveFilterState,
  loadFilterState
} from '../services/resourceFilters.js';

export default {
  name: 'MelbourneDistrictsMap',
  components: {
    HeatmapLayer,
    LocationDensitySearch
  },
  setup() {
    // Create reactive references
    const mapContainer = ref(null);
    const map = ref(null);
    const dataLoadError = ref('');
    const showHeatmap = ref(false);
    const isLoading = ref(false);
    const densitySearchRef = ref(null);
    
    // Step control
    const currentStep = ref('filter'); // 'filter' or 'heatmap'
    
    // 热力图控制器状态
    const controlsMinimized = ref(false);
    
    // 热力图参数状态
    const heatmapParams = reactive({
      radius: 25,
      blur: 35,
      intensity: 1.5,
      maxThreshold: 10
    });
    
    // 热力图参数的默认值（用于重置）
    const defaultHeatmapParams = {
      radius: 25,
      blur: 35,
      intensity: 1.5,
      maxThreshold: 10
    };
    
    // Multi-select types - current filter selection (using new filtering logic)
    const selectedTypes = reactive(loadFilterState()); // Load from local storage
    
    // Confirmed filter conditions - used for heatmap
    const confirmedTypes = reactive(createFilterState());
    
    // Computed property: whether any type is selected
    const hasSelectedAnyTypeComputed = computed(() => {
      return hasSelectedAnyType(selectedTypes);
    });
    
    // Computed property: whether all types are selected
    const isAllTypesSelectedComputed = computed(() => {
      return isAllTypesSelected(confirmedTypes);
    });
    
    // Computed property: resource data object (for passing to location density query component)
    const resourceData = computed(() => {
      return {
        schools: schoolsData.value,
        hospitals: hospitalsData.value,
        ndisProviders: ndisProvidersData.value,
        ndisDailyLiving: ndisDailyLivingData.value,
        ndisTherapy: ndisTherapyData.value
      };
    });
    
    // Computed property: heatmap data (based on confirmed filter types)
    const heatmapData = computed(() => {
      const allData = {
        schoolsData: schoolsData.value,
        hospitalsData: hospitalsData.value,
        ndisProvidersData: ndisProvidersData.value,
        ndisDailyLivingData: ndisDailyLivingData.value,
        ndisTherapyData: ndisTherapyData.value
      };
      
      // Return only the data of currently confirmed selected types
      const selectedData = getDataByFilters(confirmedTypes, allData);
      
      // Combine all selected type data into a single array
      let combinedData = [];
      Object.values(selectedData).forEach(data => {
        if (Array.isArray(data)) {
          combinedData = combinedData.concat(data);
        }
      });
      
      return combinedData;
    });
    
    // 切换控制器收起/展开状态
    const toggleControlsMinimized = () => {
      controlsMinimized.value = !controlsMinimized.value;
      // 保存状态到本地存储
      try {
        localStorage.setItem('heatmapControlsMinimized', JSON.stringify(controlsMinimized.value));
      } catch (error) {
        console.error('Failed to save controls state:', error);
      }
    };
    
    // 更新热力图参数
    const updateHeatmapParams = () => {
      // 保存参数到本地存储
      try {
        localStorage.setItem('heatmapParams', JSON.stringify(heatmapParams));
      } catch (error) {
        console.error('Failed to save heatmap parameters:', error);
      }
    };
    
    // 重置热力图参数
    const resetHeatmapParams = () => {
      Object.keys(defaultHeatmapParams).forEach(key => {
        heatmapParams[key] = defaultHeatmapParams[key];
      });
      updateHeatmapParams();
    };
    
    // 初始化热力图参数和控制器状态
    const initializeHeatmapState = () => {
      try {
        // 加载热力图参数
        const savedParams = localStorage.getItem('heatmapParams');
        if (savedParams) {
          const parsed = JSON.parse(savedParams);
          Object.keys(defaultHeatmapParams).forEach(key => {
            if (parsed[key] !== undefined) {
              heatmapParams[key] = parsed[key];
            }
          });
        }
        
        // 加载控制器状态
        const savedControlsState = localStorage.getItem('heatmapControlsMinimized');
        if (savedControlsState) {
          controlsMinimized.value = JSON.parse(savedControlsState);
        }
      } catch (error) {
        console.error('Failed to load heatmap state:', error);
      }
    };
    
    // Confirm filter, enter heatmap page
    const goToHeatmap = () => {
      if (!hasSelectedAnyTypeComputed.value) {
        return; // If no type is selected, do not execute operation
      }
      
      isLoading.value = true;
      
      // Copy current selection to confirmed selection (using new filtering logic)
      const newConfirmedTypes = copyFilterState(selectedTypes, confirmedTypes);
      Object.keys(newConfirmedTypes).forEach(key => {
        confirmedTypes[key] = newConfirmedTypes[key];
      });
      
      // Save filter state to local storage
      saveFilterState(selectedTypes);
      
      // Delayed switch, show loading animation
      setTimeout(() => {
        // Set heatmap to default on
        showHeatmap.value = true;
        
        // Switch to heatmap step
        currentStep.value = 'heatmap';
        
        // Create markers using confirmed filter
        createMarkersForConfirmedTypes();
        
        // 结束加载状态
        isLoading.value = false;
      }, 500);
    };
    
    // Return to filter page
    const backToFiltering = () => {
      isLoading.value = true;
      
      // Close heatmap - explicitly set to false
      showHeatmap.value = false;
      
      // Clear location marker (if any)
      if (densitySearchRef.value && densitySearchRef.value.clearMarker) {
        densitySearchRef.value.clearMarker();
      }
      
      // Delayed switch, show loading animation
      setTimeout(() => {
        // Switch back to filter step
        currentStep.value = 'filter';
        
        // Create markers using current selection
        createMarkersForSelectedTypes();
        
        // 结束加载状态
        isLoading.value = false;
      }, 500);
    };
    
    // Toggle heatmap display state - 修复后的函数
    const toggleHeatmap = () => {
      // v-model 会自动更新 showHeatmap.value，这里不需要手动切换
      // 只需要确保图例更新即可
      console.log('Heatmap state after toggle:', showHeatmap.value);
      updateLegend();
    };
    
    // Quick select all types (using new filtering logic)
    const selectAll = () => {
      const newState = selectAllTypes(selectedTypes);
      Object.keys(newState).forEach(key => {
        selectedTypes[key] = newState[key];
      });
      createMarkersForSelectedTypes();
    };
    
    // Clear all selections (using new filtering logic)
    const selectNone = () => {
      const newState = selectNoneTypes(selectedTypes);
      Object.keys(newState).forEach(key => {
        selectedTypes[key] = newState[key];
      });
      createMarkersForSelectedTypes();
    };
    
    // Toggle individual resource type (using new filtering logic)
    const toggleResourceTypeHandler = (type) => {
      selectedTypes[type] = !selectedTypes[type];
      createMarkersForSelectedTypes();
    };
    
    // Zoom level constants - only restrict zoom out
    const zoomLevels = {
      max: 20, // Remove zoom in restrictions, set a larger value
      min: 6,  // Keep zoom out restrictions
      minFit: 8
    };

    // Create reactive data using ref
    const schoolsData = ref([]);
    const hospitalsData = ref([]);
    const ndisProvidersData = ref([]);
    const ndisDailyLivingData = ref([]);
    const ndisTherapyData = ref([]);
    
    // Currently displayed marker layer group - using single layer group
    const currentMarkerLayer = ref(null);
    
    // Coordinate validation function
    const isValidCoordinate = (point) => {
      if (!point) return false;
      
      let lat, lng;
      
      try {
        lat = typeof point.lat === 'string' ? parseFloat(point.lat) : point.lat;
        lng = typeof point.lng === 'string' ? parseFloat(point.lng) : point.lng;
      } catch (e) {
        return false;
      }
      
      return !isNaN(lat) && !isNaN(lng) && 
             Math.abs(lat) <= 90 && Math.abs(lng) <= 180;
    };
    
    // Data preprocessing
    const preprocessAllData = () => {
      console.log('Preprocessing data...');
      
      const processPointData = (points, type) => {
        if (!Array.isArray(points)) {
          console.warn(`${type} data is not in array format`);
          return [];
        }
        
        const processed = points.map(point => {
          const newPoint = {...point};
          
          try {
            newPoint.lat = typeof point.lat === 'string' ? parseFloat(point.lat) : point.lat;
            newPoint.lng = typeof point.lng === 'string' ? parseFloat(point.lng) : point.lng;
            
            if (isNaN(newPoint.lat) || isNaN(newPoint.lng)) {
              return null;
            }
          } catch (e) {
            return null;
          }
          
          return newPoint;
        }).filter(point => point !== null && !isNaN(point.lat) && !isNaN(point.lng));
        
        console.log(`${type} data preprocessing complete: ${processed.length}/${points.length}`);
        return processed;
      };
      
      // Process each type of data
      schoolsData.value = processPointData(schoolsData.value, 'Schools');
      hospitalsData.value = processPointData(hospitalsData.value, 'Hospitals');
      ndisProvidersData.value = processPointData(ndisProvidersData.value, 'NDIS Early Intervention');
      ndisDailyLivingData.value = processPointData(ndisDailyLivingData.value, 'NDIS Daily Living Support');
      ndisTherapyData.value = processPointData(ndisTherapyData.value, 'NDIS Therapy Services');
    };
    
    // Initialize map
    const initMap = async () => {
      console.log('Initializing map...');
      isLoading.value = true;
      
      try {
        // Load data
        const result = await loadAllData();
        
        if (!result.success) {
          dataLoadError.value = result.error || 'Failed to load data';
          isLoading.value = false;
          return;
        }
        
        // Update reactive data
        schoolsData.value = result.schoolsData || [];
        hospitalsData.value = result.hospitalsData || [];
        ndisProvidersData.value = result.ndisProvidersData || [];
        ndisDailyLivingData.value = result.ndisDailyLivingData || [];
        ndisTherapyData.value = result.ndisTherapyData || [];
        
        // Data preprocessing
        preprocessAllData();
        
        // Ensure DOM has been rendered
        setTimeout(() => {
          try {
            createMap();
          } catch (error) {
            console.error('Error creating map:', error);
            dataLoadError.value = `Error creating map: ${error.message}`;
          } finally {
            isLoading.value = false;
          }
        }, 100);
      } catch (error) {
        console.error('Error loading data:', error);
        dataLoadError.value = `Error loading data: ${error.message}`;
        isLoading.value = false;
      }
    };
    
    // Create map
    const createMap = () => {
      const mapElement = document.getElementById('resource-map');
      if (!mapElement) {
        dataLoadError.value = 'Unable to initialize map, map container element not found.';
        return;
      }
      
      console.log('Creating map...');
      
      // If map already exists, destroy it first
      if (map.value) {
        map.value.remove();
        map.value = null;
      }
      
      // Initialize map
      map.value = L.map('resource-map', {
        center: [-37.815, 144.963], // Melbourne center
        zoom: 8,
        minZoom: zoomLevels.min,
        maxZoom: zoomLevels.max,
        scrollWheelZoom: true,
        doubleClickZoom: true,
        zoomAnimation: true
      });

      // Add base map
      L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
        attribution: '&copy; OpenStreetMap',
        subdomains: 'abcd',
        maxZoom: zoomLevels.max,
        tileSize: 256
      }).addTo(map.value);
      
      // Create initial layer - show all selected resource types
      createMarkersForSelectedTypes();
      
      // Add legend
      addLegend();
    };
    
    // Helper function - format URL
    const formatUrl = (url) => {
      if (!url) return '';
      let displayUrl = url.replace(/^https?:\/\//, '');
      if (displayUrl.length > 30) {
        displayUrl = displayUrl.substring(0, 27) + '...';
      }
      return displayUrl;
    };
    
    // Create markers - create markers based on selected types (for filter page)
    const createMarkersForSelectedTypes = () => {
      if (!map.value) return;
      
      console.log(`Creating markers for selected types...`, selectedTypes);
      
      isLoading.value = true;
      
      setTimeout(() => {
        try {
          createMarkers(selectedTypes);
        } catch (error) {
          console.error('Error creating markers:', error);
        } finally {
          setTimeout(() => {
            isLoading.value = false;
          }, 300);
        }
      }, 50);
    };
    
    // Create markers - create markers based on confirmed types (for heatmap page)
    const createMarkersForConfirmedTypes = () => {
      if (!map.value) return;
      
      console.log(`Creating markers for confirmed types...`, confirmedTypes);
      
      isLoading.value = true;
      
      setTimeout(() => {
        try {
          createMarkers(confirmedTypes);
        } catch (error) {
          console.error('Error creating markers:', error);
        } finally {
          setTimeout(() => {
            isLoading.value = false;
          }, 300);
        }
      }, 50);
    };
    
    // Generic marker creation function
    const createMarkers = (typeFilter) => {
      // If there's a current marker layer, remove it first
      if (currentMarkerLayer.value && map.value.hasLayer(currentMarkerLayer.value)) {
        map.value.removeLayer(currentMarkerLayer.value);
      }
      
      // Create new layer group
      currentMarkerLayer.value = L.layerGroup();
      
      // Add markers based on selection state
      let pointCount = 0;
      
      // Get all current data
      const allData = {
        schoolsData: schoolsData.value,
        hospitalsData: hospitalsData.value,
        ndisProvidersData: ndisProvidersData.value,
        ndisDailyLivingData: ndisDailyLivingData.value,
        ndisTherapyData: ndisTherapyData.value
      };
      
      // Get selected data and create markers
      const selectedData = getDataByFilters(typeFilter, allData);
      
      Object.entries(selectedData).forEach(([type, data]) => {
        const config = RESOURCE_TYPES[type];
        if (!config || !data) return;
        
        data.forEach(item => {
          if (!isValidCoordinate(item)) return;
          
          try {
            const marker = L.marker([item.lat, item.lng], {
              icon: L.divIcon({
                className: 'custom-div-icon',
                html: `<div style="background-color:${config.color};width:10px;height:10px;border-radius:50%;border:2px solid white;"></div>`,
                iconSize: [15, 15],
                iconAnchor: [7, 7]
              })
            });
            
            // Create tooltip content
            const tooltipContent = createTooltipContent(item, type);
            
            marker.bindTooltip(tooltipContent, {
              direction: 'auto',
              permanent: false,
              className: 'custom-tooltip horizontal-tooltip',
              offset: [10, 0],
              sticky: true,
              opacity: 0.9
            });
            
            // Add to current layer group
            marker.addTo(currentMarkerLayer.value);
            pointCount++;
          } catch (error) {
            console.error(`Error creating ${config.label} marker:`, error);
          }
        });
      });
      
      // Add layer group to map
      currentMarkerLayer.value.addTo(map.value);
      console.log(`Created ${pointCount} markers`);
      
      // Adjust view to show all markers
      fitToCurrentMarkers();
    };
    
    // Create tooltip content
    const createTooltipContent = (item, type) => {
      const config = RESOURCE_TYPES[type];
      let content = `
        <div class="tooltip-content">
          <h3>${item.name || `Unnamed ${config.label}`}</h3>
          <div class="tooltip-details">
      `;
      
      if (type !== 'schools' && item.outletName) {
        content += `<p><strong>Branch:</strong> ${item.outletName}</p>`;
      }
      
      content += `
            <p><strong>Address:</strong> ${item.address || 'Unknown Address'}</p>
            <p><strong>Phone:</strong> ${item.phone || 'No phone information'}</p>
            <p><strong>Type:</strong> ${item.type || config.label}</p>
      `;
      
      if (type !== 'schools' && item.openHours) {
        content += `<p><strong>Opening Hours:</strong> ${item.openHours}</p>`;
      }
      
      if (item.website) {
        content += `<p><strong>Website:</strong> <a href="${item.website}" target="_blank">${formatUrl(item.website)}</a></p>`;
      }
      
      content += `
          </div>
        </div>
      `;
      
      return content;
    };
    
    // Adjust map view to fit current markers
    const fitToCurrentMarkers = () => {
      if (!map.value || !currentMarkerLayer.value) return;
      
      try {
        const bounds = currentMarkerLayer.value.getBounds();
        
        if (bounds.isValid()) {
          map.value.fitBounds(bounds, {
            padding: [50, 50],
            maxZoom: 9,
            animate: true
          });
          console.log('View adjusted to bounds');
        } else {
          console.warn('Invalid bounds, using default view');
          map.value.setView([-37.815, 144.963], 8);
        }
      } catch (error) {
        console.error('Error adjusting view:', error);
        map.value.setView([-37.815, 144.963], 8);
      }
    };
    
    // Add legend
    const addLegend = () => {
      if (!map.value) return;
      
      // Remove existing legend
      const existingLegend = document.querySelector('.info.legend');
      if (existingLegend) {
        existingLegend.remove();
      }
      
      // Create legend control
      const legend = L.control({position: 'bottomright'});
      
      legend.onAdd = function (map) {
        const div = L.DomUtil.create('div', 'info legend');
        
        // Add point legend
        div.innerHTML = `<h4>Point Legend</h4>`;
        
        // Dynamically generate legend using resource type configuration
        Object.values(RESOURCE_TYPES).forEach(config => {
          div.innerHTML += `
            <div style="margin-bottom:5px;">
              <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:${config.color};border:1px solid white;"></span>
              <span style="margin-left:5px;">${config.label}</span>
            </div>
          `;
        });
        
        // Add heatmap legend
        if (showHeatmap.value) {
          div.innerHTML += `
            <h4 style="margin-top:10px;">Heatmap</h4>
            <div style="margin-bottom:3px;display:flex;align-items:center;">
              <div style="width:50px;height:10px;background:linear-gradient(to right, blue, cyan, lime, yellow, red);"></div>
              <span style="margin-left:5px;font-size:12px;">Resource Density</span>
            </div>
          `;
        }
        
        return div;
      };
      
      legend.addTo(map.value);
    };
    
    // Update legend
    const updateLegend = () => {
      addLegend();
    };
    
    // Watch for changes in selected types - update only during filter step
    watch(selectedTypes, (newState) => {
      if (map.value && currentStep.value === 'filter') {
        // Save new selection state
        saveFilterState(newState);
        createMarkersForSelectedTypes();
      }
    }, { deep: true });
    
    // Watch for heatmap toggle - update heatmap and legend
    watch(showHeatmap, (newValue, oldValue) => {
      console.log(`Heatmap state changed from ${oldValue} to ${newValue}`);
      
      // 确保图例更新
      if (currentStep.value === 'heatmap') {
        updateLegend();
      }
      
      // 如果需要其他操作，可以在这里添加
      if (newValue) {
        console.log('Heatmap is now visible');
      } else {
        console.log('Heatmap is now hidden');
      }
    });
    
    // Watch for step changes - update legend display
    watch(currentStep, (newStep) => {
      console.log('Step changed:', newStep);
      updateLegend();
    });
    
    // Watch for confirmed type changes - update heatmap during heatmap step
    watch(confirmedTypes, () => {
      if (currentStep.value === 'heatmap' && showHeatmap.value) {
        // When confirmed types change, recreate markers and update heatmap
        createMarkersForConfirmedTypes();
        console.log('Heatmap data updated based on types');
      }
    }, { deep: true });
    
    // Destroy map and clean up resources
    const destroyMap = () => {
      try {
        if (map.value) {
          // Remove current layer
          if (currentMarkerLayer.value && map.value.hasLayer(currentMarkerLayer.value)) {
            map.value.removeLayer(currentMarkerLayer.value);
          }
          
          // Destroy map
          map.value.remove();
          map.value = null;
          currentMarkerLayer.value = null;
        }
      } catch (error) {
        console.error('Error destroying map:', error);
      }
    };

    // Initialize when component is mounted
    onMounted(() => {
      console.log('Component mounted, starting initialization...');
      
      // 初始化热力图相关状态
      initializeHeatmapState();
      
      // 初始化地图
      initMap();
      
      // Add window resize listener
      window.addEventListener('resize', () => {
        if (map.value) {
          map.value.invalidateSize();
        }
      });
    });
    
    // Clean up when component is unmounted
    onUnmounted(() => {
      console.log('Component unmounted, starting cleanup...');
      destroyMap();
      
      // Remove event listeners
      window.removeEventListener('resize', null);
    });

    // Return properties and methods needed in template
    return {
      mapContainer,
      map,
      selectedTypes,
      confirmedTypes,
      changeResourceType: toggleResourceTypeHandler, // Use new function name
      selectAll,
      selectNone,
      schoolsData,
      hospitalsData,
      ndisProvidersData,
      ndisDailyLivingData,
      ndisTherapyData,
      showHeatmap,
      toggleHeatmap,
      updateLegend,
      dataLoadError,
      maxZoomLevel: zoomLevels.max,
      isLoading,
      currentStep,
      goToHeatmap,
      backToFiltering,
      hasSelectedAnyType: hasSelectedAnyTypeComputed, // Use computed property
      densitySearchRef,
      isAllTypesSelected: isAllTypesSelectedComputed, // Use computed property
      resourceData,
      heatmapData, // Add heatmap data
      RESOURCE_TYPES, // Export resource type configuration for template use
      
      // 添加热力图控制器相关返回值
      controlsMinimized,
      heatmapParams,
      toggleControlsMinimized,
      updateHeatmapParams,
      resetHeatmapParams
    };
  }
};
</script>

<style scoped>
.demo-container {
  width: 100%;
  margin: 0;
  padding: 0;
  font-family: 'Arial', sans-serif;
  position: relative;
}

/* Hero Banner 样式 */
.hero-banner {
  background-image: url('/99.jpg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  height: 600px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: 0;
  margin-bottom: 0;
}

/* 覆盖层效果 */
.hero-banner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.4);
}

/* 文字内容容器 */
.hero-content {
  z-index: 1;
  position: relative;
  text-align: center;
  padding: 40px 20px;
  max-width: 900px;
  margin: 0 auto;
}

/* 主标题样式 */
.hero-title {
  font-size: 3.5rem;
  font-weight: bold;
  color: white;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
  margin: 0 0 24px 0;
  line-height: 1.2;
}

/* 副标题样式 */
.hero-subtitle {
  font-size: 1.3rem;
  line-height: 1.6;
  color: white;
  max-width: 800px;
  margin: 0 auto;
  text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6);
}

/* 主内容区域 */
.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px 20px;
}

.description {
  text-align: center;
  color: #666;
  margin-bottom: 20px;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

/* 步骤指示器样式 */
.step-indicators {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
  gap: 40px;
}

.step {
  padding: 8px 15px;
  background-color: #f0f0f0;
  border-radius: 4px;
  font-size: 14px;
  color: #666;
  position: relative;
}

.step:after {
  content: '';
  position: absolute;
  top: 50%;
  right: -25px;
  transform: translateY(-50%);
  width: 10px;
  height: 10px;
  border-top: 2px solid #ccc;
  border-right: 2px solid #ccc;
  transform: translateY(-50%) rotate(45deg);
}

.step:last-child:after {
  display: none;
}

.step.active {
  background-color: #3388ff;
  color: white;
  font-weight: bold;
}

/* 外部滤器容器样式 */
.external-filter-container {
  margin-bottom: 20px;
  max-width: 100%;
}

/* 资源筛选器样式 */
.resource-filter {
  background: white;
  border-radius: 4px;
  padding: 25px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  min-height: 180px;
}

.resource-type {
  margin-bottom: 20px;
}

.type-title {
  font-weight: bold;
  margin-bottom: 20px;
  font-size: 16px;
  color: #333;
}

.checkbox-group {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  margin-bottom: 20px;
}

.checkbox-group label {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  padding: 6px;
  transition: background-color 0.2s;
}

.checkbox-group label:hover {
  background-color: #f8f9fa;
  border-radius: 4px;
}

.checkbox-group input[type="checkbox"] {
  margin: 0;
  cursor: pointer;
}

.checkbox-group span {
  font-weight: 500;
}

.quick-options {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.quick-options button {
  padding: 8px 16px;
  background: #e9ecef;
  border: 1px solid #ced4da;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 13px;
}

.quick-options button:hover {
  background: #dee2e6;
}

/* 确认按钮样式 */
.confirm-section {
  margin-top: 25px;
  display: flex;
  justify-content: center;
}

.confirm-button {
  padding: 12px 28px;
  font-size: 16px;
  font-weight: 500;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  transition: all 0.3s;
  min-width: 200px;
  background: #28a745;
  color: white;
}

.confirm-button:hover:not(:disabled) {
  background: #218838;
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
}

.confirm-button:disabled {
  background: #6c757d;
  cursor: not-allowed;
  opacity: 0.65;
}

/* 返回链接样式 */
.back-navigation-inline {
  margin-bottom: 15px;
}

.back-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  text-decoration: none;
  color: #333;
  font-size: 16px;
  font-weight: 500;
  transition: all 0.2s ease;
}

.back-link:hover {
  color: #007bff;
  transform: translateX(-2px);
}

.back-link .arrow {
  font-size: 20px;
  font-weight: 600;
  transition: transform 0.2s ease;
}

.back-link:hover .arrow {
  transform: translateX(-3px);
}

/* 地图容器样式 */
.map-container {
  position: relative;
  width: 100%;
  height: 800px;
  margin-bottom: 20px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  border: 1px solid #dee2e6;
}

#resource-map {
  width: 100%;
  height: 100%;
  z-index: 1;
}

/* 加载动画覆盖层 */
.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(255, 255, 255, 0.8);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 1001;
}

.loading-spinner {
  width: 50px;
  height: 50px;
  border: 5px solid #f3f3f3;
  border-top: 5px solid #3388ff;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 10px;
}

.loading-text {
  font-size: 16px;
  color: #333;
  font-weight: bold;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 独立的热力图控制器覆盖层 */
.heatmap-controls-overlay {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  padding: 0;
  min-width: 280px;
  max-width: 320px;
  z-index: 1003;
  border: 1px solid rgba(0, 0, 0, 0.1);
  backdrop-filter: blur(4px);
}

/* 控制器标题栏 */
.heatmap-controls-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: linear-gradient(to bottom, #f8f9fa, #e9ecef);
  border-bottom: 1px solid #dee2e6;
  border-radius: 8px 8px 0 0;
}

.heatmap-controls-header h3 {
  margin: 0;
  font-size: 16px;
  color: #333;
  font-weight: 600;
}

.minimize-btn {
  background: none;
  border: none;
  font-size: 16px;
  color: #666;
  cursor: pointer;
  padding: 2px 6px;
  transition: color 0.2s;
  line-height: 1;
}

.minimize-btn:hover {
  color: #333;
}

/* 控制器内容区域 */
.heatmap-controls-content {
  padding: 16px;
}

/* 热力图开关样式 */
.heatmap-toggle {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
}

.toggle-label {
  margin-left: 10px;
  font-size: 14px;
  color: #333;
  font-weight: 500;
}

/* Switch 开关样式 */
.switch {
  position: relative;
  display: inline-block;
  width: 44px;
  height: 20px;
}

.switch input {
  opacity: 0;
  width: 0;
  height: 0;
}

.slider {
  position: absolute;
  cursor: pointer;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: #ccc;
  transition: .4s;
}

.slider:before {
  position: absolute;
  content: "";
  height: 14px;
  width: 14px;
  left: 3px;
  bottom: 3px;
  background-color: white;
  transition: .4s;
}

input:checked + .slider {
  background-color: #2196F3;
}

input:focus + .slider {
  box-shadow: 0 0 1px #2196F3;
}

input:checked + .slider:before {
  transform: translateX(24px);
}

.slider.round {
  border-radius: 20px;
}

.slider.round:before {
  border-radius: 50%;
}

/* 热力图设置样式 */
.heatmap-settings {
  padding-top: 8px;
  border-top: 1px solid #e9ecef;
}

.setting-item {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
  position: relative;
}

.setting-item label {
  width: 100px;
  font-size: 13px;
  color: #555;
  margin-right: 8px;
}

.setting-item input[type="range"] {
  flex: 1;
  margin: 0 8px 0 0;
  height: 6px;
  -webkit-appearance: none;
  appearance: none;
  background-color: #e0e0e0;
  border-radius: 3px;
  outline: none;
}

.setting-item input[type="range"]::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 16px;
  height: 16px;
  background: #2196F3;
  border-radius: 50%;
  cursor: pointer;
  box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
}

.setting-item input[type="range"]::-moz-range-thumb {
  width: 16px;
  height: 16px;
  background: #2196F3;
  border-radius: 50%;
  cursor: pointer;
  border: none;
  box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
}

.setting-value {
  width: 32px;
  text-align: right;
  font-size: 13px;
  color: #333;
  font-weight: 500;
}

.setting-item select {
  padding: 5px 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
  background-color: white;
  font-size: 13px;
  color: #444;
  flex-grow: 1;
  min-width: 0;
}

.reset-btn {
  margin-top: 12px;
  padding: 6px 16px;
  background-color: #f8f9fa;
  border: 1px solid #dee2e6;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  color: #495057;
  transition: all 0.2s;
  width: 100%;
}

.reset-btn:hover {
  background-color: #e9ecef;
  border-color: #adb5bd;
}

/* 统计面板样式 */
.stats-panel {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  margin-bottom: 20px;
  gap: 15px;
}

.stat-card {
  background-color: #f5f5f5;
  border-radius: 8px;
  padding: 15px;
  width: calc(16.666% - 12.5px);
  text-align: center;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.stat-card h3 {
  margin: 0 0 10px 0;
  font-size: 10px;
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
  padding: 20px;
  margin-top: 20px;
  border: 1px solid #e9ecef;
}

.instructions h3 {
  margin-top: 0;
  color: #333;
}

.instructions ul {
  padding-left: 20px;
  margin-bottom: 0;
}

.instructions li {
  margin-bottom: 8px;
  color: #555;
  line-height: 1.6;
}

.error-message {
  background-color: #ffeeee;
  border-left: 4px solid #ff5555;
  padding: 10px 15px;
  margin-top: 20px;
  border-radius: 4px;
}

:deep(.info) {
  padding: 6px 8px;
  font: 14px/16px Arial, Helvetica, sans-serif;
  background: white;
  background: rgba(255, 255, 255, 0.9);
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
  border-radius: 5px;
}

:deep(.info h4) {
  margin: 0 0 5px;
  color: #777;
}

:deep(.legend) {
  line-height: 18px;
  color: #555;
}

.custom-div-icon {
  background: none !important;
  border: none !important;
}

:deep(.custom-tooltip) {
  background-color: white;
  border: 1px solid #ccc;
  border-radius: 5px;
  padding: 10px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
  word-wrap: break-word;
  overflow-wrap: break-word;
  white-space: normal;
}

:deep(.horizontal-tooltip) {
  min-width: 220px;
  max-width: 400px;
  width: auto;
}

:deep(.tooltip-content) {
  display: flex;
  flex-direction: column;
}

:deep(.tooltip-content h3) {
  margin: 0 0 6px 0;
  color: #333;
  font-size: 16px;
  border-bottom: 1px solid #eee;
  padding-bottom: 4px;
  white-space: normal;
  overflow: hidden;
  text-overflow: ellipsis;
}

:deep(.tooltip-details) {
  display: flex;
  flex-direction: column;
  gap: 3px;
}

:deep(.tooltip-details p) {
  margin: 2px 0;
  color: #555;
  font-size: 13px;
  white-space: normal;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.4;
}

:deep(.location-search) {
  margin-top: 35px; 
  padding-top: 15px;
  border-top: 1px solid #eee;
}

:deep(.search-title) {
  font-weight: bold;
  margin-bottom: 12px;
  font-size: 16px;
  color: #333;
}

:deep(.autocomplete-wrapper input) {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid #ddd;
  border-radius: 6px 0 0 6px;
  font-size: 15px;
  box-sizing: border-box;
  min-height: 44px;
}

:deep(.search-button) {
  width: 48px;
  min-height: 44px;
  background-color: #3388ff;
  color: white;
  border: none;
  border-radius: 0 6px 6px 0;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

:deep(.density-result) {
  margin-top: 15px;
  padding: 12px;
  border-radius: 6px;
  font-size: 14px;
}

:deep(.search-location-pin) {
  position: relative !important;
  width: 50px !important;
  height: 50px !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

:deep(.location-icon) {
  font-size: 50px !important;
  color: #ff0033 !important;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3) !important;
  filter: drop-shadow(0 4px 12px rgba(255, 0, 51, 0.5)) !important;
  animation: pulse 2s infinite !important;
}

@keyframes pulse {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.05);
    opacity: 0.9;
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

:deep(.custom-search-marker) {
  z-index: 1000 !important;
  overflow: visible !important;
}

:deep(.custom-search-marker *) {
  overflow: visible !important;
}

@media (max-width: 768px) {
  .hero-banner {
    height: 350px;
  }
  
  .hero-title {
    font-size: 2.5rem;
  }
  
  .hero-subtitle {
    font-size: 1.1rem;
  }
  
  .main-content {
    padding: 30px 15px 15px;
  }
  
  .external-filter-container {
    padding: 0;
  }
  
  .checkbox-group {
    gap: 10px;
  }
  
  .map-container {
    height: 400px;
  }
  
  .stats-panel {
    gap: 10px;
  }
  
  .stat-card {
    width: calc(33.333% - 6.67px);
  }
  
  :deep(.horizontal-tooltip) {
    max-width: 320px;
  }
  
  .step-indicators {
    gap: 20px;
  }
  
  .step {
    font-size: 12px;
    padding: 6px 10px;
  }
  
  .step:after {
    right: -15px;
    width: 8px;
    height: 8px;
  }
  
  .heatmap-controls-overlay {
    top: 15px;
    right: 15px;
    min-width: 240px;
    max-width: 260px;
  }
  
  .heatmap-controls-header {
    padding: 10px 12px;
  }
  
  .heatmap-controls-header h3 {
    font-size: 14px;
  }
  
  .heatmap-controls-content {
    padding: 12px;
  }
  
  .setting-item label {
    width: 90px;
    font-size: 12px;
  }
  
  .setting-value {
    width: 28px;
    font-size: 12px;
  }
}

@media (max-width: 480px) {
  .hero-banner {
    height: 300px;
  }
  
  .hero-title {
    font-size: 1.8rem;
  }
  
  .hero-subtitle {
    font-size: 1rem;
  }
  
  .hero-content {
    padding: 30px 15px;
  }
  
  .main-content {
    padding: 20px 10px 10px;
  }
  
  .external-filter-container {
    padding: 0;
  }
  
  .resource-filter {
    padding: 15px;
  }
  
  .checkbox-group {
    flex-direction: column;
    gap: 8px;
  }
  
  .checkbox-group label {
    justify-content: flex-start;
  }
  
  .confirm-button {
    min-width: auto;
    width: 100%;
    padding: 10px 16px;
  }
  
  .map-container {
    height: 350px;
  }
  
  .stat-card {
    width: 100%;
  }
  
  :deep(.horizontal-tooltip) {
    max-width: 280px;
  }
  
  .step-indicators {
    gap: 15px;
    flex-direction: column;
    align-items: center;
  }
  
  .step {
    font-size: 11px;
    padding: 5px 8px;
    margin-bottom: 10px;
  }
  
  .step:after {
    display: none;
  }
  
  .type-title {
    font-size: 14px;
  }
  
  .quick-options {
    flex-direction: column;
    gap: 8px;
  }
  
  .quick-options button {
    width: 100%;
  }
  
  .back-link {
    font-size: 13px;
    gap: 6px;
  }
  
  .back-link .arrow {
    font-size: 16px;
  }
  
  :deep(.autocomplete-wrapper input) {
    padding: 8px 12px;
    font-size: 14px;
    min-height: 38px;
  }
  
  :deep(.search-button) {
    width: 42px;
    min-height: 38px;
  }
  
  /* 热力图控制器响应式 */
  .heatmap-controls-overlay {
    top: 10px;
    right: 10px;
    left: 10px;
    max-width: none;
  }
  
  .heatmap-controls-header {
    padding: 8px 10px;
  }
  
  .heatmap-controls-header h3 {
    font-size: 13px;
  }
  
  .heatmap-controls-content {
    padding: 10px;
  }
  
  .setting-item {
    flex-wrap: wrap;
    margin-bottom: 10px;
  }
  
  .setting-item label {
    width: 100%;
    margin-bottom: 4px;
  }
  
  .setting-item input[type="range"] {
    width: calc(100% - 40px);
  }
  
  .setting-value {
    width: 32px;
    position: absolute;
    right: 0;
    top: 0;
  }
}
</style>