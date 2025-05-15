<template>
  <div class="demo-container">
    <MyNavBar />
    <!-- Hero Banner -->
    <div class="hero-banner">
      <div class="hero-content">
        <h1 class="hero-title">Find Autism Support in Your Community</h1>
        <p class="hero-subtitle">Discover nearby special schools, therapy centres, hospitals, early intervention services, and daily living support tailored for autistic children and their families.</p>
      </div>
    </div>

    <div class="main-content">  
      <!-- unified page container -->
      <div class="unified-page-container">
        <!-- resource type selection part -->
        <div class="resource-filter">
          <div class="resource-type">
            <div class="type-title">What kind of autism support are you looking for nearby?</div>
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
          </div>
        </div>
        
        <!-- location search part -->
        <div class="location-search-section">
          <LocationDensitySearch
            :map="map"
            :all-types-selected="isAllTypesSelected"
            :resource-data="resourceData"
            v-model:loading="isLoading"
            :selected-types="selectedTypes"
            ref="densitySearchRef"
          />
        </div>
      </div>
      
      <!-- Resource Map Title and Description -->
      <div class="resource-map-header">
        <h2>Victoria Autism Support Resourc Map</h2>
        <p>
          {{ showHeatmap ? 'Currently viewing the heatmap density analysis. Use controls to adjust visualization.' : 'Currently viewing selected resource points. Toggle heatmap to see density patterns.' }}
        </p>
      </div>
      
      <!-- Map Container with Heatmap Controls Overlay -->
      <div class="map-container">
        <div id="resource-map" ref="mapContainer"></div>
        
        <!-- Loading Animation Overlay -->
        <div v-if="isLoading" class="loading-overlay">
          <div class="loading-spinner"></div>
          <div class="loading-text">Loading Resources...</div>
        </div>
        
        <!-- Heatmap Controls Overlay -->
        <div class="heatmap-controls-overlay">
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
          v-if="map"
          :map="map"
          :data="heatmapData"
          :show-heatmap="showHeatmap"
          :max-zoom="maxZoomLevel"
          :heatmap-config="heatmapParams"
          @legend-update="updateLegend"
        />
      </div>
      
      <div class="stats-panel">
        <div class="stat-card" :class="{ 'disabled': !selectedTypes.schools }">
          <h3>Total Special Schools</h3>
          <div class="stat-number">{{ selectedTypes.schools ? schoolsData.length : 0 }}</div>
        </div>
        <div class="stat-card" :class="{ 'disabled': !selectedTypes.hospitals }">
          <h3>Total Public Hospitals</h3>
          <div class="stat-number">{{ selectedTypes.hospitals ? hospitalsData.length : 0 }}</div>
        </div>
        <div class="stat-card" :class="{ 'disabled': !selectedTypes.ndisProviders }">
          <h3>NDIS Early Intervention</h3>
          <div class="stat-number">{{ selectedTypes.ndisProviders ? ndisProvidersData.length : 0 }}</div>
        </div>
        <div class="stat-card" :class="{ 'disabled': !selectedTypes.ndisDailyLiving }">
          <h3>NDIS Daily Living</h3>
          <div class="stat-number">{{ selectedTypes.ndisDailyLiving ? ndisDailyLivingData.length : 0 }}</div>
        </div>
        <div class="stat-card" :class="{ 'disabled': !selectedTypes.ndisTherapy }">
          <h3>NDIS Therapy Services</h3>
          <div class="stat-number">{{ selectedTypes.ndisTherapy ? ndisTherapyData.length : 0 }}</div>
        </div>
        <div class="stat-card">
          <h3>Total Resources</h3>
          <div class="stat-number">{{ currentTotalResources }}</div>
        </div>
      </div>
      
      <div class="instructions">
        <h3>Usage Instructions:</h3>
        <ul>
          <li>On the map, different types of autism support are marked with coloured dots: <span style="color: #3388ff; font-weight: bold;">Special schools</span> (Blue Dots) <span style="color: #ff3333; font-weight: bold;">hospitals</span> (Red Dots) <span style="color: #33cc33; font-weight: bold;">NDIS early intervention</span> (Green Dots) <span style="color: #9933cc; font-weight: bold;">NDIS daily living support</span> (Purple Dots) and <span style="color: #ff9900; font-weight: bold;">NDIS therapy services</span> (Orange Dots)</li>
          <li>Check the boxes above to display multiple types of resources simultaneously</li>
          <li>Enter an address or suburb in the search box to find nearby resources</li>
          <li>Hover over a point to view detailed information</li>
          <li>Toggle the heatmap to visualize resource density (red indicates high density, blue indicates low density)</li>
          <li>Use the heatmap controls to adjust parameters: Hotspot Radius controls the size of influence area for each resource point, Blur Level makes the heatmap appear smoother or clearer</li>
        </ul>
      </div>
      
      <div v-if="dataLoadError" class="error-message">
        <p>{{ dataLoadError }}</p>
      </div>
    </div>
    <MyFooter />
  </div>
