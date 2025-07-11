const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('show');
        }
    });
}, {
    threshold: 0.3
});

const hiddenElements = document.querySelectorAll('.info-block');
hiddenElements.forEach(el => observer.observe(el));

document.getElementById("searchButton").addEventListener("click", function () {
    const query = document.getElementById("searchInput").value.trim();
    if (query) {
        // Redirect to a search results page with the query string
        window.location.href = `search_results.jsp?query=${encodeURIComponent(query)}`;
    }
});

// Optional: Allow pressing "Enter" to search
document.getElementById("searchInput").addEventListener("keypress", function (e) {
    if (e.key === "Enter") {
        document.getElementById("searchButton").click();
    }
});