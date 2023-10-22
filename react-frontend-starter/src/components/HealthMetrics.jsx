import Chart from 'chart.js/auto'; // Import the Chart object from 'chart.js/auto'
import React, { useEffect, useRef, useState } from 'react';

function HealthMetrics() {
    const [heartRateData, setHeartRateData] = useState([]);
    const [bloodPressureData, setBloodPressureData] = useState([]);
    const heartRateChartRef = useRef(null);
    const bloodPressureChartRef = useRef(null);

    useEffect(() => {
        const fetchData = async () => {
            try {
                const response = await fetch('http://localhost:3001/health-dashboard/');
                if (response.ok) {
                    const data = await response.json();
                    setHeartRateData([data.heart_rate]); // Wrap the heart rate data in an array
                    setBloodPressureData([data.blood_pressure]); // Wrap the blood pressure data in an array
                } else {
                    console.error('Error fetching health metrics:', response.status);
                }
            } catch (error) {
                console.error('Error fetching health metrics:', error);
            }
        };

        fetchData();
    }, []);

    useEffect(() => {
        if (Array.isArray(heartRateData) && heartRateData.length > 0) {
            const heartRateChartCanvas = heartRateChartRef.current;
            if (heartRateChartCanvas) {
                if (heartRateChartCanvas.chartInstance) {
                    // Destroy the previous chart instance if it exists
                    heartRateChartCanvas.chartInstance.destroy();
                }
                // Create a new chart
                heartRateChartCanvas.chartInstance = new Chart(heartRateChartCanvas, {
                    type: 'line',
                    data: {
                        labels: heartRateData[0].map((entry) => entry.time),
                        datasets: [
                            {
                                label: 'Heart Rate (BPM)',
                                data: heartRateData[0].map((entry) => entry.value),
                                borderColor: 'rgba(255, 99, 132, 0.2)',
                                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                            },
                        ],
                    },
                    options: { responsive: true },
                });
            }
        }
    }, [heartRateData]);

    useEffect(() => {
        if (Array.isArray(bloodPressureData) && bloodPressureData.length > 0) {
            const bloodPressureChartCanvas = bloodPressureChartRef.current;
            if (bloodPressureChartCanvas) {
                if (bloodPressureChartCanvas.chartInstance) {
                    // Destroy the previous chart instance if it exists
                    bloodPressureChartCanvas.chartInstance.destroy();
                }
                // Create a new chart
                bloodPressureChartCanvas.chartInstance = new Chart(bloodPressureChartCanvas, {
                    type: 'line',
                    data: {
                        labels: bloodPressureData[0].map((entry) => entry.time),
                        datasets: [
                            {
                                label: 'Blood Pressure',
                                data: bloodPressureData[0].map((entry) => entry.value),
                                borderColor: 'rgba(54, 162, 235, 0.2)',
                                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                            },
                        ],
                    },
                    options: { responsive: true },
                });
            }
        }
    }, [bloodPressureData]);

    return (
        <div>
            <h2>Health Metrics</h2>
            <div>
                <h3>Heart Rate</h3>
                <canvas ref={heartRateChartRef}></canvas>
            </div>
            <div>
                <h3>Blood Pressure</h3>
                <canvas ref={bloodPressureChartRef}></canvas>
            </div>
        </div>
    );
}

export default HealthMetrics;

//can we chat 