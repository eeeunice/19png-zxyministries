package da;

import domain.Review;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ReviewDAO {
    private Connection connection;

    public ReviewDAO(Connection connection) {
        this.connection = connection;
    }
    
    // Method to generate the next Review ID
    public String generateReviewId() {
        String sql = "SELECT MAX(REVIEWID) AS maxId FROM ADMIN.REVIEW";
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                String maxId = rs.getString("maxId");

                if (maxId != null) {
                    int idNum = Integer.parseInt(maxId.substring(2)) + 1; // Increment the number part
                    return String.format("RD%03d", idNum); // Format as RD001, RD002, etc.
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "RD001"; // Default if no reviews exist
    }

    // Create review
    public boolean addReview(Review review) {
        String sql = "INSERT INTO ADMIN.REVIEW (REVIEWID, CUSTOMERID, RATING, COMMENTS, REVIEWDATE, CREATED_AT, ORDERID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, review.getReviewId());
            stmt.setString(2, review.getCustomerId());
            stmt.setDouble(3, review.getRating());
            stmt.setString(4, review.getComments());
            stmt.setTimestamp(5, new java.sql.Timestamp(review.getReviewDate().getTime()));
            stmt.setTimestamp(6, new java.sql.Timestamp(review.getCreatedAt().getTime()));
            stmt.setString(7, review.getOrderId()); // Set Order ID
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Read (Get a review by ID)
    public Review getReviewById(String reviewId) {
        String sql = "SELECT * FROM ADMIN.REVIEW WHERE REVIEWID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, reviewId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapRowToReview(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Read (Get all reviews)
    public List<Review> getAllReviews() {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM ADMIN.REVIEW";
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                reviews.add(mapRowToReview(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Update
  public boolean updateReview(Review review) {
    String sql = "UPDATE ADMIN.REVIEW SET REPLY = ?, REPLY_AT = ?, REPLY_BY = ? WHERE REVIEWID = ?";
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setString(1, review.getReply());
        stmt.setTimestamp(2, new java.sql.Timestamp(new Date().getTime())); // Current timestamp
        stmt.setString(3, review.getReplyBy());
        stmt.setString(4, review.getReviewId());

        return stmt.executeUpdate() > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    }
}


    // Delete
    public boolean deleteReview(String reviewId) {
        String sql = "DELETE FROM ADMIN.REVIEW WHERE REVIEWID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, reviewId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Review> getReviewsByOrderId(String orderId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM ADMIN.REVIEW WHERE ORDERID = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, orderId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Review review = new Review();
                review.setReviewId(rs.getString("REVIEWID"));
                review.setCustomerId(rs.getString("CUSTOMERID"));
                review.setRating(rs.getDouble("RATING"));
                review.setComments(rs.getString("COMMENTS"));
                review.setReply(rs.getString("REPLY")); // Ensure this column exists
                review.setReplyBy(rs.getString("REPLY_BY")); // Ensure this column exists
                review.setReplyAt(rs.getDate("REPLY_AT")); // Ensure this column exists
                review.setOrderId(rs.getString("ORDERID"));
                reviews.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reviews;
    }

    // Helper method to map ResultSet to Review object
    private Review mapRowToReview(ResultSet rs) throws SQLException {
        Review review = new Review();
        review.setReviewId(rs.getString("REVIEWID"));
        review.setCustomerId(rs.getString("CUSTOMERID"));
        review.setRating(rs.getDouble("RATING"));
        review.setComments(rs.getString("COMMENTS"));
        review.setReviewDate(rs.getTimestamp("REVIEWDATE"));
        review.setCreatedAt(rs.getTimestamp("CREATED_AT"));
        review.setReply(rs.getString("REPLY"));
        review.setReplyAt(rs.getTimestamp("REPLY_AT"));
        review.setReplyBy(rs.getString("REPLY_BY"));
        review.setOrderId(rs.getString("ORDERID"));
        return review;
    }
}