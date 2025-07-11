<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="domain.Categories"%>
<%@page import="domain.Subcategories"%>
<%@page import="da.Category_AdminDAO"%>
<%@page import="da.Subcategory_AdminDAO"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add New Product</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/admin.css">
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-12">
                <h2>Add New Product</h2>
                <hr>
                
                <% 
                    // Get messages from session
                    String errorMessage = (String) request.getSession().getAttribute("errorMessage");
                    String successMessage = (String) request.getSession().getAttribute("successMessage");
                    
                    // Clear messages after displaying
                    request.getSession().removeAttribute("errorMessage");
                    request.getSession().removeAttribute("successMessage");
                    
                    // Get category data
                    Category_AdminDAO categoryDAO = new Category_AdminDAO();
                    List<Categories> categories = categoryDAO.getAllCategories();
                    
                    // Get selected category if any
                    String selectedCategoryId = request.getParameter("categoryId");
                    
                    // Get subcategories if category is selected
                    List<Subcategories> subcategories = null;
                    if (selectedCategoryId != null && !selectedCategoryId.isEmpty()) {
                        Subcategory_AdminDAO subcategoryDAO = new Subcategory_AdminDAO();
                        subcategories = subcategoryDAO.getSubcategoriesByCategory(selectedCategoryId);
                    }
                %>
                
                <% if (successMessage != null) { %>
                    <div class="alert alert-success">
                        <%= successMessage %>
                    </div>
                <% } %>
                <% if (errorMessage != null) { %>
                    <div class="alert alert-danger">
                        <%= errorMessage %>
                    </div>
                <% } %>

                <form action="AddProductServlet" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="productName">Product Name</label>
                        <input type="text" class="form-control" id="productName" name="productName" required>
                    </div>

                    <div class="form-group">
                        <label for="categoryId">Category</label>
                        <select class="form-control" id="categoryId" name="categoryId" required onchange="updateSubcategories(this.value)">
                            <option value="">Select Category</option>
                            <% for (Categories category : categories) { %>
                                <option value="<%= category.getCategoryId() %>" 
                                    <%= (selectedCategoryId != null && selectedCategoryId.equals(category.getCategoryId())) ? "selected" : "" %>>
                                    <%= category.getCategoryName() %>
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="subcategoryId">Subcategory</label>
                        <select class="form-control" id="subcategoryId" name="subcategoryId" required>
                            <option value="">Select Subcategory</option>
                            <% if (subcategories != null) {
                                for (Subcategories subcategory : subcategories) { %>
                                    <option value="<%= subcategory.getSubcategoryId() %>">
                                        <%= subcategory.getSubcategoryName() %>
                                    </option>
                                <% }
                            } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="price">Price (RM)</label>
                        <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="stockQty">Stock Quantity</label>
                        <input type="number" class="form-control" id="stockQty" name="stockQty" min="0" required>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="4" required></textarea>
                    </div>

                    <div class="form-group">
                        <label for="image">Product Image</label>
                        <input type="file" class="form-control-file" id="image" name="image" accept="product_image/*" required>
                        <div id="imagePreview" class="mt-2"></div>
                    </div>

                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Add Product</button>
                        <a href="Product_Admin.jsp" class="btn btn-secondary ml-2">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>
        // Image preview functionality
        document.getElementById('image').addEventListener('change', function(e) {
            const file = e.target.files[0];
            const preview = document.getElementById('imagePreview');
            
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = `<img src="${e.target.result}" style="max-width: 200px; margin-top: 10px;">`;
                }
                reader.readAsDataURL(file);
            } else {
                preview.innerHTML = '';
            }
        });

        // Function to update subcategories when category changes
        function updateSubcategories(categoryId) {
            if (categoryId) {
                window.location.href = 'AddProduct.jsp?categoryId=' + categoryId;
            }
        }
    </script>
</body>
</html>