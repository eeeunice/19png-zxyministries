package servlet;

import da.Product_AdminDAO;
import domain.Products;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;


@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class AddProductServlet extends HttpServlet {

    private String getCategoryName(String categoryId) {
        switch (categoryId) {
            case "CT001":
            return "Cleansers";
        case "CT002":
            return "ExfoliatorsMasks"; 
        case "CT003":
            return "SerumsTreatments";
        case "CT004":
            return "SpecialCare"; 
        case "CT005":
            return "Sunscreens"; 
        case "CT006":
            return "TonerMists"; 
        default:
            return "Other";
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String referrer = request.getHeader("Referer");
        String redirectSuccess = "Product_Admin.jsp";
        String redirectError = "AddProduct.jsp";

        if (referrer != null && referrer.contains("AddProductStaff.jsp")) {
            redirectSuccess = "Staff_Product.jsp";
            redirectError = "AddProductStaff.jsp";
        }

        try {
            String productName = request.getParameter("productName");
            String categoryId = request.getParameter("categoryId");
            String subcategoryId = request.getParameter("subcategoryId");
            double price = Double.parseDouble(request.getParameter("price"));
            int stockQty = Integer.parseInt(request.getParameter("stockQty"));
            String description = request.getParameter("description");

            Part filePart = request.getPart("image");
            String imageUrl = null;

            if (filePart != null && filePart.getSize() > 0) {
                String categoryName = getCategoryName(categoryId);

                // Get build path (temporary)
                String buildUploadPath = getServletContext().getRealPath("/img/" + categoryName);
                if (buildUploadPath == null) {
                    throw new ServletException("Upload path could not be resolved.");
                }

                File buildUploadDir = new File(buildUploadPath);
                if (!buildUploadDir.exists()) {
                    boolean created = buildUploadDir.mkdirs();
                    if (!created) {
                        throw new ServletException("Failed to create upload directory.");
                    }
                }

                // Create safe filename
                String originalFileName = filePart.getSubmittedFileName();
                String safeFileName = System.currentTimeMillis() + "_" +
                        originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");

                File savedFile = new File(buildUploadDir, safeFileName);
                filePart.write(savedFile.getAbsolutePath());

                System.out.println("Uploaded to build path: " + savedFile.getAbsolutePath());

                // COPY file to permanent web path (web/img/)
                String webPath = getServletContext().getRealPath("/").replace("build\\web", "web");
                File permanentDir = new File(webPath + "img" + File.separator + categoryName);
                if (!permanentDir.exists()) {
                    permanentDir.mkdirs();
                }

                File permanentFile = new File(permanentDir, safeFileName);
                Files.copy(savedFile.toPath(), permanentFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

                System.out.println("Copied to permanent web path: " + permanentFile.getAbsolutePath());

                // Store relative URL for use in web pages
                imageUrl = "img/" + categoryName + "/" + safeFileName;
            }

            if (productName == null || productName.trim().isEmpty() ||
                categoryId == null || categoryId.trim().isEmpty() ||
                subcategoryId == null || subcategoryId.trim().isEmpty() ||
                price < 0 || stockQty < 0) {
                session.setAttribute("errorMessage", "All fields are required and must be valid.");
                response.sendRedirect(redirectError);
                return;
            }

            Product_AdminDAO productAdminDAO = new Product_AdminDAO();
            String productId = productAdminDAO.generateProductId();

            Products product = new Products();
            product.setProductId(productId);
            product.setProductName(productName);
            product.setCategoryId(categoryId);
            product.setSubcategoryId(subcategoryId);
            product.setPrice(price);
            product.setStockQty(stockQty);
            product.setDescription(description);
            product.setImageUrl(imageUrl);
            product.setStatus("active");

            boolean success = productAdminDAO.addProduct(product);

            if (success) {
                session.setAttribute("successMessage", "Product added successfully!");
                response.sendRedirect(redirectSuccess);
            } else {
                session.setAttribute("errorMessage", "Failed to add product to database.");
                response.sendRedirect(redirectError);
            }

        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid number format for price or stock quantity.");
            response.sendRedirect(redirectError);
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(redirectError);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("Staff_Product.jsp")) {
            response.sendRedirect("AddProductStaff.jsp");
        } else {
            response.sendRedirect("AddProduct.jsp");
        }
    }
}
