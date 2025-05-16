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
  LegendComponent
} from "echarts/components";
import VChart from "vue-echarts";

use([
  CanvasRenderer,
  BarChart,
  TitleComponent,
  TooltipComponent,
  GridComponent,
  LegendComponent
]);

export default {
  name: "AutismBarChart",
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
          text: "Percentage of Autism-Related Behavioral Difficulties",
          left: "center",
          top: 20,
          textStyle: {
            color: "#000000",
            fontWeight: "bold"
          }
        },
        tooltip: {
          trigger: "axis",
          axisPointer: { type: "shadow" },
          formatter: "{b}: {c}%",
          textStyle: { color: "#000000" },
          backgroundColor: "rgba(255, 255, 255, 0.9)"
        },
        grid: {
          left: "5%",
          right: "10%",
          bottom: "15%",
          top: "15%",
          containLabel: true
        },
        xAxis: {
          type: "value",
          max: 100,
          axisLabel: { color: "#000000", formatter: "{value}%" },
          axisLine: { lineStyle: { color: "rgba(0, 0, 0, 0.3)" }},
          splitLine: { lineStyle: { color: "rgba(0, 0, 0, 0.1)" }}
        },
        yAxis: {
          type: "category",
          data: [],
          axisLabel: { color: "#000000" },
          axisLine: { lineStyle: { color: "rgba(0, 0, 0, 0.3)" }}
        },
        series: [
          {
            name: "Difficulty Type",
            type: "bar",
            data: [],
            label: {
              show: true,
              position: "right",
              formatter: "{c}%",
              color: "#000000"
            },
            itemStyle: {
              color: new Function("params", `
                const colorStops = [
                  { offset: 0, color: '#ff6b6b' },
                  { offset: 0.5, color: '#ffa502' },
                  { offset: 1, color: '#ffda79' }
                ];
                return {
                  type: 'linear', x: 0, y: 0, x2: 1, y2: 0,
                  colorStops: colorStops,
                  global: false
                };
              `),
              borderRadius: [0, 4, 4, 0]
            },
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowColor: 'rgba(255, 107, 107, 0.6)'
              }
            },
            animationDuration: 4000,
            animationEasing: "cubicInOut"
          }
        ],
        animationEasing: "cubicInOut",
        animationDelayUpdate: function(idx) {
          return idx * 300;
        }
      }
    };
  },
  methods: {
    async loadChartData() {
      this.isLoading = true;
      this.errorLoading = false;
      try {
        const response = await apiService.getBehavioralDifficulties();
        if (response && response.data && response.data.success) {
          const apiData = response.data.data;
          this.chartOption.yAxis.data = apiData.yAxis;
          this.chartOption.series[0].data = apiData.seriesData;
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
