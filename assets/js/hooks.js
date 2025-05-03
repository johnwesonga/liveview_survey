let Hooks = {}

Hooks.PollChart = {
    mounted() {
        const ctx = this.el.getContext("2d")
        const data = JSON.parse(this.el.dataset.values)
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: data.map(item => item.label),
                datasets: [{
                    label: "Votes",
                    data: data.map(item => item.count),
                    backgroundColor: '#60a5fa'
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: { display: false }
                }
            }
        })
    }
}

export default Hooks