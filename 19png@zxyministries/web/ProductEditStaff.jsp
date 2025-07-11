<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="domain.Products" %>
<%@ page import="da.ProductDAO" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Product</title>
    <link rel="icon" type="image/x-icon" href="img/Logo/logo4.png"> <!--this is an icon-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #1a5d42;
            --primary-light: #2d8e66;
            --secondary: #f8f9fa;
            --accent: #ffc107;
            --dark: #343a40;
            --light: #f8f9fa;
            --success: #28a745;
            --danger: #dc3545;
            --warning: #ffc107;
            --info: #17a2b8;
            --border-radius: 8px;
            --box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        /* Header */
        .header {
            background-color: white;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 100;
            margin-bottom: 30px;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .logo {
            display: flex;
            align-items: center;
        }

        .logo h1 {
            font-size: 1.8rem;
            margin-left: 10px;
            color: var(--primary);
        }

        .logo i {
            font-size: 2rem;
            color: var(--primary);
        }

        .breadcrumb {
            display: flex;
            align-items: center;
            font-size: 0.9rem;
            color: #6c757d;
        }

        .breadcrumb a {
            color: var(--primary);
            text-decoration: none;
            transition: var(--transition);
            display: flex;
            align-items: center;
        }

        .breadcrumb a:hover {
            color: var(--primary-light);
        }

        .breadcrumb i {
            margin: 0 8px;
            font-size: 0.8rem;
        }

        .breadcrumb span {
            font-weight: 500;
        }

        /* Container */
        .container {
            max-width: 800px;
            margin: 0 auto 40px;
            padding: 0 20px;
        }

        /* Card */
        .card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
        }

        .card-header {
            background-color: var(--primary);
            color: white;
            padding: 20px 25px;
        }

        .card-title {
            font-size: 1.4rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-body {
            padding: 30px 25px;
        }

        /* Alert Messages */
        .alert {
            padding: 15px;
            border-radius: var(--border-radius);
            margin-bottom: 25px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .alert i {
            font-size: 1.2rem;
            margin-top: 2px;
        }

        .alert-info {
            background-color: rgba(23, 162, 184, 0.1);
            color: var(--info);
            border-left: 4px solid var(--info);
        }

        .alert-danger {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }

        .alert-title {
            font-weight: 600;
            margin-bottom: 5px;
        }

        .product-id-badge {
            display: inline-block;
            padding: 4px 10px;
            background: rgba(255, 255, 255, 0.2);
            border-radius: 30px;
            font-size: 0.9rem;
            margin-left: 10px;
        }

        /* Form Styling */
        .form-group {
            margin-bottom: 25px;
        }

        .form-group:last-child {
            margin-bottom: 0;
        }

        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
            font-size: 0.95rem;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
            background-color: white;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(26, 93, 66, 0.1);
        }

        .form-text {
            color: #6c757d;
            font-size: 0.85rem;
            margin-top: 5px;
        }

        .input-group {
            display: flex;
            align-items: center;
        }

        .input-group-text {
            padding: 12px 15px;
            background-color: #e9ecef;
            border: 1px solid #ddd;
            border-right: none;
            border-radius: var(--border-radius) 0 0 var(--border-radius);
            font-weight: 500;
        }

        .input-group .form-control {
            border-radius: 0 var(--border-radius) var(--border-radius) 0;
        }

        /* File Upload */
        .file-upload {
            position: relative;
            display: inline-block;
            width: 100%;
        }

        .file-upload-input {
            position: relative;
            z-index: 2;
            width: 100%;
            height: 100%;
            padding: 12px 15px;
            margin: 0;
            outline: none;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: var(--border-radius);
            color: #333;
            font-size: 1rem;
            cursor: pointer;
            transition: var(--transition);
        }

        .file-upload-input:hover {
            border-color: #adb5bd;
        }

        .current-image {
            margin-top: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .image-preview {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: var(--border-radius);
            border: 1px solid #ddd;
            padding: 2px;
            background-color: white;
        }

        .image-info {
            font-size: 0.9rem;
            color: #6c757d;
        }

        /* Buttons */
        .form-actions {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 20px;
            border-radius: var(--border-radius);
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            border: none;
            font-size: 1rem;
            gap: 8px;
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
            flex-grow: 2;
        }

        .btn-primary:hover {
            background-color: var(--primary-light);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background-color: #e9ecef;
            color: var(--dark);
            flex-grow: 1;
        }

        .btn-secondary:hover {
            background-color: #dde2e6;
            transform: translateY(-2px);
        }

        /* Select Dropdown Styling */
        select.form-control {
            appearance: none;
            background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="12" height="6"><path d="M0,0 L12,0 L6,6 Z" fill="%236c757d"/></svg>');
            background-repeat: no-repeat;
            background-position: right 15px center;
            padding-right: 30px;
        }

        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.5s ease forwards;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .card-body {
                padding: 20px 15px;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <i class="fas fa-box"></i>
                <h1>Product Manager</h1>
            </div>
            <div class="breadcrumb">
                <a href="Staff_Product.jsp">
                    <i class="fas fa-home"></i> Dashboard
                </a>
                <i class="fas fa-chevron-right"></i>
                <span>Edit Product</span>
            </div>
        </div>
    </header>

    <div class="container fade-in">
        <%
            String productId = request.getParameter("product_id");
            // Debug output
            System.out.println("Attempting to edit product with ID: " + productId);
            
            ProductDAO productDAO = new ProductDAO();
            Products product = productDAO.getProductById(productId);
            
            // More debug output
            if (product == null) {
                System.out.println("Product not found in database");
            } else {
                System.out.println("Successfully retrieved product: " + product.getProductName());
            }
            
            if (product == null) {
        %>
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-exclamation-triangle"></i> Product Not Found
                    </h2>
                </div>
                <div class="card-body">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <div>
                            <div class="alert-title">Error</div>
                            <p>The product you are trying to edit could not be found. Please return to the product list and try again.</p>
                        </div>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" onclick="location.href='Staff_Product.jsp'" class="btn btn-primary">
                            <i class="fas fa-arrow-left"></i> Back to Products
                        </button>
                    </div>
                </div>
            </div>
        <%
                return;
            }
        %>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-edit"></i> Edit Product
                    <span class="product-id-badge">ID: <%= product.getProductId() %></span>
                </h2>
            </div>
            <div class="card-body">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <div class="alert-title">Product Information</div>
                        <p>You are editing product details. All fields are required except the image upload which is optional.</p>
                    </div>
                </div>

                <form method="POST" action="UpdateProductServlet" enctype="multipart/form-data">
                    <input type="hidden" name="product_id" value="<%= product.getProductId() %>">
                    <input type="hidden" name="referrer" value="staff">
                    <div class="form-group">
                        <label for="productName" class="form-label">
                            <i class="fas fa-tag"></i> Product Name
                        </label>
                        <input type="text" id="productName" name="product_name" value="<%= product.getProductName() %>" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="categoryId" class="form-label">
                            <i class="fas fa-folder"></i> Category
                        </label>
                        <select id="categoryId" name="category_id" class="form-control" required>
                            <option value="CT001" <%= product.getCategoryId().equals("CT001") ? "selected" : "" %>>Cleansers</option>
                            <option value="CT002" <%= product.getCategoryId().equals("CT002") ? "selected" : "" %>>Exfolitators & Masks</option>
                            <option value="CT003" <%= product.getCategoryId().equals("CT003") ? "selected" : "" %>>Serums & Treatments</option>
                            <option value="CT004" <%= product.getCategoryId().equals("CT004") ? "selected" : "" %>>Special Care</option>
                            <option value="CT005" <%= product.getCategoryId().equals("CT005") ? "selected" : "" %>>Sunscreens</option>
                            <option value="CT006" <%= product.getCategoryId().equals("CT006") ? "selected" : "" %>>Toners & Mists</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="price" class="form-label">
                            <i class="fas fa-money-bill-wave"></i> Price
                        </label>
                        <div class="input-group">
                            <div class="input-group-text">RM</div>
                            <input type="number" step="0.01" id="price" name="price" value="<%= product.getPrice() %>" class="form-control" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="stockQty" class="form-label">
                            <i class="fas fa-warehouse"></i> Stock Quantity
                        </label>
                        <input type="number" id="stockQty" name="stock_qty" value="<%= product.getStockQty() %>" class="form-control" required>
                    </div>
                    
                    <div class="form-group">
        <label class="form-label" for="image">Product Image</label>
        <div class="file-upload">
            <input type="file" name="image" id="image" class="file-upload-input" accept="image/*">
        </div>
        <% if (product != null && product.getImageUrl() != null) { %>
        <div class="current-image">
            <img src="<%= product.getImageUrl() %>" alt="Current product image" class="image-preview">
            <div class="image-info">
                Current image: <%= product.getImageUrl().substring(product.getImageUrl().lastIndexOf("/") + 1) %>
            </div>
        </div>
        <% } %>
    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <button type="button" onclick="location.href='Staff_Product.jsp'" class="btn btn-secondary">
                            <i class="fas fa-times"></i> Cancel
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Highlight current fields with validation
        const formControls = document.querySelectorAll('.form-control');
        formControls.forEach(control => {
            control.addEventListener('focus', function() {
                this.classList.add('is-focused');
            });
            
            control.addEventListener('blur', function() {
                this.classList.remove('is-focused');
                if (this.value) {
                    this.classList.add('is-filled');
                } else {
                    this.classList.remove('is-filled');
                }
            });
            
            // Check initial state
            if (control.value) {
                control.classList.add('is-filled');
            }
        });
    </script>
</body>
</html>