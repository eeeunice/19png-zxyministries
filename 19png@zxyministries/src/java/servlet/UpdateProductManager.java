package servlet;

import da.ProductDAO;
import domain.Products;
import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.util.logging.Logger;
import java.util.logging.Level;


@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1MB
    maxFileSize = 1024 * 1024 * 10,     // 10MB
    maxRequestSize = 1024 * 1024 * 15    // 15MB
)
public class UpdateProductManager extends HttpServlet {

    private static final Logger logger = Logger.getLogger(UpdateProductServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8"); // Set character encoding
        request.setCharacterEncoding("UTF-8"); // Set character encoding for request

        logger.log(Level.INFO, "Starting doPost method");

        try {
            // Get form parameters
            String productId = request.getParameter("product_id");
            String productName = request.getParameter("product_name");
            String categoryId = request.getParameter("category_id");
            String subcategoryId = request.getParameter("subcategory_id");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQty = Integer.parseInt(request.getParameter("stock_qty"));
            
            // Get the referrer parameter to determine which page to redirect to
            String referrer = request.getParameter("referrer");
            logger.log(Level.FINE, "Referrer: {0}", referrer);

            logger.log(Level.FINE, "Received parameters: productId={0}, productName={1}, categoryId={2}, subcategoryId={3}, description={4}, price={5}, stockQty={6}",
                    new Object[]{productId, productName, categoryId, subcategoryId, description, price, stockQty});

            // Handle file upload
            Part filePart = request.getPart("image");
            String imagePath = null;

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                logger.log(Level.FINE, "Original filename: {0}", fileName);

                // Generate unique filename
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                logger.log(Level.FINE, "Unique filename: {0}", uniqueFileName);

                // Get the absolute path for the images directory
                String uploadPath = request.getServletContext().getRealPath("") + File.separator + "images";
                logger.log(Level.FINE, "Upload path: {0}", uploadPath);

                // Create directory if it doesn't exist
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    boolean dirCreated = uploadDir.mkdir();
                    if (dirCreated) {
                        logger.log(Level.INFO, "Directory created: {0}", uploadPath);
                    } else {
                        logger.log(Level.WARNING, "Failed to create directory: {0}", uploadPath);
                    }
                }

                // Save the file
                String filePath = uploadPath + File.separator + uniqueFileName;
                logger.log(Level.FINE, "Saving file to: {0}", filePath);
                filePart.write(filePath);
                logger.log(Level.INFO, "File saved successfully to: {0}", filePath);

                // Set the relative path for database storage
                imagePath = "images/" + uniqueFileName;
                logger.log(Level.FINE, "Image path for database: {0}", imagePath);
            } else {
                logger.log(Level.FINE, "No new image uploaded.");
            }

            // Create Products object
            Products product = new Products();
            product.setProductId(productId);
            product.setProductName(productName);
            product.setCategoryId(categoryId);
            product.setSubcategoryId(subcategoryId);
            product.setDescription(description);
            product.setPrice(price);
            product.setStockQty(stockQty);

            // Only update image path if a new image was uploaded
            if (imagePath != null) {
                product.setImageUrl(imagePath);
                logger.log(Level.FINE, "Setting new image URL: {0}", imagePath);
            } else {
                // Keep existing image path
                ProductDAO dao = new ProductDAO();
                Products existingProduct = dao.getProductById(productId);
                if (existingProduct != null) {
                    product.setImageUrl(existingProduct.getImageUrl());
                    logger.log(Level.FINE, "Keeping existing image URL: {0}", existingProduct.getImageUrl());
                } else {
                    logger.log(Level.WARNING, "Existing product not found with ID: {0}", productId);
                }
            }

            // Update product in database
            ProductDAO productDAO = new ProductDAO();
            boolean success = productDAO.updateProduct(product);

            if (success) {
                logger.log(Level.INFO, "Product updated successfully in database.");
                
                // Determine which page to redirect to based on the referrer
                if ("staff".equals(referrer)) {
                    response.sendRedirect("Staff_Product.jsp?success=true");
                } else {
                    // Default to Product_Admin.jsp for managers or if referrer is not specified
                    response.sendRedirect("Product_Admin.jsp?success=true");
                }
            } else {
                logger.log(Level.SEVERE, "Failed to update product in database.");
                
                // Determine which edit page to redirect to based on the referrer
                if ("staff".equals(referrer)) {
                    response.sendRedirect("ProductEditStaff.jsp?product_id=" + productId + "&error=true");
                } else {
                    response.sendRedirect("ProductEdit.jsp?product_id=" + productId + "&error=true");
                }
            }

        } catch (Exception e) {
            logger.log(Level.SEVERE, "An exception occurred", e);
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage()); // Set error message
            
            // Get the referrer parameter to determine which page to redirect to
            String referrer = request.getParameter("referrer");
            if ("staff".equals(referrer)) {
                response.sendRedirect("ProductEditStaff.jsp?error=true");
            } else {
                response.sendRedirect("ProductEdit.jsp?error=true"); // Redirect to error page
            }
        }
    }

    private String getSubmittedFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String filename = token.substring(token.indexOf("=") + 2, token.length() - 1);
                // Unescape quotes
                return filename.replace("\"", "");
            }
        }
        return "";
    }
}