</template>
<script>
import { onMounted, ref, onUnmounted, reactive, watch, computed } from 'vue';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import HeatmapLayer from '../components/HeatmapLayer.vue';
import LocationDensitySearch from '../components/LocationDensitySearch.vue';
import { loadAllData } from '../services/dataLoader.js';
import MyNavBar from '../components/test/MyNavBar.vue';
import MyFooter from '../components/test/MyFooter.vue';

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
    LocationDensitySearch,
    MyNavBar,
    MyFooter
  },
  setup() {
    // create reactive references
    const mapContainer = ref(null);
    const map = ref(null);
    const dataLoadError = ref('');
    const showHeatmap = ref(false);
    const isLoading = ref(false);
    const densitySearchRef = ref(null);
    
    // heatmap controller state
    const controlsMinimized = ref(false);
    
    // heatmap parameters state
    const heatmapParams = reactive({
      radius: 37,
      blur: 35,
      intensity: 1.5,
      maxThreshold: 10
    });
    
    // default heatmap parameters (for resetting)
    const defaultHeatmapParams = {
      radius: 35,
      blur: 35,
      intensity: 1.5,
      maxThreshold: 10
    };
    
    // multi-select types - current filter selection (using new filter logic)
    const selectedTypes = reactive(loadFilterState()); // load from local storage
    
    // computed property: whether any type has been selected
    const hasSelectedAnyTypeComputed = computed(() => {
      return hasSelectedAnyType(selectedTypes);
    });
    
    // computed property: whether all types have been selected
    const isAllTypesSelectedComputed = computed(() => {
      return isAllTypesSelected(selectedTypes);
    });
    
    // computed property: resource data object (for passing to location density query component)
    const resourceData = computed(() => {
      return {
        schools: schoolsData.value,
        hospitals: hospitalsData.value,
        ndisProviders: ndisProvidersData.value,
        ndisDailyLiving: ndisDailyLivingData.value,
        ndisTherapy: ndisTherapyData.value
      };
    });
    
    // computed property: heatmap data (based on confirmed filter types)
    const heatmapData = computed(() => {
      const allData = {
        schoolsData: schoolsData.value,
        hospitalsData: hospitalsData.value,
        ndisProvidersData: ndisProvidersData.value,
        ndisDailyLivingData: ndisDailyLivingData.value,
        ndisTherapyData: ndisTherapyData.value
      };
      
      // return the data of the current selected types
      const selectedData = getDataByFilters(selectedTypes, allData);
      
      // merge all selected types data into a single array
      let combinedData = [];
      Object.values(selectedData).forEach(data => {
        if (Array.isArray(data)) {
          combinedData = combinedData.concat(data);
        }
      });
      
      return combinedData;
    });
    
    // computed property: current total resources
    const currentTotalResources = computed(() => {
      let total = 0;
      if (selectedTypes.schools) total += schoolsData.value.length;
      if (selectedTypes.hospitals) total += hospitalsData.value.length;
      if (selectedTypes.ndisProviders) total += ndisProvidersData.value.length;
      if (selectedTypes.ndisDailyLiving) total += ndisDailyLivingData.value.length;
      if (selectedTypes.ndisTherapy) total += ndisTherapyData.value.length;
      return total;
    });
    
    // toggle controls minimized/expanded state
    const toggleControlsMinimized = () => {
      controlsMinimized.value = !controlsMinimized.value;
      // save the state to local storage
      try {
        localStorage.setItem('heatmapControlsMinimized', JSON.stringify(controlsMinimized.value));
      } catch (error) {
        console.error('Failed to save controls state:', error);
      }
    };
    
    // update heatmap parameters
    const updateHeatmapParams = () => {
      // save the parameters to local storage
      try {
        localStorage.setItem('heatmapParams', JSON.stringify(heatmapParams));
      } catch (error) {
        console.error('Failed to save heatmap parameters:', error);
      }
    };
    
    // reset heatmap parameters
    const resetHeatmapParams = () => {
      Object.keys(defaultHeatmapParams).forEach(key => {
        heatmapParams[key] = defaultHeatmapParams[key];
      });
      updateHeatmapParams();
    };
    
    // initialize heatmap parameters and controller state
    const initializeHeatmapState = () => {
      try {
        // load heatmap parameters
        const savedParams = localStorage.getItem('heatmapParams');
        if (savedParams) {
          const parsed = JSON.parse(savedParams);
          Object.keys(defaultHeatmapParams).forEach(key => {
            if (parsed[key] !== undefined) {
              heatmapParams[key] = parsed[key];
            }
          });
        }
        
        // load controller state
        const savedControlsState = localStorage.getItem('heatmapControlsMinimized');
        if (savedControlsState) {
          controlsMinimized.value = JSON.parse(savedControlsState);
        }
      } catch (error) {
        console.error('Failed to load heatmap state:', error);
      }
    };
    
    // quick select all types (using new filter logic)
    const selectAll = () => {
      const newState = selectAllTypes(selectedTypes);
      Object.keys(newState).forEach(key => {
        selectedTypes[key] = newState[key];
      });
      createMarkersForSelectedTypes();
    };
    
    // clear all selections (using new filter logic)
    const selectNone = () => {
      const newState = selectNoneTypes(selectedTypes);
      Object.keys(newState).forEach(key => {
        selectedTypes[key] = newState[key];
      });
      createMarkersForSelectedTypes();
    };
    
    // toggle single resource type (using new filter logic)
    const toggleResourceTypeHandler = (type) => {
      selectedTypes[type] = !selectedTypes[type];
      createMarkersForSelectedTypes();
    };
    
    // zoom level constants - only limit zoom out
    const zoomLevels = {
      max: 20,
      min: 6,
      minFit: 8
    };

    // create reactive data using ref
    const schoolsData = ref([]);
    const hospitalsData = ref([]);
    const ndisProvidersData = ref([]);
    const ndisDailyLivingData = ref([]);
    const ndisTherapyData = ref([]);
    
    // current displayed marker layer group - using single layer group
    const currentMarkerLayer = ref(null);
    
    // coordinate validation function
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
    
    // data preprocessing
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
      
      // process data for each type
      schoolsData.value = processPointData(schoolsData.value, 'Schools');
      hospitalsData.value = processPointData(hospitalsData.value, 'Hospitals');
      ndisProvidersData.value = processPointData(ndisProvidersData.value, 'NDIS Early Intervention');
      ndisDailyLivingData.value = processPointData(ndisDailyLivingData.value, 'NDIS Daily Living Support');
      ndisTherapyData.value = processPointData(ndisTherapyData.value, 'NDIS Therapy Services');
    };
    
    // initialize map
    const initMap = async () => {
      console.log('Initializing map...');
      isLoading.value = true;
      
      try {
        // load data
        const result = await loadAllData();
        
        if (!result.success) {
          dataLoadError.value = result.error || 'Failed to load data';
          isLoading.value = false;
          return;
        }
        
        // update reactive data
        schoolsData.value = result.schoolsData || [];
        hospitalsData.value = result.hospitalsData || [];
        ndisProvidersData.value = result.ndisProvidersData || [];
        ndisDailyLivingData.value = result.ndisDailyLivingData || [];
        ndisTherapyData.value = result.ndisTherapyData || [];
        
        // data preprocessing
        preprocessAllData();
        
        // ensure DOM has rendered
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
    
    // create map
    const createMap = () => {
      const mapElement = document.getElementById('resource-map');
      if (!mapElement) {
        console.error('Map container element not found!');
        dataLoadError.value = 'Unable to initialize map, map container element not found.';
        return;
      }
      
      // prevent map container size problem
      if (mapElement.clientWidth === 0 || mapElement.clientHeight === 0) {
        console.warn('Map container has zero dimensions, waiting for container to be properly sized...');
        setTimeout(createMap, 300);
        return;
      }
      
      console.log('Creating map...', mapElement.clientWidth, mapElement.clientHeight);
      
      // if map exists, destroy it first
      if (map.value) {
        map.value.remove();
        map.value = null;
      }
      
      // initialize map
      map.value = L.map('resource-map', {
        center: [-37.815, 144.963], // Melbourne center
        zoom: 8,
        minZoom: zoomLevels.min,
        maxZoom: zoomLevels.max,
        scrollWheelZoom: true,
        doubleClickZoom: true,
        zoomAnimation: true
      });

      // add base map
      L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
        attribution: '&copy; OpenStreetMap',
        subdomains: 'abcd',
        maxZoom: zoomLevels.max,
        tileSize: 256
      }).addTo(map.value);
      
      // create initial layer - display all selected resource types
      createMarkersForSelectedTypes();
      
      // add legend
      addLegend();
    };
    
    // helper function - format URL
    const formatUrl = (url) => {
      if (!url) return '';
      let displayUrl = url.replace(/^https?:\/\//, '');
      if (displayUrl.length > 30) {
        displayUrl = displayUrl.substring(0, 27) + '...';
      }
      return displayUrl;
    };
    
    // create tooltip content
    const createTooltipContent = (item, type) => {
      const config = RESOURCE_TYPES[type];
      let content = `
        <div class="tooltip-content">
          <div class="tooltip-header">
            <h3>${item.name || `Unnamed ${config.label}`}</h3>
            <button class="close-tooltip">×</button>
          </div>
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
        // ensure website link uses full URL format
        let fullUrl = item.website;
        if (!fullUrl.startsWith('http://') && !fullUrl.startsWith('https://')) {
          fullUrl = 'https://' + fullUrl;
        }
        content += `<p><strong>Website:</strong> <a href="${fullUrl}" target="_blank" rel="noopener noreferrer" class="tooltip-link">${formatUrl(item.website)}</a></p>`;
      }
      
      content += `
          </div>
        </div>
      `;
      
      return content;
    };
    
    // create markers - based on selected types
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
    
    // create markers
    const createMarkers = (typeFilter) => {
      // if current marker layer exists, remove it first
      if (currentMarkerLayer.value && map.value.hasLayer(currentMarkerLayer.value)) {
        map.value.removeLayer(currentMarkerLayer.value);
      }
      
      // ensure map is initialized
      if (!map.value) {
        console.warn('Map not initialized, cannot create markers');
        return;
      }
      
      try {
        // create new layer group
        currentMarkerLayer.value = L.layerGroup();
        
        // add markers based on selected state
        let pointCount = 0;
        
        // get all current data
        const allData = {
          schoolsData: schoolsData.value,
          hospitalsData: hospitalsData.value,
          ndisProvidersData: ndisProvidersData.value,
          ndisDailyLivingData: ndisDailyLivingData.value,
          ndisTherapyData: ndisTherapyData.value
        };
        
        // get selected data and create markers
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
              
              // create tooltip content
              const tooltipContent = createTooltipContent(item, type);
              
              // use popup instead of tooltip, allow fixed display
              const popup = L.popup({
                className: 'custom-popup',
                offset: [0, -5],
                closeButton: false,
                autoClose: false,
                closeOnEscapeKey: true,
                maxWidth: 350
              }).setContent(tooltipContent);
              
              marker.bindPopup(popup);
              
              // add click event handler
              marker.on('click', function(e) {
                // close all other open popups
                map.value.eachLayer(function(layer) {
                  if (layer !== marker && layer.closePopup) {
                    layer.closePopup();
                  }
                });
                
                // open current popup
                marker.openPopup();
                
                // add event listener to ensure correct external link opening
                setTimeout(() => {
                  const popupLinks = document.querySelectorAll('.tooltip-link');
                  popupLinks.forEach(link => {
                    link.addEventListener('click', function(e) {
                      e.stopPropagation();
                      window.open(this.href, '_blank');
                      return false;
                    });
                  });
                  
                  // add event listener to ensure correct close button opening
                  const closeButtons = document.querySelectorAll('.close-tooltip');
                  closeButtons.forEach(button => {
                    button.addEventListener('click', function(e) {
                      e.preventDefault();
                      e.stopPropagation();
                      marker.closePopup();
                    });
                  });
                }, 100);
              });
              
              // add to current layer group
              marker.addTo(currentMarkerLayer.value);
              pointCount++;
            } catch (error) {
              console.error(`Error creating ${config.label} marker:`, error);
            }
          });
        });
        
        // add to current layer group
        currentMarkerLayer.value.addTo(map.value);
        console.log(`Created ${pointCount} markers`);
        
        // adjust view only when adding markers
        if (pointCount > 0) {
          // adjust view to show all markers
          fitToCurrentMarkers();
        } else {
          console.log('No markers added, using default view');
          map.value.setView([-37.815, 144.963], 8);
        }
      } catch (error) {
        console.error('Error in createMarkers:', error);
        // when error occurs, use default view
        if (map.value) {
          map.value.setView([-37.815, 144.963], 8);
        }
      }
    };
    
    // adjust map view to fit current markers
    const fitToCurrentMarkers = () => {
      if (!map.value || !currentMarkerLayer.value) return;
      
      try {
        // ensure layer exists and has markers, if no markers, do not try to call getBounds
        if (currentMarkerLayer.value.getLayers && currentMarkerLayer.value.getLayers().length === 0) {
          console.log('No markers to fit, using default view');
          map.value.setView([-37.815, 144.963], 8);
          return;
        }
        
        // ensure getBounds method exists
        if (typeof currentMarkerLayer.value.getBounds !== 'function') {
          console.warn('getBounds method not available on currentMarkerLayer, using default view');
          map.value.setView([-37.815, 144.963], 8);
          return;
        }
        
        const bounds = currentMarkerLayer.value.getBounds();
        
        if (bounds && bounds.isValid && bounds.isValid()) {
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
        // when error occurs, use default view
        map.value.setView([-37.815, 144.963], 8);
      }
    };
    
    // add legend
    const addLegend = () => {
      if (!map.value) return;
      
      // remove existing legend
      const existingLegend = document.querySelector('.info.legend');
      if (existingLegend) {
        existingLegend.remove();
      }
      
      // create legend control
      const legend = L.control({position: 'bottomright'});
      
      legend.onAdd = function (map) {
        const div = L.DomUtil.create('div', 'info legend');
        
        // add point legend
        div.innerHTML = `<h4>Point Legend</h4>`;
        
        // use resource type config to dynamically generate legend
        Object.values(RESOURCE_TYPES).forEach(config => {
          div.innerHTML += `
            <div style="margin-bottom:5px;">
              <span style="display:inline-block;width:10px;height:10px;border-radius:50%;background:${config.color};border:1px solid white;"></span>
              <span style="margin-left:5px;">${config.label}</span>
            </div>
          `;
        });
        
        // add heatmap legend
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
    
    // update legend
    const updateLegend = () => {
      addLegend();
    };
    
    // watch selected types changes
    watch(selectedTypes, (newState) => {
      if (map.value) {
        // save new selection state
        saveFilterState(newState);
        createMarkersForSelectedTypes();
      }
    }, { deep: true });
    
    // watch heatmap switch - update heatmap and legend
    watch(showHeatmap, (newValue, oldValue) => {
      console.log(`Heatmap state changed from ${oldValue} to ${newValue}`);
      
      // ensure legend is updated
      updateLegend();
      
      // if needed, add other operations here
      if (newValue) {
        console.log('Heatmap is now visible');
      } else {
        console.log('Heatmap is now hidden');
      }
    });
    
    // destroy map and clean resources
    const destroyMap = () => {
      try {
        if (map.value) {
          // remove current layer
          if (currentMarkerLayer.value && map.value.hasLayer(currentMarkerLayer.value)) {
            map.value.removeLayer(currentMarkerLayer.value);
          }
          
          // destroy map
          map.value.remove();
          map.value = null;
          currentMarkerLayer.value = null;
        }
      } catch (error) {
        console.error('Error destroying map:', error);
      }
    };

    // component mounted - initialize
    onMounted(() => {
      console.log('Component mounted, starting initialization...');
      
      // initialize heatmap related state
      initializeHeatmapState();
      
      // delay map initialization to ensure DOM is fully rendered
      setTimeout(() => {
        // initialize map
        initMap();
        
        // map initialized, force size refresh to solve possible display issues
        setTimeout(() => {
          if (map.value) {
            console.log('Forcing map size refresh...');
            map.value.invalidateSize(true);
          }
        }, 500);
      }, 100);
      
      // add window size adjustment listener
      window.addEventListener('resize', () => {
        if (map.value) {
          map.value.invalidateSize();
        }
      });
    });
    
    // component unmounted - cleanup
    onUnmounted(() => {
      console.log('Component unmounted, starting cleanup...');
      destroyMap();
      
      // remove event listener
      window.removeEventListener('resize', null);
    });

    // return properties and methods needed in the template
    return {
      mapContainer,
      map,
      selectedTypes,
      changeResourceType: toggleResourceTypeHandler,
      selectAll,
      selectNone,
      schoolsData,
      hospitalsData,
      ndisProvidersData,
      ndisDailyLivingData,
      ndisTherapyData,
      showHeatmap,
      updateLegend,
      dataLoadError,
      maxZoomLevel: zoomLevels.max,
      isLoading,
      hasSelectedAnyType: hasSelectedAnyTypeComputed,
      densitySearchRef,
      isAllTypesSelected: isAllTypesSelectedComputed,
      resourceData,
      heatmapData,
      RESOURCE_TYPES,
      currentTotalResources,
      
        // add location density search
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
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #F8EFED;
}

/* Hero Banner */
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

.hero-banner::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.4);
}

.hero-content {
  z-index: 1;
  position: relative;
  text-align: center;
  padding: 40px 20px;
  max-width: 900px;
  margin: 0 auto;
}

.hero-title {
  font-size: 3.5rem;
  font-weight: bold;
  color: white;
  text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
  margin: 0 0 24px 0;
  line-height: 1.2;
}

.hero-subtitle {
  font-size: 1.3rem;
  line-height: 1.6;
  color: white;
  max-width: 800px;
  margin: 0 auto;
  text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.6);
}

.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 40px 20px 40px;
  flex: 1;
}

.description {
  text-align: center;
  color: #4d2f20;
  margin-bottom: 20px;
  max-width: 800px;
  margin-left: auto;
  margin-right: auto;
}

/* 统一页面容器 */
.unified-page-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
  margin-bottom: 30px;
  background: white;
  border-radius: 8px;
  padding: 25px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.resource-filter {
  margin-bottom: 10px;
  border-bottom: 1px solid #eee;
  padding-bottom: 20px;
}

.location-search-section {
  padding-top: 10px;
}

.resource-type {
  margin-bottom: 20px;
}

.type-title {
  font-weight: bold;
  margin-bottom: 20px;
  font-size: 16px;
  color: #4d2f20;
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
  gap: 10px;
  cursor: pointer;
  padding: 8px 10px;
  transition: all 0.2s ease;
  border-radius: 6px;
  position: relative;
}

.checkbox-group label:hover {
  background-color: rgba(62, 92, 43, 0.08);
}

.checkbox-group input[type="checkbox"] {
  position: absolute;
  opacity: 0;
  cursor: pointer;
  height: 0;
  width: 0;
}

.checkbox-group label span::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 18px;
  height: 18px;
  border: 2px solid #aaa;
  border-radius: 4px;
  background-color: #fff;
  transition: all 0.2s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.checkbox-group label span {
  position: relative;
  padding-left: 28px;
  font-weight: 500;
  font-size: 14px;
}

.checkbox-group input[type="checkbox"]:checked + span::before {
  background-color: #3E5C2B;
  border-color: #3E5C2B;
}

.checkbox-group input[type="checkbox"]:checked + span::after {
  content: '';
  position: absolute;
  left: 6px;
  top: 50%;
  width: 6px;
  height: 10px;
  border: solid white;
  border-width: 0 2px 2px 0;
  transform: translateY(-65%) rotate(45deg);
}

.quick-options {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  margin-top: 10px;
}

.quick-options button {
  padding: 8px 18px;
  background: #f0f0f0;
  border: 1px solid #ddd;
  border-radius: 5px;
  cursor: pointer;
  transition: all 0.2s ease;
  font-size: 14px;
  color: #4d2f20;
  font-weight: 500;
}

.quick-options button:hover {
  background: #e9ecef;
  border-color: #3E5C2B;
  color: #3E5C2B;
  transform: translateY(-1px);
}

.quick-options button:active {
  transform: translateY(0);
}

.map-container {
  position: relative;
  width: 100%;
  height: 600px;
  margin-bottom: 20px;
  border-radius: 0 0 8px 8px;
  overflow: hidden;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  border: 1px solid #dee2e6;
  z-index: 1;
}

#resource-map {
  width: 100%;
  height: 100%;
  z-index: 1;
  background-color: #f8f9fa;
}

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
  border-top: 5px solid #3E5C2B;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 10px;
}

.loading-text {
  font-size: 16px;
  color: #4d2f20;
  font-weight: bold;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

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
  color: #4d2f20;
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
  color: #3E5C2B;
}

.heatmap-controls-content {
  padding: 16px;
}

.heatmap-toggle {
  display: flex;
  align-items: center;
  margin-bottom: 16px;
}

.toggle-label {
  margin-left: 10px;
  font-size: 14px;
  color: #4d2f20;
  font-weight: 500;
}

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
  background-color: #3E5C2B;
}

input:focus + .slider {
  box-shadow: 0 0 1px #3E5C2B;
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
  color: #4d2f20;
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
  background: #3E5C2B;
  border-radius: 50%;
  cursor: pointer;
  box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
}

.setting-item input[type="range"]::-moz-range-thumb {
  width: 16px;
  height: 16px;
  background: #3E5C2B;
  border-radius: 50%;
  cursor: pointer;
  border: none;
  box-shadow: 0 0 4px rgba(0, 0, 0, 0.2);
}

.setting-value {
  width: 32px;
  text-align: right;
  font-size: 13px;
  color: #4d2f20;
  font-weight: 500;
}

.setting-item select {
  padding: 5px 8px;
  border-radius: 4px;
  border: 1px solid #ccc;
  background-color: white;
  font-size: 13px;
  color: #4d2f20;
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
  color: #4d2f20;
  transition: all 0.2s;
  width: 100%;
}

.reset-btn:hover {
  background-color: #e9ecef;
  border-color: #3E5C2B;
  color: #3E5C2B;
}

.stats-panel {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-between;
  margin-bottom: 20px;
  gap: 15px;
}

.stat-card {
  background-color: white;
  border-radius: 8px;
  padding: 15px;
  width: calc(16.666% - 12.5px);
  text-align: center;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s, box-shadow 0.2s, opacity 0.3s;
}

.stat-card.disabled {
  opacity: 0.5;
  background-color: #f8f8f8;
  box-shadow: none;
  transform: scale(0.98);
}

.stat-card.disabled .stat-number {
  color: #999;
}

.stat-card:hover:not(.disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.stat-card h3 {
  margin: 0 0 10px 0;
  font-size: 10px;
  color: #4d2f20;
}

.stat-number {
  font-size: 24px;
  font-weight: bold;
  color: #3E5C2B;
}

.instructions {
  background-color: white;
  border-radius: 8px;
  padding: 24px;
  margin-top: 25px;
  border: 1px solid #e9ecef;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.instructions h3 {
  margin-top: 0;
  margin-bottom: 18px;
  color: #4d2f20;
  font-size: 18px;
  font-weight: 600;
  text-align: center;
  border-bottom: 2px solid #3E5C2B;
  padding-bottom: 8px;
}

.instructions ul {
  padding-left: 20px;
  margin-bottom: 0;
  list-style-type: none;
}

.instructions li {
  margin-bottom: 12px;
  color: #4d2f20;
  line-height: 1.6;
  position: relative;
  padding-left: 40px;
  font-size: 15px;
}

.instructions li:before {
  content: '✓';
  position: absolute;
  left: 10px;
  color: #3E5C2B;
  font-weight: bold;
  font-size: 22px;
}

.instructions li:not([v-if]), 
.instructions li[v-if]:not([style*="display: none"]) {
  padding: 12px 15px 12px 45px;
  background-color: #f8f9fa;
  border-radius: 6px;
  margin-bottom: 10px;
  border-left: 3px solid #3E5C2B;
  transition: all 0.2s ease;
}

.instructions li:not([v-if]):hover, 
.instructions li[v-if]:not([style*="display: none"]):hover {
  background-color: #f0f4f1;
  transform: translateY(-2px);
  box-shadow: 0 3px 10px rgba(0, 0, 0, 0.08);
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
  color: #4d2f20;
}

:deep(.legend) {
  line-height: 18px;
  color: #4d2f20;
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
  color: #4d2f20;
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
  color: #4d2f20;
  font-size: 13px;
  white-space: normal;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 1.4;
}

:deep(.tooltip-details p strong) {
  color: #3E5C2B;
}

:deep(.location-search) {
  margin-top: 0 !important;
  padding-top: 0 !important;
  border-top: none !important;
}

:deep(.search-title) {
  font-weight: bold;
  margin-bottom: 12px;
  font-size: 16px;
  color: #4d2f20;
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
  background-color: #3E5C2B;
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
  color: #3E5C2B !important;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3) !important;
  filter: drop-shadow(0 4px 12px rgba(62, 92, 43, 0.5)) !important;
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

:deep(footer) {
  margin-top: auto;
  position: relative;
  width: 100%;
  bottom: 0;
}

.resource-map-header {
  background-color: white;
  padding: 15px 20px;
  border-radius: 8px 8px 0 0;
  margin-bottom: 0;
  border: 1px solid #e9ecef;
  border-bottom: none;
  text-align: center;
  z-index: 2;
  position: relative;
}

.resource-map-header h2 {
  color: #4d2f20;
  margin: 0 0 8px 0;
  font-size: 20px;
  font-weight: 600;
}

.resource-map-header p {
  color: #4d2f20;
  margin: 0;
  font-size: 15px;
  line-height: 1.4;
  max-width: 800px;
  margin: 0 auto;
}

.map-debug-info {
  position: absolute;
  bottom: 10px;
  right: 10px;
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  padding: 5px 10px;
  border-radius: 4px;
  font-size: 12px;
  z-index: 1000;
  max-width: 80%;
  word-break: break-all;
}

.map-info-banner .info-content p {
  margin: 0;
  color: #4d2f20;
  font-size: 13px;
  line-height: 1.3;
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
  
  .unified-page-container {
    padding: 15px;
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
  
  .unified-page-container {
    padding: 10px;
  }
  
  .checkbox-group {
    flex-direction: column;
    gap: 8px;
  }
  
  .checkbox-group label {
    justify-content: flex-start;
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
  
  :deep(.autocomplete-wrapper input) {
    padding: 8px 12px;
    font-size: 14px;
    min-height: 38px;
  }
  
  :deep(.search-button) {
    width: 42px;
    min-height: 38px;
  }
  
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

:deep(.custom-popup) {
  background-color: white;
  border-radius: 8px;
  padding: 0;
  box-shadow: 0 3px 14px rgba(0, 0, 0, 0.2);
  border: none;
  overflow: hidden;
  width: 300px;
}

:deep(.leaflet-popup-content-wrapper) {
  padding: 0;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: none;
}

:deep(.leaflet-popup-content) {
  margin: 0;
  width: 100% !important;
}

:deep(.leaflet-popup-tip-container) {
  display: none;
}

:deep(.tooltip-content) {
  width: 100%;
  padding: 0;
}

:deep(.tooltip-header) {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 15px 15px 12px;
  border-bottom: 1px solid #eee;
  background-color: #fff;
}

:deep(.tooltip-content h3) {
  margin: 0;
  color: #4d2f20;
  font-size: 18px;
  font-weight: 600;
  line-height: 1.2;
  padding-right: 15px;
  flex: 1;
}

:deep(.close-tooltip) {
  background: transparent;
  border: none;
  color: #666;
  font-size: 22px;
  cursor: pointer;
  padding: 0;
  margin: -5px -5px 0 0;
  line-height: 1;
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
}

:deep(.close-tooltip:hover) {
  color: #333;
}

:deep(.tooltip-details) {
  display: flex;
  flex-direction: column;
  padding: 15px;
}

:deep(.tooltip-details p) {
  margin: 0 0 10px 0;
  color: #4d2f20;
  font-size: 14px;
  line-height: 1.5;
}

:deep(.tooltip-details p:last-child) {
  margin-bottom: 0;
}

:deep(.tooltip-details p strong) {
  color: #3E5C2B;
  font-weight: 600;
  display: block;
  margin-bottom: 2px;
}

:deep(.tooltip-link) {
  color: #3E5C2B;
  text-decoration: none;
  transition: color 0.2s ease;
  word-break: break-all;
}

:deep(.tooltip-link:hover) {
  color: #517A39;
  text-decoration: underline;
}

:deep(.leaflet-popup-close-button) {
  display: none;
}
</style>