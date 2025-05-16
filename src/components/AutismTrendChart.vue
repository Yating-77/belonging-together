
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
import { LineChart } from "echarts/charts";
import {
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent
} from "echarts/components";
import VChart from "vue-echarts";

use([
  CanvasRenderer,
  LineChart,
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent
]);

export default {
  name: "AutismTrendChart",
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
          text: "Autism Prevalence by Age Group (2015, 2018, 2022)",
          left: "center",
          top: 20,
          textStyle: { color: "#000000", fontSize: 18, fontWeight: "bold" }
        },
        tooltip: {
          trigger: "axis",
          axisPointer: { type: "cross" },
          formatter: function(params) {
            const ageGroup = params[0].axisValue;
            let result = `<div style="font-weight:bold;margin-bottom:5px;">Age Group: ${ageGroup}</div>`;
            params.sort((a, b) => b.value - a.value);
            params.forEach(param => {
              const year = param.seriesName;
              const color = param.color;
              const value = param.value;
              result += `<div style="display:flex;align-items:center;margin:3px 0;">
                         <span style="display:inline-block;width:10px;height:10px;background:${color};margin-right:5px;"></span>
                         <span>${year}: ${value}%</span>
                       </div>`;
            });
            return result;
          },
          textStyle: { color: "#000000" },
          backgroundColor: "rgba(255, 255, 255, 0.9)"
        },
        legend: {
          data: [],
          right: 30,
          top: 50,
          itemWidth: 15,
          itemHeight: 10,
          textStyle: { color: "#000000" }
        },
        grid: {
          left: "5%",
          right: "5%",
          bottom: "15%",
          top: "20%",
          containLabel: true
        },
        xAxis: {
          type: "category",
          data: [],
          name: "Age Group",
          nameLocation: "middle",
          nameGap: 35,
          nameTextStyle: { color: "#000000", fontSize: 14, fontWeight: "bold" },
          axisLabel: { color: "#000000", fontSize: 12 },
          axisLine: { lineStyle: { color: "#000000" }},
          axisTick: { alignWithLabel: true },
          splitLine: { show: false }
        },
        yAxis: {
          type: "value",
          name: "Autism Prevalence (%)",
          nameLocation: "middle",
          nameGap: 40,
          nameTextStyle: { color: "#000000", fontSize: 14, fontWeight: "bold" },
          min: 0,
          max: 5,
          interval: 0.5,
          axisLabel: { color: "#000000", fontSize: 12, formatter: "{value}%" },
          axisLine: { lineStyle: { color: "#000000" }},
          splitLine: { lineStyle: { type: 'dashed', color: "#DDDDDD" }}
        },
        series: [],
        animationEasing: "cubicInOut",
        animationDelayUpdate: function(idx) { return idx * 200; }
      }
    };
  },

  methods: {
    async loadChartData() {
      this.isLoading = true;
      this.errorLoading = false;
      try {
        const response = await apiService.getPrevalenceTrends();
        if (response && response.data && response.data.success) {
          const apiData = response.data.data;
          this.chartOption.xAxis.data = apiData.xAxis;
          this.chartOption.legend.data = apiData.series.map(s => s.name);
          this.chartOption.series = apiData.series.map((backendSeries, index) => {
            let frontendStyle = {};
            if (backendSeries.name === '2015') {
              frontendStyle = { itemStyle: { color: '#f1c40f' }, lineStyle: { color: '#f1c40f' } };
            } else if (backendSeries.name === '2018') {
              frontendStyle = { itemStyle: { color: '#e67e22' }, lineStyle: { color: '#e67e22' } };
            } else if (backendSeries.name === '2022') {
              frontendStyle = { itemStyle: { color: '#e74c3c' }, lineStyle: { color: '#e74c3c' } };
            }
            return {
              ...backendSeries,
              ...frontendStyle,
              symbol: 'circle',
              symbolSize: 8,
              lineStyle: {
                ...(frontendStyle.lineStyle || {}),
                width: 2
              },
              label: { show: true, position: 'top', formatter: '{c}%', fontSize: 12, color: '#000000' },
              emphasis: {
                itemStyle: {
                  shadowBlur: 10,
                  shadowColor: frontendStyle.itemStyle?.color ? `${frontendStyle.itemStyle.color}80` : 'rgba(0, 0, 0, 0.3)'
                }
              },
              animationDuration: 4000,
              animationEasing: "cubicInOut",
              animationDelay: index * 200
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
