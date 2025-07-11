package servlet;

import domain.CartItem;
import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import da.CartDAO;

@WebServlet(name = "DeleteCartServlet", urlPatterns = {"/DeleteCartServlet"})
public class DeleteCartServlet extends HttpServlet {
    private CartDAO cartDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        cartDAO = new CartDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);  // 使用 false 避免创建新会话
        String productId = request.getParameter("productId");
        
        System.out.println("Attempting to delete product ID: " + productId); // 调试日志

        if (productId != null && !productId.isEmpty() && session != null) {
            try {
                @SuppressWarnings("unchecked")
                Map<String, CartItem> cart = (Map<String, CartItem>) session.getAttribute("cart");
                
                if (cart != null && cart.containsKey(productId)) {
                    // 先获取商品信息用于日志
                    CartItem item = cart.get(productId);
                    System.out.println("Removing item: " + item.getProduct().getProductName());
                    
                    // 删除商品
                    cart.remove(productId);
                    System.out.println("Cart size after removal: " + cart.size());
                    
                    // 如果购物车为空，则从会话中移除购物车
                    if (cart.isEmpty()) {
                        session.removeAttribute("cart");
                        System.out.println("Cart is empty, removing from session");
                    } else {
                        // 更新会话中的购物车
                        session.setAttribute("cart", cart);
                        System.out.println("Updated cart in session");
                    }
                    
                    session.setAttribute("message", "商品已成功从购物车中移除");
                } else {
                    System.out.println("Cart is null or product not found in cart");
                    session.setAttribute("message", "商品不存在于购物车中");
                }
            } catch (Exception e) {
                System.err.println("Error removing item from cart: " + e.getMessage());
                e.printStackTrace();
                session.setAttribute("message", "删除商品时发生错误");
            }
        } else {
            if (session != null) {
                session.setAttribute("message", "未指定要删除的商品");
            }
            System.out.println("Invalid product ID or session");
        }

        // 重定向回购物车页面
        response.sendRedirect(request.getContextPath() + "/ViewCartServlet");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}