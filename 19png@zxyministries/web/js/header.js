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
