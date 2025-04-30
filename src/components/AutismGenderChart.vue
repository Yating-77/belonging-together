
<template>
    <div class="chart-container" ref="chartContainer">
      <div v-if="isLoading" class="loading-indicator">Loading chart data...</div>
      <div v-if="errorLoading" class="error-message">Failed to load data. Please try again later.</div>
      <v-chart class="chart" :option="chartOption" autoresize v-if="chartVisible && !isLoading && !errorLoading" />
    </div>
  </template>
  
  <script>
  import apiService from '@/services/api.js';
  import { use } from "echarts/core";
  import { CanvasRenderer } from "echarts/renderers";
  import { BarChart } from "echarts/charts";
  import {
    TitleComponent,
    TooltipComponent,
    GridComponent,
    LegendComponent,
    MarkLineComponent
  } from "echarts/components";
  import VChart from "vue-echarts";
  
  use([
    CanvasRenderer,
    BarChart,
    TitleComponent,
    TooltipComponent,
    GridComponent,
    LegendComponent,
    MarkLineComponent
  ]);
  
  export default {
    name: "AutismGenderChart",
    components: {
      VChart
    },
    data() {
      return {
        chartVisible: false,
        isLoading: false,
        errorLoading: false,
        chartOption: {
          backgroundColor: "#ffffff",
          title: {
            text: "Autism Prevalence by Age and Gender",
            left: "center",
            top: 20,
            textStyle: {}
          },
          tooltip: {
            trigger: "axis",
            axisPointer: { type: "shadow" },
            formatter: function(params) {
              const age = params[0].axisValue;
              let result = `<div style="font-weight:bold;margin-bottom:5px;">Age Group: ${age}</div>`;
              params.forEach(param => {
                const gender = param.seriesName === 'male' ? 'Male' : 'Female';
                const color = param.color;
                const value = param.value;
                result += `<div style="display:flex;align-items:center;margin:3px 0;">
                             <span style="display:inline-block;width:10px;height:10px;background:${color};margin-right:5px;"></span>
                             <span>${gender}: ${value}%</span>
                           </div>`;
              });
              return result;
            },
            textStyle: { color: "#000000" },
            backgroundColor: "rgba(255, 255, 255, 0.9)"
          },
          legend: {
            data: [
              { name: 'male', icon: 'rect', itemStyle: { color: '#6a89cc' }},
              { name: 'female', icon: 'rect', itemStyle: { color: '#ff6b6b' }}
            ],
            top: 50,
            textStyle: { color: "#000000" }
          },
          grid: {
            left: "5%",
            right: "5%",
            bottom: "15%",
            top: "25%",
            containLabel: true
          },
          xAxis: {
            type: "category",
            data: [],
            axisLabel: { color: "#000000" },
            axisLine: { lineStyle: { color: "rgba(0, 0, 0, 0.3)" }}
          },
          yAxis: {
            type: "value",
            name: "Prevalence (%)",
            nameTextStyle: { color: "#000000" },
            max: 8,
            interval: 1,
            axisLabel: { color: "#000000", formatter: "{value}%" },
            axisLine: { lineStyle: { color: "rgba(0, 0, 0, 0.3)" }},
            splitLine: { lineStyle: { color: "rgba(0, 0, 0, 0.1)" }}
          },
          series: [],
          animationEasing: "cubicInOut",
          animationDelayUpdate: function(idx) { return idx * 300; }
        }
      };
    },
    methods: {
      async loadChartData() {
        this.isLoading = true;
        this.errorLoading = false;
        try {
          const response = await apiService.getGenderAgePrevalence();
          if (response && response.data && response.data.success) {
            const apiData = response.data.data;
            this.chartOption.xAxis.data = apiData.xAxis;
            this.chartOption.series = apiData.series.map(backendSeries => {
              let frontendStyle = {};
              let markLineStyle = {};
  
              if (backendSeries.name === 'male') {
                frontendStyle = {
                  color: '#6a89cc',
                  itemStyle: {
                    color: function(params) {
                      return {
                        type: 'linear', x: 0, y: 0, x2: 0, y2: 1,
                        colorStops: [
                          { offset: 0, color: '#6a89cc' },
                          { offset: 1, color: '#4a69bd' }
                        ],
                        global: false
                      };
                    }
                  },
                  emphasis: { itemStyle: { shadowColor: 'rgba(106, 137, 204, 0.6)' } }
                };
                markLineStyle = {
                  lineStyle: { color: '#6a89cc', width: 2, type: 'solid' },
                  symbol: ['none', 'none'],
                  symbolSize: 4
                };
              } else if (backendSeries.name === 'female') {
                frontendStyle = {
                  color: '#ff6b6b',
                  itemStyle: {
                    color: function(params) {
                      return {
                        type: 'linear', x: 0, y: 0, x2: 0, y2: 1,
                        colorStops: [
                          { offset: 0, color: '#ff6b6b' },
                          { offset: 1, color: '#c0392b' }
                        ],
                        global: false
                      };
                    }
                  },
                  emphasis: { itemStyle: { shadowColor: 'rgba(255, 107, 107, 0.6)' } }
                };
                markLineStyle = {
                  lineStyle: { color: '#ff6b6b', width: 2, type: 'solid' },
                  symbol: ['none', 'none'],
                  symbolSize: 4
                };
              }
  
              return {
                ...backendSeries,
                ...frontendStyle,
                label: { show: true, position: 'top', formatter: '{c}%', fontSize: 12, color: '#000000' },
                barGap: '30%',
                barWidth: '25%',
                animationDuration: 4000,
                animationEasing: "cubicInOut",
                markLine: backendSeries.markLineData ? {
                  silent: true,
                  label: { show: false },
                  data: backendSeries.markLineData,
                  ...markLineStyle
                } : undefined
              };
            });
            this.chartVisible = true;
          } else {
            this.errorLoading = true;
          }
        } catch (error) {
          this.errorLoading = true;
        } finally {
          this.isLoading = false;
        }
      }
    },
    mounted() {
      const options = {
        rootMargin: "0px 0px -150px 0px",
        threshold: 0.1
      };
      const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting && !this.chartVisible && !this.isLoading) {
            this.loadChartData();
            observer.unobserve(entry.target);
          }
        });
      }, options);
  
      if (this.$refs.chartContainer) {
        observer.observe(this.$refs.chartContainer);
      }
    }
  };
  </script>
  <style scoped>
  .chart-container {
    width: 100%;
    height: 450px;
    padding: 10px;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
    min-height: 450px;
    position: relative;
    display: flex;
    justify-content: center;
    align-items: center;
  }
  
  .chart {
    width: 100%;
    height: 100%;
  }
  
  .loading-indicator,
  .error-message {
    text-align: center;
    color: #6c757d;
    font-style: italic;
    padding: 20px;
  }
  
  .error-message {
    color: #dc3545;
    font-weight: bold;
  }
  </style>
  